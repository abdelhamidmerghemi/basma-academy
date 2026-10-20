<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('announcements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->text('content');
            $table->string('image_path')->nullable();
            $table->timestamps();
        });

        Schema::create('announcement_comments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('announcement_id')->constrained('announcements')->onDelete('cascade');
            $table->text('content');
            $table->timestamps();
        });

        Schema::create('announcement_likes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('announcement_id')->constrained('announcements')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'announcement_id']);
        });

        Schema::create('announcement_saves', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('announcement_id')->constrained('announcements')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'announcement_id']);
        });

        Schema::create('announcement_views', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('announcement_id')->constrained('announcements')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'announcement_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('announcement_views');
        Schema::dropIfExists('announcement_saves');
        Schema::dropIfExists('announcement_likes');
        Schema::dropIfExists('announcement_comments');
        Schema::dropIfExists('announcements');
    }
};
