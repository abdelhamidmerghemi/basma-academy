<?php

namespace App\Filament\Admin\Resources\StreamResource\Pages;

use App\Filament\Admin\Resources\StreamResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListStreams extends ListRecords
{
    protected static string $resource = StreamResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label(__('Add Stream')),
        ];
    }
}
