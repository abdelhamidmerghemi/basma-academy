<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Lesson extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'course_id',
        'section_id',
        'media_id',
        'title',
        'sort_order',
        'is_preview',
        'summary_text',
    ];

    protected $casts = [
        'is_preview' => 'boolean',
    ];

    public function course()
    {
        return $this->belongsTo(Course::class);
    }

    public function section()
    {
        return $this->belongsTo(CourseSection::class);
    }

    public function media()
    {
        return $this->belongsTo(Media::class);
    }

    public function progress()
    {
        return $this->hasMany(LessonProgress::class);
    }
}
