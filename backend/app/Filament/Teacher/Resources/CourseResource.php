<?php

namespace App\Filament\Teacher\Resources;

use App\Filament\Teacher\Resources\CourseResource\Pages;
use App\Filament\Teacher\Resources\CourseResource\RelationManagers;
use App\Models\Course;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class CourseResource extends Resource
{
    protected static ?string $model = Course::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';

    protected static ?int $navigationSort = 1;

    public static function getNavigationGroup(): ?string
    {
        return __('Educational Content');
    }

    public static function getModelLabel(): string
    {
        return __('Course');
    }

    public static function getPluralModelLabel(): string
    {
        return __('My Courses');
    }

    public static function getEloquentQuery(): Builder
    {
        $user = auth()->user();
        $teacherProfileId = $user?->teacherProfile?->id ?? 0;

        return parent::getEloquentQuery()
            ->where('teacher_profile_id', $teacherProfileId);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Course Information'))
                    ->description(__('Enter the details of your educational course'))
                    ->icon('heroicon-o-book-open')
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Course Title'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\Select::make('subject_id')
                            ->label(__('Subject'))
                            ->relationship('subject', 'name_ar')
                            ->searchable()
                            ->preload()
                            ->required(),

                        Forms\Components\Select::make('academic_year_id')
                            ->label(__('Academic Year'))
                            ->relationship('academicYear', 'name')
                            ->searchable()
                            ->preload()
                            ->required(),

                        Forms\Components\Select::make('streams')
                            ->label(__('Target Academic Streams'))
                            ->relationship('streams', 'name_ar')
                            ->multiple()
                            ->preload()
                            ->required()
                            ->columnSpanFull(),

                        Forms\Components\FileUpload::make('thumbnail_path')
                            ->label(__('Course Cover Image'))
                            ->image()
                            ->directory('courses/thumbnails')
                            ->columnSpanFull(),

                        Forms\Components\RichEditor::make('description')
                            ->label(__('Course Description'))
                            ->columnSpanFull(),

                        Forms\Components\Toggle::make('is_published')
                            ->label(__('Publish Course'))
                            ->default(true),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\ImageColumn::make('thumbnail_path')
                    ->label(__('Cover'))
                    ->circular(),

                Tables\Columns\TextColumn::make('title')
                    ->label(__('Course Title'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->sortable()
                    ->badge()
                    ->color('primary'),

                Tables\Columns\TextColumn::make('lessons_count')
                    ->label(__('Lessons'))
                    ->counts('lessons')
                    ->sortable()
                    ->badge()
                    ->color('info'),

                Tables\Columns\TextColumn::make('enrollments_count')
                    ->label(__('Enrolled Students'))
                    ->counts('enrollments')
                    ->sortable()
                    ->badge()
                    ->color('success'),

                Tables\Columns\IconColumn::make('is_published')
                    ->label(__('Published'))
                    ->boolean(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Created Date'))
                    ->dateTime('d/m/Y')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\TernaryFilter::make('is_published')
                    ->label(__('Publication Status')),
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
            RelationManagers\LessonsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListCourses::route('/'),
            'create' => Pages\CreateCourse::route('/create'),
            'edit' => Pages\EditCourse::route('/{record}/edit'),
        ];
    }
}
