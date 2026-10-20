<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ForumPost extends Model
{
    use HasFactory;

    protected $table = 'forum_posts';

    protected $fillable = [
        'user_id',
        'subject_id',
        'type',
        'title',
        'content',
        'image_path',
        'is_solved',
        'best_reply_id',
    ];

    protected $casts = [
        'is_solved' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function replies()
    {
        return $this->hasMany(ForumReply::class, 'forum_post_id')->orderBy('is_best_answer', 'desc')->latest();
    }

    public function likes()
    {
        return $this->belongsToMany(User::class, 'forum_post_likes')->withTimestamps();
    }

    public function views()
    {
        return $this->belongsToMany(User::class, 'forum_post_views')->withTimestamps();
    }

    public function bestReply()
    {
        return $this->belongsTo(ForumReply::class, 'best_reply_id');
    }

    public function getLikesCountAttribute(): int
    {
        return $this->likes()->count();
    }

    public function getRepliesCountAttribute(): int
    {
        return $this->replies()->count();
    }

    public function getViewsCountAttribute(): int
    {
        return $this->views()->count();
    }

    public function isLikedBy(?User $user): bool
    {
        if (!$user) return false;
        return $this->likes()->where('user_id', $user->id)->exists();
    }

    public function isViewedBy(?User $user): bool
    {
        if (!$user) return false;
        return $this->views()->where('user_id', $user->id)->exists();
    }
}
