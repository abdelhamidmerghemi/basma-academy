<?php

namespace App\Filament\Teacher\Resources\CourseResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;

class LessonsRelationManager extends RelationManager
{
    protected static string $relationship = 'lessons';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('title')
                    ->label(__('Lesson Title'))
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),

                Forms\Components\TextInput::make('sort_order')
                    ->label(__('Sort Order'))
                    ->numeric()
                    ->default(1)
                    ->required(),

                Forms\Components\Toggle::make('is_preview')
                    ->label(__('Free Preview Lesson'))
                    ->default(false),

                Forms\Components\Textarea::make('summary_text')
                    ->label(__('Lesson Summary / Notes'))
                    ->rows(3)
                    ->columnSpanFull(),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('title')
            ->columns([
                Tables\Columns\TextColumn::make('sort_order')
                    ->label(__('Order'))
                    ->sortable(),

                Tables\Columns\TextColumn::make('title')
                    ->label(__('Lesson Title'))
                    ->searchable()
                    ->weight('bold'),

                Tables\Columns\IconColumn::make('is_preview')
                    ->label(__('Free Preview'))
                    ->boolean(),
            ])
            ->filters([
            ])
            ->headerActions([
                Tables\Actions\CreateAction::make(),
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
}
