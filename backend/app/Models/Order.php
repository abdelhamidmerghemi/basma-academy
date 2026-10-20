<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'order_number',
        'total_dzd',
        'status',
    ];

    protected $appends = [
        'receipt_image_url',
        'payment_method',
        'reference_number',
        'reject_reason',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function payment()
    {
        return $this->hasOne(Payment::class);
    }

    public function getCourseAttribute()
    {
        $item = $this->items()->with('product.course')->first();
        return $item?->product?->course;
    }

    public function getReceiptImageUrlAttribute()
    {
        $path = $this->payment?->receipt_image_path;
        if (!$path) {
            return asset('assets/images/placeholder_receipt.png');
        }
        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }
        return asset('storage/' . $path);
    }

    public function getPaymentMethodAttribute()
    {
        return $this->payment?->payment_method ?? 'BaridiMob';
    }

    public function getReferenceNumberAttribute()
    {
        return $this->payment?->transaction_reference;
    }

    public function getRejectReasonAttribute()
    {
        return null;
    }
}
