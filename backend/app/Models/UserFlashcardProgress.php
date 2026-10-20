<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserFlashcardProgress extends Model
{
    protected $table = 'user_flashcard_progress';

    protected $fillable = [
        'user_id',
        'flashcard_id',
        'easiness_factor',
        'interval_days',
        'repetitions',
        'next_review_at',
        'last_reviewed_at',
    ];

    protected $casts = [
        'easiness_factor'  => 'double',
        'interval_days'    => 'integer',
        'repetitions'      => 'integer',
        'next_review_at'   => 'datetime',
        'last_reviewed_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function flashcard()
    {
        return $this->belongsTo(Flashcard::class, 'flashcard_id');
    }
}
