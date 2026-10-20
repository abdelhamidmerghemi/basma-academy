<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\FlashcardDeckResource\Pages;
use App\Models\FlashcardDeck;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class FlashcardDeckResource extends Resource
{
    protected static ?string $model = FlashcardDeck::class;

    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    public static function getNavigationGroup(): ?string
    {
        return __('Assessments & Question Banks');
    }

    public static function getNavigationLabel(): string
    {
        return __('Flashcard Decks');
    }

    public static function getModelLabel(): string
    {
        return __('Flashcard Deck');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Flashcard Decks');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->with(['subject', 'cards'])
            ->withCount('cards');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Deck Details'))
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Deck Title'))
                            ->required()
                            ->maxLength(255),

                        Forms\Components\Select::make('subject_id')
                            ->label(__('Subject'))
                            ->relationship('subject', 'name_ar')
                            ->required(),

                        Forms\Components\Textarea::make('description')
                            ->label(__('Description'))
                            ->rows(3)
                            ->columnSpanFull(),
                    ])->columns(2),

                Forms\Components\Section::make(__('Flashcards (Anki / Spaced Repetition)'))
                    ->schema([
                        Forms\Components\Repeater::make('cards')
                            ->relationship('cards')
                            ->label(__('Cards'))
                            ->schema([
                                Forms\Components\Textarea::make('question_text')
                                    ->label(__('Front (Question / Concept)'))
                                    ->required()
                                    ->rows(2),

                                Forms\Components\Textarea::make('answer_text')
                                    ->label(__('Back (Answer / Solution)'))
                                    ->required()
                                    ->rows(2),

                                Forms\Components\TextInput::make('explanation_text')
                                    ->label(__('Tip / Memory Hook / Explanation'))
                                    ->columnSpanFull(),
                            ])
                            ->columns(2)
                            ->collapsible()
                            ->columnSpanFull(),
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('title')
                    ->label(__('Deck Title'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->badge()
                    ->color('primary')
                    ->sortable(),

                Tables\Columns\TextColumn::make('cards_count')
                    ->label(__('Cards Count'))
                    ->counts('cards')
                    ->badge()
                    ->color('info')
                    ->sortable(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Created Date'))
                    ->dateTime('Y-m-d')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ]);
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
