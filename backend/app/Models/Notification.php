<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;

    protected $fillable = [
        'title_ar', 'title_fr', 'title_en',
        'body_ar', 'body_fr', 'body_en',
        'type', 'payload', 'image_url',
        'is_broadcast', 'sent_at',
    ];

    protected $casts = [
        'payload'      => 'array',
        'is_broadcast' => 'boolean',
        'sent_at'      => 'datetime',
    ];

    public function userNotifications()
    {
        return $this->hasMany(UserNotification::class);
    }

    /**
     * Localized title for the currently authenticated user's language.
     */
    public function getTitleAttribute(): string
    {
        $lang = app()->getLocale();
        return $this->{"title_{$lang}"} ?? $this->title_ar ?? '';
    }

    /**
     * Localized body.
     */
    public function getBodyAttribute(): string
    {
        $lang = app()->getLocale();
        return $this->{"body_{$lang}"} ?? $this->body_ar ?? '';
    }
}
