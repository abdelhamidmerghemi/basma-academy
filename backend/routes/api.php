<?php

use App\Http\Controllers\Api\AiTutorController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\FlashcardController;
use App\Http\Controllers\Api\ForumController;
use App\Http\Controllers\Api\LessonProgressController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\QuizController;
use App\Http\Controllers\Api\OrderController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Production API Routes (Basma Academy v2)
|--------------------------------------------------------------------------
*/

Route::post('/auth/check-registration', [AuthController::class, 'checkRegistration']);
Route::post('/auth/send-login-otp', [AuthController::class, 'loginPhoneNumber']);
Route::post('/auth/send-register-otp', [AuthController::class, 'sendRegisterOtp']);
Route::post('/auth/otp', [AuthController::class, 'loginPhoneNumber']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login'])->name('login');
Route::post('/auth/google', [AuthController::class, 'googleLogin']);

Route::get('/subjects', [CourseController::class, 'subjects']);
Route::get('/courses', [CourseController::class, 'index']);
Route::get('/courses/{id}', [CourseController::class, 'show']);
Route::get('/teachers/{id}', [\App\Http\Controllers\Api\TeacherController::class, 'show']);

Route::get('/forum', [ForumController::class, 'index']);
Route::get('/forum/{id}', [ForumController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);

    Route::post('/courses/{id}/reviews', [CourseController::class, 'storeReview']);

    Route::post('/lessons/{id}/progress', [LessonProgressController::class, 'updateProgress']);

    Route::get('/ai/history', [AiTutorController::class, 'history']);
    Route::post('/ai/chat', [AiTutorController::class, 'chat']);
    Route::delete('/ai/clear', [AiTutorController::class, 'clearHistory']);

    Route::get('/flashcard-decks', [FlashcardController::class, 'indexDecks']);
    Route::post('/flashcards/{id}/review', [FlashcardController::class, 'reviewCard']);

    Route::get('/quizzes', [QuizController::class, 'index']);

    // Student Community Forum Space
    Route::post('/forum', [ForumController::class, 'store']);
    Route::post('/forum/{id}/replies', [ForumController::class, 'storeReply']);
    Route::post('/forum/{id}/like', [ForumController::class, 'togglePostLike']);
    Route::post('/forum/{id}/view', [ForumController::class, 'recordView']);
    Route::post('/forum/replies/{id}/like', [ForumController::class, 'toggleReplyLike']);
    Route::post('/forum/replies/{id}/best-answer', [ForumController::class, 'markBestAnswer']);
    Route::get('/quizzes/{id}', [QuizController::class, 'show']);
    Route::post('/quizzes/{id}/submit', [QuizController::class, 'submit']);

    // Orders & Payment Slip Verification
    Route::get('/orders', [OrderController::class, 'index']);
    Route::post('/orders', [OrderController::class, 'store']);

    // Push Notifications
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
    Route::patch('/notifications/{id}/read', [NotificationController::class, 'markRead']);
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllRead']);
    Route::post('/device-token', [NotificationController::class, 'storeDeviceToken']);

    // Announcements Feed
    Route::get('/announcements', [\App\Http\Controllers\Api\AnnouncementController::class, 'index']);
    Route::post('/announcements/{id}/like', [\App\Http\Controllers\Api\AnnouncementController::class, 'like']);
    Route::get('/announcements/{id}/comments', [\App\Http\Controllers\Api\AnnouncementController::class, 'getComments']);
    Route::post('/announcements/{id}/comments', [\App\Http\Controllers\Api\AnnouncementController::class, 'postComment']);
    Route::post('/announcements/{id}/view', [\App\Http\Controllers\Api\AnnouncementController::class, 'recordView']);
});

// v1 API Route Group Alias
Route::prefix('v1')->group(function () {
    Route::post('/auth/check-registration', [AuthController::class, 'checkRegistration']);
    Route::post('/auth/otp', [AuthController::class, 'sendRegisterOtp']);
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/subjects', [CourseController::class, 'subjects']);
        Route::get('/courses', [CourseController::class, 'index']);
        Route::get('/courses/{id}', [CourseController::class, 'show']);
        Route::post('/courses/{id}/reviews', [CourseController::class, 'storeReview']);
        Route::post('/lessons/{id}/progress', [LessonProgressController::class, 'updateProgress']);
        Route::post('/ai/chat', [AiTutorController::class, 'chat']);
        Route::get('/flashcard-decks', [FlashcardController::class, 'indexDecks']);
        Route::post('/flashcards/{id}/review', [FlashcardController::class, 'reviewCard']);
        Route::get('/quizzes', [QuizController::class, 'index']);
        Route::get('/quizzes/{id}', [QuizController::class, 'show']);
        Route::post('/quizzes/{id}/submit', [QuizController::class, 'submit']);
        Route::get('/orders', [OrderController::class, 'index']);
        Route::post('/orders', [OrderController::class, 'store']);
        Route::get('/notifications', [NotificationController::class, 'index']);
        Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
        Route::match(['patch', 'post'], '/notifications/{id}/read', [NotificationController::class, 'markRead']);
        Route::post('/notifications/read-all', [NotificationController::class, 'markAllRead']);
        Route::post('/device-token', [NotificationController::class, 'storeDeviceToken']);
    });
});
