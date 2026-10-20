<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subjects', function (Blueprint $table) {
            $table->id();
            $table->string('name_ar');
            $table->string('name_fr');
            $table->string('name_en');
            $table->string('icon_name', 100);
            $table->string('color_hex', 20);
            $table->timestamps();
        });

        Schema::create('stream_subjects', function (Blueprint $table) {
            $table->id();
            $table->foreignId('stream_id')->constrained('streams')->onDelete('cascade');
            $table->foreignId('subject_id')->constrained('subjects')->onDelete('cascade');
            $table->unsignedInteger('coefficient')->default(1);
            $table->unsignedInteger('display_order')->default(1);
            $table->timestamps();

            $table->unique(['stream_id', 'subject_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stream_subjects');
        Schema::dropIfExists('subjects');
    }
};
