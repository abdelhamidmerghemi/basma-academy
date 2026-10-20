<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\OrderResource\Pages;
use App\Models\Order;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class OrderResource extends Resource
{
    protected static ?string $model = Order::class;

    protected static ?string $navigationIcon = 'heroicon-o-shopping-bag';

    public static function getNavigationGroup(): ?string
    {
        return __('Finance & Payments');
    }

    public static function getNavigationLabel(): string
    {
        return __('Orders & Invoices');
    }

    public static function getModelLabel(): string
    {
        return __('Order');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Orders');
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Order Information'))
                    ->schema([
                        Forms\Components\TextInput::make('order_number')
                            ->label(__('Order #'))
                            ->disabled(),

                        Forms\Components\Select::make('user_id')
                            ->label(__('Student'))
                            ->relationship('user', 'name')
                            ->disabled(),

                        Forms\Components\TextInput::make('total_dzd')
                            ->label(__('Total Amount'))
                            ->numeric()
                            ->prefix('DZD')
                            ->disabled(),

                        Forms\Components\Select::make('status')
                            ->label(__('Status'))
                            ->options([
                                'pending' => __('Pending'),
                                'completed' => __('Completed'),
                                'cancelled' => __('Cancelled'),
                            ])
                            ->required(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('order_number')
                    ->label(__('Order #'))
                    ->searchable()
                    ->sortable()
                    ->copyable()
                    ->weight('bold')
                    ->color('primary'),

                Tables\Columns\TextColumn::make('user.name')
                    ->label(__('Student'))
                    ->searchable()
                    ->sortable()
                    ->description(fn (Order $record): string => $record->user?->phone ?? $record->user?->email ?? ''),

                Tables\Columns\TextColumn::make('course.title')
                    ->label(__('Course'))
                    ->limit(35)
                    ->tooltip(fn (Order $record): ?string => $record->course?->title),

                Tables\Columns\TextColumn::make('total_dzd')
                    ->label(__('Total Amount'))
                    ->money('DZD')
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('payment_method')
                    ->label(__('Method'))
                    ->badge()
                    ->color(fn (string $state): string => match (strtolower($state)) {
                        'baridimob' => 'success',
                        'ccp' => 'warning',
                        'card' => 'info',
                        default => 'gray',
                    }),

                Tables\Columns\TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'completed' => 'success',
                        'pending' => 'warning',
                        'cancelled' => 'danger',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'completed' => __('Completed'),
                        'pending' => __('Pending'),
                        'cancelled' => __('Cancelled'),
                        default => ucfirst($state),
                    }),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Date'))
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->label(__('Status'))
                    ->options([
                        'completed' => __('Completed'),
                        'pending' => __('Pending'),
                        'cancelled' => __('Cancelled'),
                    ]),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListOrders::route('/'),
        ];
    }
}
