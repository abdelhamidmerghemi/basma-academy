<?php

namespace App\Filament\Teacher\Resources;

use App\Filament\Teacher\Resources\FlashcardDeckResource\Pages;
use App\Filament\Teacher\Resources\FlashcardDeckResource\RelationManagers;
use App\Models\FlashcardDeck;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class FlashcardDeckResource extends Resource
{
    protected static ?string $model = FlashcardDeck::class;

    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    protected static ?int $navigationSort = 4;

    public static function getNavigationGroup(): ?string
    {
        return __('Quizzes & Flashcards');
    }

    public static function getModelLabel(): string
    {
        return __('Flashcard Deck');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Flashcard Decks');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Flashcard Deck Information'))
                    ->description(__('Create memory decks to help students review key concepts quickly'))
                    ->icon('heroicon-o-rectangle-stack')
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Deck Title'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\Select::make('subject_id')
                            ->label(__('Subject'))
                            ->relationship('subject', 'name_ar')
                            ->searchable()
                            ->preload()
                            ->required(),

                        Forms\Components\Textarea::make('description')
                            ->label(__('Deck Description'))
                            ->rows(3)
                            ->columnSpanFull(),
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('title')
                    ->label(__('Deck Title'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->sortable()
                    ->badge()
                    ->color('primary'),

                Tables\Columns\TextColumn::make('cards_count')
                    ->label(__('Cards Count'))
                    ->counts('cards')
                    ->badge()
                    ->color('success'),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Created Date'))
                    ->dateTime('d/m/Y')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('subject_id')
                    ->label(__('Subject'))
                    ->relationship('subject', 'name_ar'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            RelationManagers\CardsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListFlashcardDecks::route('/'),
            'create' => Pages\CreateFlashcardDeck::route('/create'),
            'edit' => Pages\EditFlashcardDeck::route('/{record}/edit'),
        ];
    }
}
