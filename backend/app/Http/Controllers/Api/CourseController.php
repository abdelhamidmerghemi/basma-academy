<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\Subject;
use App\Models\Stream;
use Illuminate\Http\Request;

class CourseController extends Controller
{
        public function subjects(Request $request)
    {
        $streamId   = $request->query('stream_id');
        $streamCode = $request->query('stream_code');

        if ($streamCode) {
            $stream = Stream::where('code', $streamCode)->first();
            $subjects = $stream ? $stream->subjects : Subject::all();
        } elseif ($streamId) {
            $stream = Stream::find($streamId);
            $subjects = $stream ? $stream->subjects : Subject::all();
        } else {
            $subjects = Subject::all();
        }

        return response()->json([
            'success' => true,
            'message' => 'Subjects retrieved successfully',
            'data'    => $subjects,
        ], 200);
    }

        public function index(Request $request)
    {
        $query = Course::with(['teacherProfile.user', 'subject', 'product', 'streams', 'reviews'])
            ->where('is_published', true);

        if ($request->filled('stream_id')) {
            $streamId = $request->input('stream_id');
            $query->whereHas('streams', function ($q) use ($streamId) {
                $q->where('streams.id', $streamId);
            });
        } elseif ($request->filled('stream_code')) {
            $code = $request->input('stream_code');
            $query->whereHas('streams', function ($q) use ($code) {
                $q->where('streams.code', $code);
            });
        }

        if ($request->filled('subject_id')) {
            $query->where('subject_id', $request->input('subject_id'));
        }

        if ($request->filled('search')) {
            $term = '%' . $request->input('search') . '%';
            $query->where(function ($q) use ($term) {
                $q->where('title', 'LIKE', $term)
                  ->orWhere('description', 'LIKE', $term);
            });
        }

        $sortBy = $request->input('sort_by', 'newest');
        if ($sortBy === 'popular') {
            $query->withCount('enrollments')->orderByDesc('enrollments_count');
        } elseif ($sortBy === 'rating') {
            // average_rating is computed from reviews — sort after transform
            $query->latest(); // will re-sort below
        } else {
            $query->latest();
        }

        $courses = $query->get();

        // Transform payload to include teacher_name and average_rating dynamically
        $transformed = $courses->map(function ($c) use ($request) {
            $userId = auth('sanctum')->id();
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
                'teacher_name'    => $c->teacherProfile?->user?->name ?? 'أستاذ المحتوى',
                'teacher_avatar'  => $c->teacherProfile?->avatar_path,
                'price_dzd'       => $c->product?->price_dzd ?? 0.00,
                'academic_stream' => $c->streams->first()?->code ?? 'BAC_Sciences',
                'thumbnail_path'  => $c->thumbnail_path,
                'average_rating'  => $avgRating,
                'reviews_count'   => $reviewsCount,
                'is_unlocked'     => $isUnlocked,
            ];
        });

        // Apply rating sort after transform (average_rating is computed, not stored)
        if ($sortBy === 'rating') {
            $transformed = $transformed->sortByDesc('average_rating')->values();
        }

        return response()->json([
            'success' => true,
            'message' => 'Courses retrieved successfully',
            'data'    => $transformed,
        ], 200);
    }

        public function show(Request $request, $id)
    {
        $course = Course::with([
            'teacherProfile.user',
            'subject',
            'sections.lessons.media',
            'product',
            'streams',
            'reviews.user'
        ])->find($id);

        if (!$course) {
            return response()->json([
                'success' => false,
                'message' => 'Course not found',
            ], 404);
        }

        $userId = auth('sanctum')->id();
        $isUnlocked = false;
        $userProgressMap = collect();

        if ($userId) {
            $isUnlocked = \App\Models\CourseEnrollment::where('user_id', $userId)
                ->where('course_id', $course->id)
                ->where('status', 'active')
                ->exists();

            $userProgressMap = \App\Models\LessonProgress::where('user_id', $userId)
                ->get()
                ->keyBy('lesson_id');
        }

        $allLessons = [];
        foreach ($course->sections as $sec) {
            foreach ($sec->lessons as $l) {
                $progress = $userProgressMap->get($l->id);

                $allLessons[] = [
                    'id'                    => $l->id,
                    'title'                 => $l->title,
                    'section_title'         => $sec->title,
                    'duration_seconds'      => $l->media?->duration_seconds ?? 900,
                    'video_path'            => $l->media?->path ?? 'https://cdn.plyr.io/static/demo/View_From_A_Blue_Moon_Trailer-720p.mp4',
                    'is_preview'            => (bool) $l->is_preview,
                    'summary_text'          => $l->summary_text,
                    'is_completed'          => $progress ? (bool)$progress->is_completed : false,
                    'last_position_seconds' => $progress ? (int)$progress->last_position_seconds : 0,
                ];
            }
        }

        $reviewsCount = $course->reviews->count();
        $avgRating    = $reviewsCount > 0 ? round((float) $course->reviews->avg('rating'), 1) : 5.0;

        $data = [
            'id'              => $course->id,
            'title'           => $course->title,
            'description'     => $course->description,
            'teacher_name'    => $course->teacherProfile?->user?->name ?? 'أستاذ المحتوى',
            'teacher_avatar'  => $course->teacherProfile?->avatar_path,
            'price_dzd'       => $course->product?->price_dzd ?? 0.00,
            'academic_stream' => $course->streams->first()?->code ?? 'BAC_Sciences',
            'thumbnail_path'  => $course->thumbnail_path,
            'average_rating'  => $avgRating,
            'reviews_count'   => $reviewsCount,
            'is_unlocked'     => $isUnlocked,
            'lessons'         => $allLessons,
            'reviews'         => $course->reviews,
        ];

        return response()->json([
            'success' => true,
            'message' => 'Course details retrieved successfully',
            'data'    => $data,
        ], 200);
    }

    /**
     * POST /courses/{id}/reviews
     * Submit or update a review for a course.
     */
    public function storeReview(Request $request, $id)
    {
        $user = \Illuminate\Support\Facades\Auth::user();
        $course = Course::find($id);

        if (!$course) {
            return response()->json([
                'success' => false,
                'message' => 'Course not found',
            ], 404);
        }

        $request->validate([
            'rating'  => 'required|numeric|min:1|max:5',
            'comment' => 'required|string|max:1000',
        ]);

        $review = \App\Models\CourseReview::updateOrCreate(
            [
                'course_id' => $course->id,
                'user_id'   => $user->id,
            ],
            [
                'rating'  => $request->input('rating'),
                'comment' => $request->input('comment'),
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'Review submitted successfully',
            'data'    => $review->load('user'),
        ], 200);
    }
}
