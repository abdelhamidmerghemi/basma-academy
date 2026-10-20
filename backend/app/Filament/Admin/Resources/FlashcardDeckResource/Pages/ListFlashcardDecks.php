<?php

namespace App\Filament\Admin\Resources\FlashcardDeckResource\Pages;

use App\Filament\Admin\Resources\FlashcardDeckResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListFlashcardDecks extends ListRecords
{
    protected static string $resource = FlashcardDeckResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label(__('Add Deck')),
        ];
    }
}
