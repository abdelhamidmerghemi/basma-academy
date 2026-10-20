<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Media extends Model
{
    protected $table = 'media';

    protected $fillable = [
        'provider',
        'type',
        'path',
        'thumbnail_path',
        'duration_seconds',
        'size_bytes',
    ];
}
