<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Push Notifications catalog (broadcast/scheduled from admin)
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->string('title_ar');
            $table->string('title_fr')->nullable();
            $table->string('title_en')->nullable();
            $table->text('body_ar');
            $table->text('body_fr')->nullable();
            $table->text('body_en')->nullable();
            $table->string('type', 50)->default('general'); // general, course, announcement, promo
            $table->json('payload')->nullable();            // { "route": "/quiz/1", "course_id": 3 }
            $table->string('image_url')->nullable();        // optional rich notification image
            $table->boolean('is_broadcast')->default(true); // true = sent to all students
            $table->timestamp('sent_at')->nullable();
            $table->timestamps();
        });

        // Per-user notification read-receipts
        Schema::create('user_notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('notification_id')->constrained('notifications')->onDelete('cascade');
            $table->boolean('is_read')->default(false);
            $table->timestamp('read_at')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'notification_id']);
        });

        // FCM device tokens — one row per device, updated on login
        Schema::create('device_tokens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('fcm_token', 500);
            $table->string('platform', 20)->default('ios'); // ios | android
            $table->timestamp('last_seen_at')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'fcm_token']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('device_tokens');
        Schema::dropIfExists('user_notifications');
        Schema::dropIfExists('notifications');
    }
};
