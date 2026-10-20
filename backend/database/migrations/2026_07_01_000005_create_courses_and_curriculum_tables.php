<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('courses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('academic_year_id')->constrained('academic_years')->onDelete('restrict');
            $table->foreignId('subject_id')->constrained('subjects')->onDelete('cascade');
            $table->foreignId('teacher_profile_id')->constrained('teacher_profiles')->onDelete('cascade');
            $table->string('title');
            $table->text('description')->nullable();
            $table->string('thumbnail_path', 500)->nullable();
            $table->boolean('is_published')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index('subject_id');
            $table->index('teacher_profile_id');
        });

        Schema::create('course_streams', function (Blueprint $table) {
            $table->foreignId('course_id')->constrained('courses')->onDelete('cascade');
            $table->foreignId('stream_id')->constrained('streams')->onDelete('cascade');
            $table->primary(['course_id', 'stream_id']);
        });

        Schema::create('course_sections', function (Blueprint $table) {
            $table->id();
            $table->foreignId('course_id')->constrained('courses')->onDelete('cascade');
            $table->string('title');
            $table->unsignedInteger('sort_order')->default(1);
            $table->timestamps();
        });

        Schema::create('media', function (Blueprint $table) {
            $table->id();
            $table->string('provider', 50)->default('local'); // 'vimeo', 's3', 'hls', 'local'
            $table->string('type', 50)->default('video'); // 'video', 'pdf', 'audio', 'zip'
            $table->string('path', 500);
            $table->string('thumbnail_path', 500)->nullable();
            $table->unsignedInteger('duration_seconds')->default(0);
            $table->unsignedBigInteger('size_bytes')->default(0);
            $table->timestamps();
        });

        Schema::create('lessons', function (Blueprint $table) {
            $table->id();
            $table->foreignId('course_id')->constrained('courses')->onDelete('cascade');
            $table->foreignId('section_id')->nullable()->constrained('course_sections')->onDelete('cascade');
            $table->foreignId('media_id')->nullable()->constrained('media')->onDelete('set null');
            $table->string('title');
            $table->unsignedInteger('sort_order')->default(1);
            $table->boolean('is_preview')->default(false);
            $table->text('summary_text')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lessons');
        Schema::dropIfExists('media');
        Schema::dropIfExists('course_sections');
        Schema::dropIfExists('course_streams');
        Schema::dropIfExists('courses');
    }
};
