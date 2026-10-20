<?php

namespace App\Domain\Learning\Services;

use App\Models\UserFlashcardProgress;
use Carbon\Carbon;

class SpacedRepetitionService 
{
    /**
     * Rating scale: 0 (Blackout) to 5 (Perfect Recall)
     */
    public function calculateNextReview(UserFlashcardProgress $progress, int $grade): UserFlashcardProgress 
    {
        $grade = max(0, min(5, $grade));
        
        $newEf = $progress->easiness_factor + (0.1 - (5 - $grade) * (0.08 + (5 - $grade) * 0.02));
        $newEf = max(1.3, $newEf); // Minimum floor of 1.3

        if ($grade < 3) {
            $repetitions = 0;
            $intervalDays = 1;
        } else {
            $repetitions = $progress->repetitions + 1;
            if ($repetitions == 1) {
                $intervalDays = 1;
            } elseif ($repetitions == 2) {
                $intervalDays = 6;
            } else {
                $intervalDays = (int) round($progress->interval_days * $newEf);
            }
        }

        $progress->update([
            'easiness_factor' => $newEf,
            'repetitions' => $repetitions,
            'interval_days' => $intervalDays,
            'next_review_at' => Carbon::now()->addDays($intervalDays),
            'last_reviewed_at' => Carbon::now(),
        ]);

        return $progress;
    }
}
