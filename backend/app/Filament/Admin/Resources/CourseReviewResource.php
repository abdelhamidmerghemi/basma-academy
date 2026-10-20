<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\CourseReviewResource\Pages;
use App\Models\CourseReview;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class CourseReviewResource extends Resource
{
    protected static ?string $model = CourseReview::class;

    protected static ?string $navigationIcon = 'heroicon-o-star';

    public static function getNavigationGroup(): ?string
    {
        return __('Marketing & Community');
    }

    public static function getNavigationLabel(): string
    {
        return __('Course Reviews');
    }

    public static function getModelLabel(): string
    {
        return __('Review');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Reviews');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()->with(['user', 'course']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Review Information'))
                    ->schema([
                        Forms\Components\Select::make('course_id')
                            ->label(__('Course'))
                            ->relationship('course', 'title')
                            ->searchable()
                            ->required(),

                        Forms\Components\Select::make('user_id')
                            ->label(__('Student'))
                            ->relationship('user', 'name')
                            ->searchable()
                            ->required(),

                        Forms\Components\TextInput::make('rating')
                            ->label(__('Rating (1 - 5)'))
                            ->numeric()
                            ->minValue(1)
                            ->maxValue(5)
                            ->required(),

                        Forms\Components\Textarea::make('comment')
                            ->label(__('Review Comment'))
                            ->rows(3)
                            ->columnSpanFull(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('user.name')
                    ->label(__('Student'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('course.title')
                    ->label(__('Course'))
                    ->searchable()
                    ->sortable()
                    ->limit(35),

                Tables\Columns\TextColumn::make('rating')
                    ->label(__('Rating'))
                    ->badge()
                    ->color('warning')
                    ->formatStateUsing(fn ($state): string => '⭐ ' . $state . '/5')
                    ->sortable(),

                Tables\Columns\TextColumn::make('comment')
                    ->label(__('Comment'))
                    ->limit(50),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Date'))
                    ->dateTime('Y-m-d')
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
            'index' => Pages\ListCourseReviews::route('/'),
            'create' => Pages\CreateCourseReview::route('/create'),
            'edit' => Pages\EditCourseReview::route('/{record}/edit'),
        ];
    }
}
