<?php

namespace App\Filament\Teacher\Resources\FlashcardDeckResource\Pages;

use App\Filament\Teacher\Resources\FlashcardDeckResource;
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
