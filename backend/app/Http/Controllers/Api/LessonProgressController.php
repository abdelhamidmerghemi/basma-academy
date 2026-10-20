<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LessonProgress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LessonProgressController extends Controller
{
        public function updateProgress(Request $request, $lessonId)
    {
        $validator = Validator::make($request->all(), [
            'seconds_watched'       => 'sometimes|integer|min:0',
            'last_position_seconds' => 'sometimes|integer|min:0',
            'is_completed'          => 'sometimes|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $userId = $request->user()->id;

        $progress = LessonProgress::updateOrCreate(
            ['user_id' => $userId, 'lesson_id' => $lessonId],
            [
                'seconds_watched'       => $request->input('seconds_watched', 0),
                'last_position_seconds' => $request->input('last_position_seconds', 0),
                'is_completed'          => $request->input('is_completed', false),
                'last_watched_at'       => now(),
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'Lesson progress saved',
            'data'    => $progress,
        ], 200);
    }
}
