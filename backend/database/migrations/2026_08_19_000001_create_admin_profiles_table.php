<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
        public function up(): void
    {
        Schema::create('admin_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('title')->default('مدير المنصة'); // Job title / Department
            $table->string('department')->nullable(); // Management, Finance, Academic, Support
            $table->string('avatar_path', 500)->nullable();
            $table->boolean('is_super_admin')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index('user_id');
        });
    }

        public function down(): void
    {
        Schema::dropIfExists('admin_profiles');
    }
};
