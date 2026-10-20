<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\BannerResource\Pages;
use App\Models\Banner;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class BannerResource extends Resource
{
    protected static ?string $model = Banner::class;

    protected static ?string $navigationIcon = 'heroicon-o-photo';

    public static function getNavigationGroup(): ?string
    {
        return __('Marketing & Community');
    }

    public static function getNavigationLabel(): string
    {
        return __('Promotional Banners');
    }

    public static function getModelLabel(): string
    {
        return __('Banner');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Banners');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Banner Information'))
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Banner Title'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\TextInput::make('target_route')
                            ->label(__('Target In-App Route'))
                            ->placeholder('/courses or /flashcards or /forum')
                            ->maxLength(255),

                        Forms\Components\TextInput::make('display_order')
                            ->label(__('Display Order'))
                            ->numeric()
                            ->default(1),

                        Forms\Components\Toggle::make('is_active')
                            ->label(__('Active on Home Screen'))
                            ->default(true),

                        Forms\Components\FileUpload::make('image_path')
                            ->label(__('Banner Image (Recommended 1200x500)'))
                            ->image()
                            ->directory('banners')
                            ->required()
                            ->columnSpanFull(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('display_order', 'asc')
            ->columns([
                Tables\Columns\ImageColumn::make('image_url')
                    ->label(__('Image'))
                    ->square(false)
                    ->width(120)
                    ->height(54)
                    ->checkFileExistence(false)
                    ->extraImgAttributes(['class' => 'rounded-lg border shadow-sm object-cover']),

                Tables\Columns\TextColumn::make('title')
                    ->label(__('Banner Title'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('target_route')
                    ->label(__('Target Route'))
                    ->badge()
                    ->color('info')
                    ->placeholder('—'),

                Tables\Columns\TextColumn::make('display_order')
                    ->label(__('Order'))
                    ->numeric()
                    ->sortable(),

                Tables\Columns\IconColumn::make('is_active')
                    ->label(__('Active'))
                    ->boolean()
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
            'index' => Pages\ListBanners::route('/'),
            'create' => Pages\CreateBanner::route('/create'),
            'edit' => Pages\EditBanner::route('/{record}/edit'),
        ];
    }
}
