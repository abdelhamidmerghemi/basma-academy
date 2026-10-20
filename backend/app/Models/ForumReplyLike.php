<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ForumReplyLike extends Model
{
    protected $table = 'forum_reply_likes';
    protected $fillable = ['forum_reply_id', 'user_id'];
}
