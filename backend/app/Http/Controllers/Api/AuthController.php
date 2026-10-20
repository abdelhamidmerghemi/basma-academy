<?php

namespace App\Http\Controllers\Api;

use App\Domain\Auth\Services\OtpService;
use App\Http\Controllers\Controller;
use App\Models\AcademicYear;
use App\Models\Course;
use App\Models\CourseEnrollment;
use App\Models\DeviceToken;
use App\Models\Notification;
use App\Models\Role;
use App\Models\Stream;
use App\Models\StudentProfile;
use App\Models\User;
use App\Models\UserNotification;
use App\Services\FcmService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    protected OtpService $otpService;

    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }

        public function checkRegistration(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|regex:/^0[567]\d{8}$/|unique:users,phone',
            'email' => 'nullable|email|unique:users,email',
        ], [
            'phone.unique' => 'The phone number is already registered.',
            'email.unique' => 'The email address is already registered.',
            'phone.regex'  => 'The phone field format is invalid.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
                'errors'  => $validator->errors(),
            ], 422);
        }

        return response()->json([
            'success' => true,
            'message' => 'Information valid',
        ], 200);
    }

    /**
     * Step 1 (Login) — Request OTP for login.
     */
    public function loginPhoneNumber(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|regex:/^0[567]\d{8}$/',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user = User::where('phone', $request->phone)->first();
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Account not found. Please register first.',
            ], 404);
        }

        $code = $this->otpService->generateAndStoreOtp($request->phone, 'login');

        return response()->json([
            'success' => true,
            'message' => 'Verification code sent to your phone. Code: ' . $code,
        ], 200);
    }

    /**
     * Step 1 (Register) — Request OTP for registration.
     */
    public function sendRegisterOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|regex:/^0[567]\d{8}$/',
            'email' => 'nullable|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
                'errors'  => $validator->errors(),
            ], 422);
        }

        if (User::where('phone', $request->phone)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Phone number already registered. Please login.',
            ], 400);
        }

        if ($request->filled('email') && User::where('email', $request->email)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Email address already registered. Please login.',
            ], 400);
        }

        $code = $this->otpService->generateAndStoreOtp($request->phone, 'register');

        return response()->json([
            'success' => true,
            'message' => "Verification code sent to your phone. Code: {$code}",
            'code'    => $code,
        ], 200);
    }

    /**
     * Step 2 (Register) — Submit OTP and create user + student_profiles record.
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'            => 'required|string|max:255',
            'phone'           => 'required|string|regex:/^0[567]\d{8}$/|unique:users,phone',
            'code'            => 'required|string|size:6',
            'academic_stream' => 'required|string',
            'email'           => 'required_without:google_id|email|unique:users,email|nullable',
            'google_id'       => 'sometimes|nullable|unique:users,google_id',
            'password'        => 'required_without:google_id|string|min:6|nullable',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
                'errors'  => $validator->errors(),
            ], 422);
        }

        $verified = $this->otpService->verifyOtp($request->phone, $request->code, 'register')
            || $this->otpService->verifyOtp($request->phone, $request->code, 'register_phone');

        if (!$verified) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired verification code.',
            ], 401);
        }

        try {
            $user = User::create([
                'name'              => $request->name,
                'phone'             => $request->phone,
                'email'             => $request->email,
                'google_id'         => $request->google_id,
                'password'          => $request->password ? bcrypt($request->password) : null,
                'phone_verified_at' => now(),
                'email_verified_at' => $request->email ? now() : null,
            ]);

            $studentRole = Role::where('name', 'student')->first();
            if ($studentRole) {
                $user->roles()->attach($studentRole->id);
            }

            $academicYear = AcademicYear::where('is_active', true)->first();
            $stream = Stream::where('code', $request->academic_stream)->first() ?? Stream::first();

            if ($academicYear && $stream) {
                StudentProfile::create([
                    'user_id'          => $user->id,
                    'academic_year_id' => $academicYear->id,
                    'stream_id'        => $stream->id,
                ]);
            }

            if ($request->filled('fcm_token')) {
                DeviceToken::updateOrCreate(
                    ['user_id' => $user->id, 'fcm_token' => $request->fcm_token],
                    ['platform' => $request->input('platform', 'unknown'), 'last_seen_at' => now()]
                );
            }

            $this->sendRegistrationWelcome($user);

        } catch (\Exception $e) {
            Log::error('Registration Error', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Failed to create user account.',
            ], 500);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Account registered successfully',
            'data'    => [
                'user'         => $user->load('studentProfile.stream', 'roles'),
                'access_token' => $token,
                'token_type'   => 'Bearer',
            ]
        ], 200);
    }

        private function sendRegistrationWelcome(User $user): void
    {
        $course1 = Course::find(1) ?? Course::first();
        if ($course1) {
            CourseEnrollment::firstOrCreate([
                'user_id'   => $user->id,
                'course_id' => $course1->id,
            ], [
                'status' => 'active',
            ]);
        }

        $welcomeTitle = "مرحباً بك {$user->name} في أكاديمية بسمة! 🎉";
        $welcomeBody  = "يسعدنا انضمامك إلينا! نتمنى لك رحلة تعلم ممتعة وناجحة في تحضير البكالوريا.";

        $welcomeNotif = Notification::create([
            'title_ar'     => $welcomeTitle,
            'title_fr'     => "Bienvenue {$user->name} sur Basma Academy ! 🎉",
            'title_en'     => "Welcome {$user->name} to Basma Academy! 🎉",
            'body_ar'      => $welcomeBody,
            'body_fr'      => "Nous sommes ravis de vous compter parmi nous !",
            'body_en'      => "We are thrilled to have you join us!",
            'type'         => 'welcome',
            'payload'      => json_encode(['route' => '/dashboard']),
            'is_broadcast' => false,
            'sent_at'      => now(),
        ]);

        UserNotification::create([
            'user_id'         => $user->id,
            'notification_id' => $welcomeNotif->id,
            'is_read'         => false,
        ]);

        FcmService::sendToUser($user, $welcomeTitle, $welcomeBody, ['route' => '/dashboard']);

        $courseTitle = "🎁 هدية التسجيل: تم تفعيل الدورة المجانية لك!";
        $courseBody  = "مبروك {$user->name}! تم منحك إمكانية الوصول المجاني الكامل إلى الدورة الأولى، ابدأ التعلم الآن.";

        $courseNotif = Notification::create([
            'title_ar'     => $courseTitle,
            'title_fr'     => "🎁 Cadeau d'inscription : Accès gratuit au cours !",
            'title_en'     => "🎁 Registration Gift: Free access to course!",
            'body_ar'      => $courseBody,
            'body_fr'      => "Félicitations ! Vous avez obtenu un accès gratuit au premier cours.",
            'body_en'      => "Congratulations! You have been granted free access to the first course.",
            'type'         => 'course',
            'payload'      => json_encode(['route' => '/course-details', 'course_id' => 1]),
            'is_broadcast' => false,
            'sent_at'      => now(),
        ]);

        UserNotification::create([
            'user_id'         => $user->id,
            'notification_id' => $courseNotif->id,
            'is_read'         => false,
        ]);

        FcmService::sendToUser($user, $courseTitle, $courseBody, ['route' => '/course-details', 'course_id' => '1']);
    }

    /**
     * Step 2 (Login) — Submit OTP and log in.
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string|regex:/^0[567]\d{8}$/',
            'code'  => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $verified = $this->otpService->verifyOtp($request->phone, $request->code, 'login');
        if (!$verified) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired verification code.',
            ], 401);
        }

        $user = User::where('phone', $request->phone)->first();
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User account not found.',
            ], 404);
        }

        $user->update([
            'phone_verified_at' => $user->phone_verified_at ?? now(),
            'email_verified_at' => $user->email_verified_at ?? ($user->email ? now() : null),
        ]);

        $user->tokens()->delete();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Logged in successfully',
            'data'    => [
                'user'         => $user->load('studentProfile.stream', 'roles'),
                'access_token' => $token,
                'token_type'   => 'Bearer',
            ]
        ], 200);
    }

    /**
     * Google Authentication endpoint.
     */
    public function googleLogin(Request $request)
    {
        $validator = Validator::make($request->all(), ['id_token' => 'required|string']);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $response = Http::get('https://oauth2.googleapis.com/tokeninfo', ['id_token' => $request->id_token]);

        if ($response->failed() || !isset($response['sub'])) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired Google authentication ID token.',
            ], 401);
        }

        $googleId = $response['sub'];
        $email = $response['email'] ?? null;
        $name = $response['name'] ?? 'Google User';

        $user = User::where('google_id', $googleId)->orWhere('email', $email)->first();

        if ($user) {
            if (!$user->google_id) {
                $user->update(['google_id' => $googleId]);
            }

            $user->tokens()->delete();
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Logged in with Google successfully',
                'data'    => [
                    'user'         => $user->load('studentProfile.stream', 'roles'),
                    'access_token' => $token,
                    'token_type'   => 'Bearer',
                ]
            ], 200);
        }

        return response()->json([
            'success' => false,
            'user_not_found' => true,
            'message' => 'User account not found. Please complete registration.',
            'google_data' => [
                'email'     => $email,
                'name'      => $name,
                'google_id' => $googleId,
            ]
        ], 200);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ], 200);
    }

    public function profile(Request $request)
    {
        return response()->json([
            'success' => true,
            'data'    => $request->user()->load('studentProfile.stream', 'roles'),
        ], 200);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'name'             => 'sometimes|string|max:255',
            'email'            => 'sometimes|nullable|email|unique:users,email,' . $user->id,
            'academic_year_id' => 'sometimes|exists:academic_years,id',
            'stream_id'        => 'sometimes|exists:streams,id',
            'school_name'      => 'sometimes|nullable|string|max:255',
            'wilaya_code'      => 'sometimes|nullable|integer|between:1,58',
            'avatar_path'      => 'sometimes|nullable|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
                'errors'  => $validator->errors(),
            ], 422);
        }

        if ($request->has('name')) {
            $user->name = $request->input('name');
        }
        if ($request->has('email')) {
            $user->email = $request->input('email');
        }
        $user->save();

        $profileData = array_filter([
            'academic_year_id' => $request->input('academic_year_id'),
            'stream_id'        => $request->input('stream_id'),
            'school_name'      => $request->input('school_name'),
            'wilaya_code'      => $request->input('wilaya_code'),
            'avatar_path'      => $request->input('avatar_path'),
        ], fn($val) => !is_null($val));

        if (!empty($profileData)) {
            $user->studentProfile()->updateOrCreate(
                ['user_id' => $user->id],
                $profileData
            );
        }

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data'    => $user->load('studentProfile.stream', 'roles'),
        ], 200);
    }
}
