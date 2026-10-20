<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class OrderController extends Controller
{
        public function index(Request $request)
    {
        $orders = Order::with(['items.product.course', 'payment'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->get();

        $transformed = $orders->map(function ($order) {
            $course = $order->course;
            return [
                'id'                 => $order->id,
                'order_number'       => $order->order_number,
                'payment_method'     => $order->payment_method,
                'status'             => $order->status,
                'reference_number'   => $order->reference_number,
                'reject_reason'      => $order->reject_reason,
                'receipt_image_url'  => $order->receipt_image_url,
                'created_at'         => $order->created_at->toIso8601String(),
                'course'             => $course ? [
                    'id'              => $course->id,
                    'title'           => $course->title,
                    'price_dzd'       => $order->total_dzd,
                    'thumbnail_path'  => $course->thumbnail_path,
                ] : null,
            ];
        });

        return response()->json([
            'success' => true,
            'data'    => $transformed,
        ]);
    }

        public function store(Request $request)
    {
        $request->validate([
            'course_id'        => 'required|exists:courses,id',
            'payment_method'   => 'required|string',
            'reference_number' => 'nullable|string|max:100',
            'receipt_image'    => 'required|image|mimes:jpeg,png,jpg,webp|max:8192',
        ]);

        $user = $request->user();
        $courseId = $request->input('course_id');

        $existingPending = Order::where('user_id', $user->id)
            ->whereHas('items.product', function ($q) use ($courseId) {
                $q->where('course_id', $courseId);
            })
            ->where('status', 'pending')
            ->exists();

        if ($existingPending) {
            return response()->json([
                'success' => false,
                'message' => 'لديك طلب تفعيل قيد المراجعة سابقاً لهذا الكورس.',
            ], 422);
        }

        if ($request->hasFile('receipt_image')) {
            $file = $request->file('receipt_image');
            $path = $file->store('receipts', 'public');
        } else {
            return response()->json([
                'success' => false,
                'message' => 'صورة وصل التحويل مطلوبة لتأكيد الدفع.',
            ], 422);
        }

        $course = Course::with('product')->findOrFail($courseId);
        $product = $course->product ?? Product::firstOrCreate(
            ['course_id' => $course->id],
            ['price_dzd' => 2500.00]
        );

        $orderNumber = 'ORD-' . strtoupper(Str::random(8));

        $order = Order::create([
            'user_id'      => $user->id,
            'order_number' => $orderNumber,
            'total_dzd'    => $product->price_dzd,
            'status'       => 'pending',
        ]);

        OrderItem::create([
            'order_id'   => $order->id,
            'product_id' => $product->id,
            'price_dzd'  => $product->price_dzd,
        ]);

        Payment::create([
            'order_id'              => $order->id,
            'payment_method'        => $request->input('payment_method'),
            'transaction_reference' => $request->input('reference_number'),
            'receipt_image_path'    => $path,
            'status'                => 'submitted',
        ]);

        $responseData = [
            'id'                => $order->id,
            'order_number'      => $order->order_number,
            'payment_method'    => $order->payment_method,
            'status'            => $order->status,
            'reference_number'  => $order->reference_number,
            'receipt_image_url' => $order->receipt_image_url,
            'created_at'        => $order->created_at->toIso8601String(),
            'course'            => [
                'id'             => $course->id,
                'title'          => $course->title,
                'price_dzd'      => $product->price_dzd,
                'thumbnail_path' => $course->thumbnail_path,
            ],
        ];

        return response()->json([
            'success' => true,
            'message' => 'تم رفع وصل الدفع بنجاح. سيتم مراجعة الطلب وتفعيل الكورس في أقرب وقت.',
            'data'    => $responseData,
        ], 201);
    }
}
