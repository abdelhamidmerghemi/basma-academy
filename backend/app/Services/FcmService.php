<?php

namespace App\Services;

use App\Models\DeviceToken;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FcmService
{
        public static function sendToUser(User $user, string $title, string $body, array $data = []): void
    {
        $tokens = DeviceToken::where('user_id', $user->id)
            ->pluck('fcm_token')
            ->filter()
            ->unique();

        if ($tokens->isEmpty()) {
            Log::info("FCM: No device tokens found for User #{$user->id}");
            return;
        }

        $jsonPath = env('FIREBASE_CREDENTIALS', storage_path('app/firebase-service-account.json'));

        if (!file_exists($jsonPath)) {
            Log::warning("FCM: Admin Firebase JSON file not found at {$jsonPath}");
            return;
        }

        try {
            $credentials = json_decode(file_get_contents($jsonPath), true);
            $projectId   = $credentials['project_id'] ?? null;

            if (!$projectId) {
                Log::error("FCM: Invalid Admin Firebase JSON - missing project_id");
                return;
            }

            $accessToken = static::getAccessToken($credentials);
            if (!$accessToken) {
                Log::error("FCM: Could not obtain OAuth2 token from Admin Firebase JSON");
                return;
            }

            foreach ($tokens as $token) {
                $response = Http::withHeaders([
                    'Authorization' => 'Bearer ' . $accessToken,
                    'Content-Type'  => 'application/json',
                ])->post("https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send", [
                    'message' => [
                        'token'        => $token,
                        'notification' => [
                            'title' => $title,
                            'body'  => $body,
                        ],
                        'data' => array_map('strval', $data),
                    ],
                ]);

                if ($response->successful()) {
                    Log::info("FCM Push sent to User #{$user->id} using Admin Firebase JSON");
                } else {
                    Log::error("FCM Push failed for User #{$user->id}: " . $response->body());
                }
            }
        } catch (\Exception $e) {
            Log::error("FCM Error: " . $e->getMessage());
        }
    }

        private static function getAccessToken(array $credentials): ?string
    {
        return Cache::remember('fcm_admin_access_token', 3000, function () use ($credentials) {
            $clientEmail = $credentials['client_email'] ?? null;
            $privateKey  = $credentials['private_key'] ?? null;

            if (!$clientEmail || !$privateKey) {
                return null;
            }

            $now = time();
            $header = base64_encode(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
            $claim = base64_encode(json_encode([
                'iss'   => $clientEmail,
                'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud'   => 'https://oauth2.googleapis.com/token',
                'exp'   => $now + 3600,
                'iat'   => $now,
            ]));

            $signatureInput = $header . '.' . $claim;
            openssl_sign($signatureInput, $signature, $privateKey, 'SHA256');
            $jwt = $signatureInput . '.' . base64_encode($signature);

            $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion'  => $jwt,
            ]);

            return $response->json('access_token');
        });
    }
}
