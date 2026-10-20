<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Quiz;
use App\Models\QuizAnswer;
use App\Models\QuizAttempt;
use App\Models\QuizQuestion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class QuizController extends Controller
{
        public function index(Request $request)
    {
        $query = Quiz::withCount('questions')->with('subject:id,name_ar,name_fr,name_en');

        if ($request->filled('lesson_id')) {
            $query->where('lesson_id', $request->input('lesson_id'));
        }

        if ($request->filled('subject_id')) {
            $query->where('subject_id', $request->input('subject_id'));
        }

        $quizzes = $query->latest()->get();

        return response()->json([
            'success' => true,
            'data' => $quizzes,
        ]);
    }

        public function show($id)
    {
        $quiz = Quiz::with(['questions.answers' => function ($query) {
            $query->select('id', 'question_id', 'answer_text');
        }])->find($id);

        if (!$quiz) {
            return response()->json([
                'success' => false,
                'message' => 'اختبار غير موجود',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $quiz,
        ]);
    }

        public function submit(Request $request, $id)
    {
        $quiz = Quiz::with('questions.answers')->find($id);

        if (!$quiz) {
            return response()->json([
                'success' => false,
                'message' => 'اختبار غير موجود',
            ], 404);
        }

        $userAnswers = $request->input('answers', []); // [question_id => answer_id]

        $totalQuestions = $quiz->questions->count();
        $correctCount = 0;
        $totalPoints = 0;
        $earnedPoints = 0;

        $breakdown = [];

        foreach ($quiz->questions as $question) {
            $questionPoints = $question->points ?? 1;
            $totalPoints += $questionPoints;

            $selectedAnswerId = $userAnswers[$question->id] ?? null;
            $correctAnswer = $question->answers->firstWhere('is_correct', true);

            $isCorrect = false;
            if ($selectedAnswerId && $correctAnswer && $selectedAnswerId == $correctAnswer->id) {
                $isCorrect = true;
                $correctCount++;
                $earnedPoints += $questionPoints;
            }

            $breakdown[] = [
                'question_id' => $question->id,
                'question_text' => $question->question_text,
                'selected_answer_id' => $selectedAnswerId ? (int)$selectedAnswerId : null,
                'correct_answer_id' => $correctAnswer ? $correctAnswer->id : null,
                'is_correct' => $isCorrect,
                'explanation' => $correctAnswer ? $correctAnswer->explanation_text : null,
            ];
        }

        $percentageScore = $totalPoints > 0 ? (int)round(($earnedPoints / $totalPoints) * 100) : 0;
        $passed = $percentageScore >= 50;

        $attempt = QuizAttempt::create([
            'user_id' => Auth::id() ?? 1,
            'quiz_id' => $quiz->id,
            'score' => $percentageScore,
            'passed' => $passed,
            'started_at' => now()->subMinutes($quiz->time_limit_minutes ?: 5),
            'completed_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'data' => [
                'attempt_id' => $attempt->id,
                'score' => $percentageScore,
                'correct_count' => $correctCount,
                'total_questions' => $totalQuestions,
                'earned_points' => $earnedPoints,
                'total_points' => $totalPoints,
                'passed' => $passed,
                'breakdown' => $breakdown,
            ],
        ]);
    }
}
