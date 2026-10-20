<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\StreamResource\Pages;
use App\Models\Stream;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class StreamResource extends Resource
{
    protected static ?string $model = Stream::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';

    public static function getNavigationGroup(): ?string
    {
        return __('Academic & Curriculum');
    }

    public static function getNavigationLabel(): string
    {
        return __('Streams');
    }

    public static function getModelLabel(): string
    {
        return __('Stream');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Streams');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Stream Information'))
                    ->schema([
                        Forms\Components\TextInput::make('code')
                            ->label(__('Stream Code (Identifier)'))
                            ->required()
                            ->maxLength(50),

                        Forms\Components\TextInput::make('name_ar')
                            ->label(__('Arabic Name'))
                            ->required()
                            ->maxLength(255),

                        Forms\Components\TextInput::make('name_fr')
                            ->label(__('French Name'))
                            ->required()
                            ->maxLength(255),

                        Forms\Components\TextInput::make('name_en')
                            ->label(__('English Name'))
                            ->required()
                            ->maxLength(255),

                        Forms\Components\ColorPicker::make('color_hex')
                            ->label(__('Badge Color'))
                            ->required()
                            ->default('#2563EB'),

                        Forms\Components\TextInput::make('display_order')
                            ->label(__('Sort Order'))
                            ->numeric()
                            ->default(1),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('display_order', 'asc')
            ->columns([
                Tables\Columns\ColorColumn::make('color_hex')
                    ->label(__('Color')),

                Tables\Columns\TextColumn::make('code')
                    ->label(__('Code'))
                    ->badge()
                    ->color('gray')
                    ->sortable(),

                Tables\Columns\TextColumn::make('name_ar')
                    ->label(__('Arabic Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('name_fr')
                    ->label(__('French Name'))
                    ->searchable()
                    ->sortable(),

                Tables\Columns\TextColumn::make('display_order')
                    ->label(__('Order'))
                    ->numeric()
                    ->sortable(),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListStreams::route('/'),
            'create' => Pages\CreateStream::route('/create'),
            'edit' => Pages\EditStream::route('/{record}/edit'),
        ];
    }
}
