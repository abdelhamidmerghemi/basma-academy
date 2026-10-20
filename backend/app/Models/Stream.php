<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Stream extends Model
{
    protected $fillable = [
        'code',
        'name_ar',
        'name_fr',
        'name_en',
        'icon_name',
        'color_hex',
        'display_order',
    ];

    protected $appends = ['name'];

    public function getNameAttribute(): string
    {
        $lang = app()->getLocale();
        return $this->{"name_{$lang}"} ?? $this->name_ar ?? $this->name_fr ?? $this->name_en ?? '';
    }

    public function subjects()
    {
        return $this->belongsToMany(Subject::class, 'stream_subjects')->withPivot('coefficient', 'display_order');
    }

    public function courses()
    {
        return $this->belongsToMany(Course::class, 'course_streams');
    }
}
