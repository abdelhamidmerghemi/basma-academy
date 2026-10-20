<?php

namespace App\Filament\Teacher\Resources;

use App\Filament\Teacher\Resources\AnnouncementResource\Pages;
use App\Filament\Teacher\Resources\AnnouncementResource\RelationManagers;
use App\Models\Announcement;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class AnnouncementResource extends Resource
{
    protected static ?string $model = Announcement::class;

    protected static ?string $navigationIcon = 'heroicon-o-megaphone';

    protected static ?int $navigationSort = 2;

    public static function getNavigationGroup(): ?string
    {
        return __('Interactions & Announcements');
    }

    public static function getModelLabel(): string
    {
        return __('Announcement');
    }

    public static function getPluralModelLabel(): string
    {
        return __('My Announcements');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->where('user_id', auth()->id());
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Announcement Content'))
                    ->description(__('Post updates, exam tips, and announcements to your enrolled students'))
                    ->icon('heroicon-o-chat-bubble-bottom-center-text')
                    ->schema([
                        Forms\Components\RichEditor::make('content')
                            ->label(__('Announcement Text'))
                            ->required()
                            ->columnSpanFull(),

                        Forms\Components\FileUpload::make('image_path')
                            ->label(__('Attachment Image (Optional)'))
                            ->image()
                            ->directory('announcements/images')
                            ->columnSpanFull(),
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\ImageColumn::make('image_path')
                    ->label(__('Image'))
                    ->circular(),

                Tables\Columns\TextColumn::make('content')
                    ->label(__('Content Preview'))
                    ->html()
                    ->limit(60)
                    ->searchable(),

                Tables\Columns\TextColumn::make('comments_count')
                    ->label(__('Comments'))
                    ->counts('comments')
                    ->badge()
                    ->color('info'),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Published At'))
                    ->dateTime('d/m/Y H:i')
                    ->sortable(),
            ])
            ->filters([
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
            RelationManagers\CommentsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListAnnouncements::route('/'),
            'create' => Pages\CreateAnnouncement::route('/create'),
            'edit' => Pages\EditAnnouncement::route('/{record}/edit'),
        ];
    }
}
