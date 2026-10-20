<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Add subject_id directly to quizzes for fast subject-based filtering.
     * This denormalises slightly but avoids a 3-hop join (quiz→lesson→course→subject).
     */
    public function up(): void
    {
        Schema::table('quizzes', function (Blueprint $table) {
            $table->foreignId('subject_id')
                  ->nullable()
                  ->after('lesson_id')
                  ->constrained('subjects')
                  ->onDelete('set null');

            $table->index('subject_id');
        });
    }

    public function down(): void
    {
        Schema::table('quizzes', function (Blueprint $table) {
            $table->dropForeign(['subject_id']);
            $table->dropIndex(['subject_id']);
            $table->dropColumn('subject_id');
        });
    }
};
