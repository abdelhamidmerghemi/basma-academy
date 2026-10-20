<?php

namespace App\Filament\Admin\Resources\StreamResource\Pages;

use App\Filament\Admin\Resources\StreamResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditStream extends EditRecord
{
    protected static string $resource = StreamResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
