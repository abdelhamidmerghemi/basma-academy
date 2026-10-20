<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Remove denormalized counter columns — counts are now computed dynamically
        // from the forum_post_likes and forum_reply_likes relation tables.
        Schema::table('forum_posts', function (Blueprint $table) {
            $table->dropColumn(['likes_count', 'replies_count']);
        });

        Schema::table('forum_replies', function (Blueprint $table) {
            $table->dropColumn('likes_count');
        });
    }

    public function down(): void
    {
        Schema::table('forum_posts', function (Blueprint $table) {
            $table->unsignedInteger('likes_count')->default(0);
            $table->unsignedInteger('replies_count')->default(0);
        });

        Schema::table('forum_replies', function (Blueprint $table) {
            $table->unsignedInteger('likes_count')->default(0);
        });
    }
};
