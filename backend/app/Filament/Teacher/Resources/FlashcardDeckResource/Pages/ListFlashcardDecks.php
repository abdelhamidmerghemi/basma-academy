<?php

namespace App\Filament\Teacher\Resources\FlashcardDeckResource\Pages;

use App\Filament\Teacher\Resources\FlashcardDeckResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListFlashcardDecks extends ListRecords
{
    protected static string $resource = FlashcardDeckResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
