<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CourseEnrollment extends Model
{
    protected $table = 'course_enrollments';

    protected $fillable = ['user_id', 'course_id', 'order_id', 'status', 'access_until'];

    protected $casts = ['access_until' => 'datetime'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function course()
    {
        return $this->belongsTo(Course::class);
    }
}
