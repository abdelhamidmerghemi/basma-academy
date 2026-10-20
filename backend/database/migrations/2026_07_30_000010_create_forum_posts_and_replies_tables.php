<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
        public function up(): void
    {
        Schema::create('forum_posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('subject_id')->nullable()->constrained('subjects')->onDelete('set null');
            $table->enum('type', ['question', 'discussion', 'resource'])->default('question');
            $table->string('title');
            $table->text('content');
            $table->string('image_path')->nullable();
            $table->boolean('is_solved')->default(false);
            $table->unsignedBigInteger('best_reply_id')->nullable();
            $table->unsignedInteger('views_count')->default(0);
            $table->unsignedInteger('likes_count')->default(0);
            $table->unsignedInteger('replies_count')->default(0);
            $table->timestamps();
        });

        Schema::create('forum_replies', function (Blueprint $table) {
            $table->id();
            $table->foreignId('forum_post_id')->constrained('forum_posts')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->text('content');
            $table->string('image_path')->nullable();
            $table->boolean('is_best_answer')->default(false);
            $table->unsignedInteger('likes_count')->default(0);
            $table->timestamps();
        });

        Schema::create('forum_post_likes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('forum_post_id')->constrained('forum_posts')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['forum_post_id', 'user_id']);
        });

        Schema::create('forum_reply_likes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('forum_reply_id')->constrained('forum_replies')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['forum_reply_id', 'user_id']);
        });
    }

        public function down(): void
    {
        Schema::dropIfExists('forum_reply_likes');
        Schema::dropIfExists('forum_post_likes');
        Schema::dropIfExists('forum_replies');
        Schema::dropIfExists('forum_posts');
    }
};
