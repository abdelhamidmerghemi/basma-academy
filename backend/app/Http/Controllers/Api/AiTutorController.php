<?php

namespace App\Http\Controllers\Api;

use App\Domain\AI\Services\GeminiStreamingService;
use App\Http\Controllers\Controller;
use App\Models\AiConversation;
use App\Models\AiMessage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AiTutorController extends Controller
{
    protected GeminiStreamingService $streamingService;

    public function __construct(GeminiStreamingService $streamingService)
    {
        $this->streamingService = $streamingService;
    }

        public function history(Request $request)
    {
        $user = $request->user();

        $conversation = AiConversation::firstOrCreate([
            'user_id' => $user->id,
        ], [
            'title' => 'BAC AI Session',
        ]);

        $messages = $conversation->messages()
            ->select(['id', 'sender_type', 'content_text', 'attachment_path', 'created_at'])
            ->get();

        return response()->json([
            'success' => true,
            'data'    => [
                'conversation_id' => $conversation->id,
                'messages'        => $messages,
            ],
        ]);
    }

    /**
     * Stream AI responses via Server-Sent Events (SSE) and persist chat & context.
     */
    public function chat(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'prompt'       => 'nullable|string',
            'stream_code'  => 'sometimes|string',
            'image'        => 'sometimes|file|image|max:10240',
            'image_base64' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user = $request->user();
        $prompt = (string) ($request->input('prompt') ?? '');
        $streamCode = (string) ($request->input('stream_code') ?? 'BAC_Sciences');

        $imageBase64 = null;
        $imageMimeType = null;
        $attachmentPath = null;

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $attachmentPath = $file->store('ai_attachments', 'public');
            $imageBase64 = base64_encode(file_get_contents($file->getRealPath()));
            $imageMimeType = $file->getMimeType();
        } elseif ($request->input('image_base64')) {
            $rawBase64 = $request->input('image_base64');
            if (preg_match('/^data:(image\/\w+);base64,/', $rawBase64, $matches)) {
                $imageMimeType = $matches[1];
                $imageBase64 = substr($rawBase64, strpos($rawBase64, ',') + 1);
            } else {
                $imageBase64 = $rawBase64;
                $imageMimeType = 'image/jpeg';
            }
        }

        if (empty($prompt) && empty($imageBase64)) {
            return response()->json([
                'success' => false,
                'message' => 'Either prompt or image must be provided',
            ], 422);
        }

        $conversation = AiConversation::firstOrCreate([
            'user_id' => $user->id,
        ], [
            'title' => 'BAC AI Session',
        ]);

        // Fetch last 10 messages for multi-turn context BEFORE saving the new user message
        $historyMessages = $conversation->messages()
            ->latest('id')
            ->take(10)
            ->get()
            ->reverse()
            ->values()
            ->toArray();

        $savedContent = !empty($prompt) ? $prompt : '📷 [تمرين مرفق بالصورة]';

        AiMessage::create([
            'conversation_id' => $conversation->id,
            'sender_type'     => 'user',
            'content_text'    => $savedContent,
            'attachment_path' => $attachmentPath,
        ]);

        return $this->streamingService->streamTutorResponse(
            $prompt,
            $streamCode,
            $conversation->id,
            $historyMessages,
            $imageBase64,
            $imageMimeType
        );
    }

        public function clearHistory(Request $request)
    {
        $user = $request->user();

        $conversation = AiConversation::where('user_id', $user->id)->first();
        if ($conversation) {
            $conversation->messages()->delete();
        }

        return response()->json([
            'success' => true,
            'message' => 'Conversation cleared successfully',
        ]);
    }
}
