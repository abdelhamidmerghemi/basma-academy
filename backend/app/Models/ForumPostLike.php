<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ForumPostLike extends Model
{
    protected $table = 'forum_post_likes';
    protected $fillable = ['forum_post_id', 'user_id'];
}
