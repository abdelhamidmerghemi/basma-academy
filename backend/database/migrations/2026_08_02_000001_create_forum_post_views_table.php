<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('forum_post_views', function (Blueprint $table) {
            $table->id();
            $table->foreignId('forum_post_id')->constrained('forum_posts')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['forum_post_id', 'user_id']);
        });

        if (Schema::hasColumn('forum_posts', 'views_count')) {
            Schema::table('forum_posts', function (Blueprint $table) {
                $table->dropColumn('views_count');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('forum_post_views');

        if (!Schema::hasColumn('forum_posts', 'views_count')) {
            Schema::table('forum_posts', function (Blueprint $table) {
                $table->unsignedInteger('views_count')->default(0);
            });
        }
    }
};
