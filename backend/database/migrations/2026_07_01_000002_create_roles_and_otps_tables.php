<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('roles', function (Blueprint $table) {
            $table->id();
            $table->string('name', 100)->unique();
            $table->string('guard_name', 50)->default('web');
            $table->timestamps();
        });

        Schema::create('user_roles', function (Blueprint $table) {
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('role_id')->constrained('roles')->onDelete('cascade');
            $table->primary(['user_id', 'role_id']);
        });

        Schema::create('otps', function (Blueprint $table) {
            $table->id();
            $table->string('phone', 20);
            $table->string('code_hash');
            $table->string('purpose', 50)->default('login');
            $table->timestamp('expires_at');
            $table->boolean('is_used')->default(false);
            $table->timestamps();

            $table->index(['phone', 'purpose']);
        });

        DB::table('roles')->insertOrIgnore([
            ['name' => 'student', 'guard_name' => 'web', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'teacher', 'guard_name' => 'web', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'admin', 'guard_name' => 'web', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('otps');
        Schema::dropIfExists('user_roles');
        Schema::dropIfExists('roles');
    }
};
