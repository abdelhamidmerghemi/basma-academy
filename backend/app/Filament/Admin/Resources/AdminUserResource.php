<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\AdminUserResource\Pages;
use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Hash;

class AdminUserResource extends Resource
{
    protected static ?string $model = User::class;

    protected static ?string $navigationIcon = 'heroicon-o-shield-check';

    public static function getNavigationGroup(): ?string
    {
        return __('User Management');
    }

    public static function getNavigationLabel(): string
    {
        return __('Administrators');
    }

    public static function getModelLabel(): string
    {
        return __('Administrator');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Administrators');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->whereHas('adminProfile')
            ->with(['adminProfile']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Administrator Account'))
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label(__('Admin Name'))
                            ->required()
                            ->maxLength(255),

                        Forms\Components\TextInput::make('email')
                            ->label(__('Email Address'))
                            ->email()
                            ->required()
                            ->unique(ignoreRecord: true),

                        Forms\Components\TextInput::make('phone')
                            ->label(__('Phone Number'))
                            ->tel()
                            ->required()
                            ->unique(ignoreRecord: true),

                        Forms\Components\TextInput::make('password')
                            ->label(__('Password'))
                            ->password()
                            ->dehydrateStateUsing(fn ($state) => Hash::make($state))
                            ->dehydrated(fn ($state) => filled($state))
                            ->required(fn (string $operation): bool => $operation === 'create'),
                    ])->columns(2),

                Forms\Components\Section::make(__('Administrative Role & Permissions'))
                    ->relationship('adminProfile')
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Job Title'))
                            ->required()
                            ->default('مدير المنصة')
                            ->maxLength(255),

                        Forms\Components\TextInput::make('department')
                            ->label(__('Department / Responsibilities'))
                            ->maxLength(255),

                        Forms\Components\Toggle::make('is_super_admin')
                            ->label(__('Super Administrator'))
                            ->default(true),

                        Forms\Components\FileUpload::make('avatar_path')
                            ->label(__('Avatar'))
                            ->image()
                            ->directory('avatars/admins'),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\ImageColumn::make('avatar_path')
                    ->label(__('Avatar'))
                    ->circular()
                    ->defaultImageUrl(fn (User $record): ?string => $record->getFilamentAvatarUrl()),

                Tables\Columns\TextColumn::make('name')
                    ->label(__('Admin Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('email')
                    ->label(__('Email'))
                    ->searchable()
                    ->copyable(),

                Tables\Columns\TextColumn::make('phone')
                    ->label(__('Phone'))
                    ->searchable()
                    ->copyable(),

                Tables\Columns\TextColumn::make('adminProfile.title')
                    ->label(__('Title'))
                    ->badge()
                    ->color('primary'),

                Tables\Columns\TextColumn::make('adminProfile.department')
                    ->label(__('Department'))
                    ->placeholder('—'),

                Tables\Columns\IconColumn::make('adminProfile.is_super_admin')
                    ->label(__('Super Admin'))
                    ->boolean(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Created Date'))
                    ->dateTime('Y-m-d')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListAdminUsers::route('/'),
            'create' => Pages\CreateAdminUser::route('/create'),
            'edit' => Pages\EditAdminUser::route('/{record}/edit'),
        ];
    }
}
