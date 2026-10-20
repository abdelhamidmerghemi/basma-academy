<?php

namespace App\Filament\Admin\Resources\AdminUserResource\Pages;

use App\Filament\Admin\Resources\AdminUserResource;
use App\Models\Role;
use Filament\Resources\Pages\CreateRecord;

class CreateAdminUser extends CreateRecord
{
    protected static string $resource = AdminUserResource::class;

    protected function afterCreate(): void
    {
        $adminRoleId = Role::where('name', 'admin')->value('id') ?? 3;
        $this->record->roles()->syncWithoutDetaching([$adminRoleId]);
    }
}
