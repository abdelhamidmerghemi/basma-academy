<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class TeacherProfile extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'headline',
        'bio',
        'avatar_path',
        'rating_cache',
        'reviews_count',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function courses()
    {
        return $this->hasMany(Course::class);
    }

    public function announcements()
    {
        return $this->hasMany(Announcement::class, 'user_id', 'user_id');
    }
}
