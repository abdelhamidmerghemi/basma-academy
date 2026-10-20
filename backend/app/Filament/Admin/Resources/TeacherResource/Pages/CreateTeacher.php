<?php

namespace App\Filament\Admin\Resources\TeacherResource\Pages;

use App\Filament\Admin\Resources\TeacherResource;
use App\Models\Role;
use Filament\Resources\Pages\CreateRecord;

class CreateTeacher extends CreateRecord
{
    protected static string $resource = TeacherResource::class;

    protected function afterCreate(): void
    {
        $teacherRoleId = Role::where('name', 'teacher')->value('id') ?? 2;
        $this->record->roles()->syncWithoutDetaching([$teacherRoleId]);
    }
}
