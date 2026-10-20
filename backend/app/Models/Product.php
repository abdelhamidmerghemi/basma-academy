<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = ['course_id', 'price_dzd', 'sale_price_dzd', 'is_active'];

    protected $casts = ['is_active' => 'boolean'];

    public function course()
    {
        return $this->belongsTo(Course::class);
    }
}
