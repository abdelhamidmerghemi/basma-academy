<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    protected $fillable = [
        'name_ar',
        'name_fr',
        'name_en',
        'icon_name',
        'color_hex',
    ];

    protected $appends = ['name'];

    /**
     * Dynamically return localized subject name.
     */
    public function getNameAttribute(): string
    {
        $lang = app()->getLocale();
        return $this->{"name_{$lang}"} ?? $this->name_ar ?? $this->name_fr ?? $this->name_en ?? '';
    }

    public function streams()
    {
        return $this->belongsToMany(Stream::class, 'stream_subjects')->withPivot('coefficient', 'display_order');
    }

    public function courses()
    {
        return $this->hasMany(Course::class);
    }
}
