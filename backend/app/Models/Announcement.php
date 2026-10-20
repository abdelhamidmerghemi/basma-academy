<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Announcement extends Model
{
    protected $fillable = [
        'user_id',
        'content',
        'image_path',
    ];

    protected $appends = ['is_liked', 'is_viewed', 'likes_count', 'comments_count', 'views_count'];

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function comments(): HasMany
    {
        return $this->hasMany(AnnouncementComment::class, 'announcement_id');
    }

    public function likes(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'announcement_likes');
    }

    public function views(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'announcement_views');
    }

    // Appended Attributes
    public function getIsLikedAttribute(): bool
    {
        $userId = auth('sanctum')->id();
        return $userId ? $this->likes()->where('user_id', $userId)->exists() : false;
    }

    public function getIsViewedAttribute(): bool
    {
        $userId = auth('sanctum')->id();
        return $userId ? $this->views()->where('user_id', $userId)->exists() : false;
    }

    public function getLikesCountAttribute(): int
    {
        return $this->likes()->count();
    }

    public function getCommentsCountAttribute(): int
    {
        return $this->comments()->count();
    }

    public function getViewsCountAttribute(): int
    {
        return $this->views()->count();
    }
}
