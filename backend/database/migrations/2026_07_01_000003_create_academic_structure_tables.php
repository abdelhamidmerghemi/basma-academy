<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('academic_years', function (Blueprint $table) {
            $table->id();
            $table->string('name', 50);
            $table->boolean('is_active')->default(false);
            $table->date('starts_at');
            $table->date('ends_at');
            $table->timestamps();
        });

        Schema::create('streams', function (Blueprint $table) {
            $table->id();
            $table->string('code', 50)->unique();
            $table->string('name_ar');
            $table->string('name_fr');
            $table->string('name_en');
            $table->string('icon_name', 100);
            $table->string('color_hex', 20);
            $table->unsignedInteger('display_order')->default(1);
            $table->timestamps();
        });

        Schema::create('student_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('academic_year_id')->constrained('academic_years')->onDelete('restrict');
            $table->foreignId('stream_id')->constrained('streams')->onDelete('restrict');
            $table->string('school_name')->nullable();
            $table->unsignedInteger('wilaya_code')->nullable();
            $table->string('avatar_path', 500)->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index('user_id');
            $table->index('stream_id');
        });

        Schema::create('teacher_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('headline');
            $table->text('bio')->nullable();
            $table->string('avatar_path', 500)->nullable();
            $table->decimal('rating_cache', 3, 2)->default(5.00);
            $table->unsignedInteger('reviews_count')->default(0);
            $table->timestamps();
            $table->softDeletes();

            $table->index('user_id');
        });

        DB::table('academic_years')->insertOrIgnore([
            ['name' => '2026 - 2027', 'is_active' => true, 'starts_at' => '2026-09-01', 'ends_at' => '2027-06-30', 'created_at' => now(), 'updated_at' => now()],
        ]);

        DB::table('streams')->insertOrIgnore([
            ['code' => 'BAC_Sciences', 'name_ar' => 'علوم تجريبية', 'name_fr' => 'Sciences Expérimentales', 'name_en' => 'Experimental Sciences', 'icon_name' => 'science_rounded', 'color_hex' => '#10B981', 'display_order' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['code' => 'BAC_Maths', 'name_ar' => 'رياضيات', 'name_fr' => 'Mathématiques', 'name_en' => 'Mathematics', 'icon_name' => 'calculate_rounded', 'color_hex' => '#2563EB', 'display_order' => 2, 'created_at' => now(), 'updated_at' => now()],
            ['code' => 'BAC_Technique', 'name_ar' => 'تقني رياضي', 'name_fr' => 'Technique Mathématique', 'name_en' => 'Technical Mathematics', 'icon_name' => 'settings_suggest_rounded', 'color_hex' => '#F59E0B', 'display_order' => 3, 'created_at' => now(), 'updated_at' => now()],
            ['code' => 'BAC_Lettres', 'name_ar' => 'آداب وفلسفة', 'name_fr' => 'Lettres et Philosophie', 'name_en' => 'Literature & Philosophy', 'icon_name' => 'history_edu_rounded', 'color_hex' => '#EC4899', 'display_order' => 4, 'created_at' => now(), 'updated_at' => now()],
            ['code' => 'BAC_Languages', 'name_ar' => 'لغات أجنبية', 'name_fr' => 'Langues Étrangères', 'name_en' => 'Foreign Languages', 'icon_name' => 'translate_rounded', 'color_hex' => '#8B5CF6', 'display_order' => 5, 'created_at' => now(), 'updated_at' => now()],
            ['code' => 'BAC_Gestion', 'name_ar' => 'تسيير واقتصاد', 'name_fr' => 'Gestion et Économie', 'name_en' => 'Management & Economy', 'icon_name' => 'analytics_rounded', 'color_hex' => '#059669', 'display_order' => 6, 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('teacher_profiles');
        Schema::dropIfExists('student_profiles');
        Schema::dropIfExists('streams');
        Schema::dropIfExists('academic_years');
    }
};
