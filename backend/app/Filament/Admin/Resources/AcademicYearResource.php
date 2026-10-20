<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\AcademicYearResource\Pages;
use App\Models\AcademicYear;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class AcademicYearResource extends Resource
{
    protected static ?string $model = AcademicYear::class;

    protected static ?string $navigationIcon = 'heroicon-o-calendar';

    public static function getNavigationGroup(): ?string
    {
        return __('Academic & Curriculum');
    }

    public static function getNavigationLabel(): string
    {
        return __('Academic Years');
    }

    public static function getModelLabel(): string
    {
        return __('Academic Year');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Academic Years');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Academic Year Details'))
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label(__('Year Name'))
                            ->placeholder('2026 - 2027')
                            ->required()
                            ->maxLength(50),

                        Forms\Components\Toggle::make('is_active')
                            ->label(__('Is Current Active Year'))
                            ->default(true),

                        Forms\Components\DatePicker::make('starts_at')
                            ->label(__('Start Date'))
                            ->required(),

                        Forms\Components\DatePicker::make('ends_at')
                            ->label(__('End Date'))
                            ->required(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('starts_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label(__('Year'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\IconColumn::make('is_active')
                    ->label(__('Active'))
                    ->boolean()
                    ->sortable(),

                Tables\Columns\TextColumn::make('starts_at')
                    ->label(__('Starts At'))
                    ->date('Y-m-d')
                    ->sortable(),

                Tables\Columns\TextColumn::make('ends_at')
                    ->label(__('Ends At'))
                    ->date('Y-m-d')
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
            'index' => Pages\ListAcademicYears::route('/'),
            'create' => Pages\CreateAcademicYear::route('/create'),
            'edit' => Pages\EditAcademicYear::route('/{record}/edit'),
        ];
    }
}
