<?php

namespace App\Filament\Admin\Resources\FlashcardDeckResource\Pages;

use App\Filament\Admin\Resources\FlashcardDeckResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditFlashcardDeck extends EditRecord
{
    protected static string $resource = FlashcardDeckResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
