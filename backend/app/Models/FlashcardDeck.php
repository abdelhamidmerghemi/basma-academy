<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FlashcardDeck extends Model
{
    protected $fillable = ['subject_id', 'title', 'description'];

    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function cards()
    {
        return $this->hasMany(Flashcard::class, 'deck_id');
    }
}
