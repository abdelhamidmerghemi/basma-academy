<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ForumReply extends Model
{
    use HasFactory;

    protected $table = 'forum_replies';

    protected $fillable = [
        'forum_post_id',
        'user_id',
        'content',
        'image_path',
        'is_best_answer',
    ];

    protected $casts = [
        'is_best_answer' => 'boolean',
    ];

    public function post()
    {
        return $this->belongsTo(ForumPost::class, 'forum_post_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function likes()
    {
        return $this->belongsToMany(User::class, 'forum_reply_likes', 'forum_reply_id')->withTimestamps();
    }

    public function getLikesCountAttribute(): int
    {
        return $this->likes()->count();
    }

    public function isLikedBy(?User $user): bool
    {
        if (!$user) return false;
        return $this->likes()->where('user_id', $user->id)->exists();
    }
}
