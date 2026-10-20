<?php

namespace App\Filament\Teacher\Resources;

use App\Filament\Teacher\Resources\QuizResource\Pages;
use App\Filament\Teacher\Resources\QuizResource\RelationManagers;
use App\Models\Quiz;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class QuizResource extends Resource
{
    protected static ?string $model = Quiz::class;

    protected static ?string $navigationIcon = 'heroicon-o-document-check';

    protected static ?int $navigationSort = 3;

    public static function getNavigationGroup(): ?string
    {
        return __('Quizzes & Flashcards');
    }

    public static function getModelLabel(): string
    {
        return __('Quiz');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Quizzes');
    }

    public static function getEloquentQuery(): Builder
    {
        $teacherProfileId = auth()->user()?->teacherProfile?->id ?? 0;

        return parent::getEloquentQuery()
            ->whereHas('lesson.course', function (Builder $query) use ($teacherProfileId) {
                $query->where('teacher_profile_id', $teacherProfileId);
            });
    }

    public static function form(Form $form): Form
    {
        $teacherProfileId = auth()->user()?->teacherProfile?->id ?? 0;

        return $form
            ->schema([
                Forms\Components\Section::make(__('Quiz Information'))
                    ->description(__('Setup quiz title, associated lesson, and timer limit'))
                    ->icon('heroicon-o-clipboard-document-check')
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Quiz Title'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\Select::make('lesson_id')
                            ->label(__('Associated Lesson'))
                            ->relationship('lesson', 'title', fn (Builder $query) => 
                                $query->whereHas('course', fn ($q) => $q->where('teacher_profile_id', $teacherProfileId))
                            )
                            ->searchable()
                            ->preload()
                            ->required(),

                        Forms\Components\Select::make('subject_id')
                            ->label(__('Subject'))
                            ->relationship('subject', 'name_ar')
                            ->searchable()
                            ->preload()
                            ->required(),

                        Forms\Components\TextInput::make('time_limit_minutes')
                            ->label(__('Time Limit (Minutes)'))
                            ->numeric()
                            ->default(15)
                            ->suffix(__('min'))
                            ->required(),
                    ])->columns(3),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('title')
                    ->label(__('Quiz Title'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->sortable()
                    ->badge()
                    ->color('primary'),

                Tables\Columns\TextColumn::make('lesson.title')
                    ->label(__('Lesson'))
                    ->sortable()
                    ->badge()
                    ->color('info'),

                Tables\Columns\TextColumn::make('time_limit_minutes')
                    ->label(__('Time Limit'))
                    ->suffix(' min')
                    ->sortable(),

                Tables\Columns\TextColumn::make('questions_count')
                    ->label(__('Questions'))
                    ->counts('questions')
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
            RelationManagers\QuestionsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListQuizzes::route('/'),
            'create' => Pages\CreateQuiz::route('/create'),
            'edit' => Pages\EditQuiz::route('/{record}/edit'),
        ];
    }
}
