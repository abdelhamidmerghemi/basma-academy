<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Flashcard extends Model
{
    protected $fillable = ['deck_id', 'question_text', 'answer_text', 'explanation_text'];

    public function deck()
    {
        return $this->belongsTo(FlashcardDeck::class, 'deck_id');
    }

    public function userProgress()
    {
        return $this->hasMany(UserFlashcardProgress::class, 'flashcard_id');
    }
}
