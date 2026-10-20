<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\SubjectResource\Pages;
use App\Models\Subject;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class SubjectResource extends Resource
{
    protected static ?string $model = Subject::class;

    protected static ?string $navigationIcon = 'heroicon-o-square-3-stack-3d';

    public static function getNavigationGroup(): ?string
    {
        return __('Academic & Curriculum');
    }

    public static function getNavigationLabel(): string
    {
        return __('Subjects');
    }

    public static function getModelLabel(): string
    {
        return __('Subject');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Subjects');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()->withCount('courses');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Subject Information'))
                    ->schema([
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

                        Forms\Components\TextInput::make('icon_name')
                            ->label(__('Icon Identifier'))
                            ->default('menu_book_rounded')
                            ->required(),

                        Forms\Components\ColorPicker::make('color_hex')
                            ->label(__('Brand Color'))
                            ->default('#2563EB')
                            ->required(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('id', 'asc')
            ->columns([
                Tables\Columns\ColorColumn::make('color_hex')
                    ->label(__('Color')),

                Tables\Columns\TextColumn::make('name_ar')
                    ->label(__('Arabic Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('name_fr')
                    ->label(__('French Name'))
                    ->searchable()
                    ->sortable(),

                Tables\Columns\TextColumn::make('name_en')
                    ->label(__('English Name'))
                    ->searchable()
                    ->toggleable(isToggledHiddenByDefault: true),

                Tables\Columns\TextColumn::make('courses_count')
                    ->label(__('Courses Count'))
                    ->counts('courses')
                    ->badge()
                    ->color('primary')
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
            'index' => Pages\ListSubjects::route('/'),
            'create' => Pages\CreateSubject::route('/create'),
            'edit' => Pages\EditSubject::route('/{record}/edit'),
        ];
    }
}
