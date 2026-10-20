<?php

namespace App\Filament\Teacher\Resources\CourseResource\Pages;

use App\Filament\Teacher\Resources\CourseResource;
use Filament\Resources\Pages\CreateRecord;

class CreateCourse extends CreateRecord
{
    protected static string $resource = CourseResource::class;

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $user = auth()->user();

        if ($user && $user->teacherProfile) {
            $data['teacher_profile_id'] = $user->teacherProfile->id;
        }

        return $data;
    }
}
