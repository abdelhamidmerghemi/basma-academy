<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TeacherProfile;
use App\Models\Course;
use App\Models\Announcement;
use Illuminate\Http\Request;

class TeacherController extends Controller
{
    public function show(Request $request, $id)
    {
        $profile = TeacherProfile::with(['user', 'courses.product', 'courses.streams', 'courses.reviews'])
            ->where('id', $id)
            ->orWhere('user_id', $id)
            ->first();

        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Teacher profile not found.',
            ], 404);
        }

        $userId = $request->user()?->id;

        $courses = $profile->courses->map(function ($c) use ($userId, $profile) {
            $isUnlocked = false;
            if ($userId) {
                $isUnlocked = \App\Models\CourseEnrollment::where('user_id', $userId)
                    ->where('course_id', $c->id)
                    ->where('status', 'active')
                    ->exists();
            }

            $reviewsCount = $c->reviews->count();
            $avgRating    = $reviewsCount > 0 ? round((float) $c->reviews->avg('rating'), 1) : 5.0;

            return [
                'id'              => $c->id,
                'title'           => $c->title,
                'description'     => $c->description,
                'teacher_name'    => $profile->user?->name ?? 'أستاذ المحتوى',
                'teacher_avatar'  => $profile->avatar_path,
                'price_dzd'       => $c->product?->price_dzd ?? 0.00,
                'academic_stream' => $c->streams->first()?->code ?? 'BAC_Sciences',
                'thumbnail_path'  => $c->thumbnail_path,
                'average_rating'  => $avgRating,
                'reviews_count'   => $reviewsCount,
                'is_unlocked'     => $isUnlocked,
            ];
        });

        $announcements = Announcement::with(['author.teacherProfile', 'author.studentProfile'])
            ->where('user_id', $profile->user_id)
            ->latest()
            ->get();

        $allCourseIds = $profile->courses->pluck('id');
        $totalReviewsCount = \App\Models\CourseReview::whereIn('course_id', $allCourseIds)->count();
        $overallAvgRating  = $totalReviewsCount > 0
            ? round((float) \App\Models\CourseReview::whereIn('course_id', $allCourseIds)->avg('rating'), 1)
            : 5.0;

        return response()->json([
            'success' => true,
            'data' => [
                'id'                  => $profile->id,
                'user_id'             => $profile->user_id,
                'name'                => $profile->user?->name ?? 'أستاذ المحتوى',
                'avatar_url'          => $profile->avatar_path,
                'headline'            => $profile->headline ?? 'أستاذ المحتوى في أكاديمية بصمة',
                'bio'                 => $profile->bio ?? 'متخصص في تدريس مناهج البكالوريا وتسهيل المفاهيم للطلاب.',
                'courses_count'       => $courses->count(),
                'announcements_count' => $announcements->count(),
                'average_rating'      => $overallAvgRating,
                'reviews_count'       => $totalReviewsCount,
                'courses'             => $courses,
                'announcements'       => $announcements,
            ]
        ]);
    }
}
