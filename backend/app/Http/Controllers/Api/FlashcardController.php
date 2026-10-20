<?php

namespace App\Http\Controllers\Api;

use App\Domain\Learning\Services\SpacedRepetitionService;
use App\Http\Controllers\Controller;
use App\Models\FlashcardDeck;
use App\Models\Flashcard;
use App\Models\UserFlashcardProgress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class FlashcardController extends Controller
{
    protected SpacedRepetitionService $sm2Service;

    public function __construct(SpacedRepetitionService $sm2Service)
    {
        $this->sm2Service = $sm2Service;
    }

        public function indexDecks(Request $request)
    {
        $query = FlashcardDeck::with(['cards']);

        if ($request->filled('subject_id')) {
            $query->where('subject_id', $request->input('subject_id'));
        }

        $decks = $query->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Flashcard decks retrieved successfully',
            'data'    => $decks,
        ], 200);
    }

        public function reviewCard(Request $request, $cardId)
    {
        $validator = Validator::make($request->all(), [
            'grade' => 'required|integer|min:0|max:5',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $userId = $request->user()->id;
        $card = Flashcard::find($cardId);

        if (!$card) {
            $deck = FlashcardDeck::firstOrCreate(
                ['title' => 'General BAC Review'],
                ['subject_id' => 1, 'description' => 'General Flashcards']
            );
            $card = Flashcard::create([
                'deck_id' => $deck->id,
                'question_text' => 'Flashcard Concept ' . $cardId,
                'answer_text' => 'Flashcard Solution ' . $cardId,
            ]);
        }

        $progress = UserFlashcardProgress::firstOrCreate(
            ['user_id' => $userId, 'flashcard_id' => $card->id],
            ['easiness_factor' => 2.5, 'interval_days' => 0, 'repetitions' => 0, 'next_review_at' => now()]
        );

        $updatedProgress = $this->sm2Service->calculateNextReview($progress, $request->input('grade'));

        return response()->json([
            'success' => true,
            'message' => 'Flashcard review recorded',
            'data'    => $updatedProgress,
        ], 200);
    }
}
