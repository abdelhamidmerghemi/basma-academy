<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
        'order_id',
        'payment_method',
        'transaction_reference',
        'receipt_image_path',
        'status',
        'verified_by_user_id',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function verifiedBy()
    {
        return $this->belongsTo(User::class, 'verified_by_user_id');
    }

    public function getReceiptUrlAttribute(): ?string
    {
        if (!$this->receipt_image_path) {
            return null;
        }

        if (str_starts_with($this->receipt_image_path, 'http://') || str_starts_with($this->receipt_image_path, 'https://')) {
            return $this->receipt_image_path;
        }

        return asset('storage/' . $this->receipt_image_path);
    }
}
