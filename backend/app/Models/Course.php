<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Course extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'academic_year_id',
        'subject_id',
        'teacher_profile_id',
        'title',
        'description',
        'thumbnail_path',
        'is_published',
    ];

    protected $casts = [
        'is_published' => 'boolean',
    ];

    public function academicYear()
    {
        return $this->belongsTo(AcademicYear::class);
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function teacherProfile()
    {
        return $this->belongsTo(TeacherProfile::class);
    }

    public function streams()
    {
        return $this->belongsToMany(Stream::class, 'course_streams');
    }

    public function sections()
    {
        return $this->hasMany(CourseSection::class)->orderBy('sort_order');
    }

    public function lessons()
    {
        return $this->hasMany(Lesson::class);
    }

    public function product()
    {
        return $this->hasOne(Product::class);
    }

    public function reviews()
    {
        return $this->hasMany(CourseReview::class);
    }

    public function enrollments()
    {
        return $this->hasMany(CourseEnrollment::class);
    }
}
