<?php

namespace App\Filament\Teacher\Resources\QuizResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;

class QuestionsRelationManager extends RelationManager
{
    protected static string $relationship = 'questions';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Textarea::make('question_text')
                    ->label(__('Question Text'))
                    ->required()
                    ->rows(3)
                    ->columnSpanFull(),

                Forms\Components\TextInput::make('points')
                    ->label(__('Points'))
                    ->numeric()
                    ->default(1)
                    ->required(),

                Forms\Components\TextInput::make('sort_order')
                    ->label(__('Sort Order'))
                    ->numeric()
                    ->default(1)
                    ->required(),

                Forms\Components\Repeater::make('answers')
                    ->label(__('Answer Choices (MCQ Options)'))
                    ->relationship('answers')
                    ->schema([
                        Forms\Components\TextInput::make('answer_text')
                            ->label(__('Option Text'))
                            ->required()
                            ->columnSpan(2),

                        Forms\Components\Toggle::make('is_correct')
                            ->label(__('Correct Answer'))
                            ->default(false),

                        Forms\Components\TextInput::make('explanation_text')
                            ->label(__('Explanation (Optional)'))
                            ->columnSpanFull(),
                    ])
                    ->columns(3)
                    ->columnSpanFull()
                    ->defaultItems(2)
                    ->collapsible(),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('question_text')
            ->columns([
                Tables\Columns\TextColumn::make('sort_order')
                    ->label(__('Order'))
                    ->sortable(),

                Tables\Columns\TextColumn::make('question_text')
                    ->label(__('Question Prompt'))
                    ->limit(60)
                    ->searchable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('points')
                    ->label(__('Points'))
                    ->badge()
                    ->color('primary'),
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
