<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\PaymentResource\Pages;
use App\Models\CourseEnrollment;
use App\Models\Payment;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\HtmlString;

class PaymentResource extends Resource
{
    protected static ?string $model = Payment::class;

    protected static ?string $navigationIcon = 'heroicon-o-credit-card';

    public static function getNavigationGroup(): ?string
    {
        return __('Finance & Payments');
    }

    public static function getNavigationLabel(): string
    {
        return __('Payment Verification');
    }

    public static function getModelLabel(): string
    {
        return __('Payment');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Payments');
    }

    public static function getNavigationBadge(): ?string
    {
        $count = static::getModel()::whereIn('status', ['submitted', 'pending'])->count();
        return $count > 0 ? (string) $count : null;
    }

    public static function getNavigationBadgeColor(): ?string
    {
        return 'warning';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Payment Details'))
                    ->schema([
                        Forms\Components\Select::make('order_id')
                            ->label(__('Order'))
                            ->relationship('order', 'order_number')
                            ->disabled(),

                        Forms\Components\TextInput::make('payment_method')
                            ->label(__('Payment Method'))
                            ->disabled(),

                        Forms\Components\TextInput::make('transaction_reference')
                            ->label(__('Transaction Reference'))
                            ->disabled(),

                        Forms\Components\Select::make('status')
                            ->label(__('Status'))
                            ->options([
                                'submitted' => __('Pending Review'),
                                'pending' => __('Pending Review'),
                                'approved' => __('Approved'),
                                'rejected' => __('Rejected'),
                            ])
                            ->required(),

                        Forms\Components\FileUpload::make('receipt_image_path')
                            ->label(__('Receipt Image'))
                            ->image()
                            ->disabled(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('order.order_number')
                    ->label(__('Order #'))
                    ->searchable()
                    ->sortable()
                    ->copyable()
                    ->weight('bold')
                    ->color('primary'),

                Tables\Columns\TextColumn::make('order.user.name')
                    ->label(__('Student'))
                    ->searchable()
                    ->sortable()
                    ->description(fn (Payment $record): string => $record->order?->user?->phone ?? $record->order?->user?->email ?? ''),

                Tables\Columns\TextColumn::make('order.course.title')
                    ->label(__('Course'))
                    ->limit(35)
                    ->tooltip(fn (Payment $record): ?string => $record->order?->course?->title),

                Tables\Columns\TextColumn::make('order.total_dzd')
                    ->label(__('Amount'))
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
                    })
                    ->formatStateUsing(fn (string $state): string => match (strtolower($state)) {
                        'baridimob' => 'بريدي موب (BaridiMob)',
                        'ccp' => 'حوالة بريدية (CCP)',
                        'card' => 'بطاقة بنكية (Card)',
                        default => ucfirst($state),
                    }),

                Tables\Columns\TextColumn::make('transaction_reference')
                    ->label(__('Ref #'))
                    ->searchable()
                    ->copyable()
                    ->placeholder('—'),

                Tables\Columns\ImageColumn::make('receipt_url')
                    ->label(__('Receipt'))
                    ->circular(false)
                    ->square()
                    ->size(48)
                    ->checkFileExistence(false)
                    ->extraImgAttributes(['class' => 'rounded-lg border shadow-sm cursor-pointer']),

                Tables\Columns\TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'approved' => 'success',
                        'submitted', 'pending' => 'warning',
                        'rejected' => 'danger',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'approved' => __('Approved'),
                        'submitted', 'pending' => __('Pending Review'),
                        'rejected' => __('Rejected'),
                        default => ucfirst($state),
                    }),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Submitted At'))
                    ->dateTime('Y-m-d H:i')
                    ->sortable()
                    ->toggleable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->label(__('Status'))
                    ->options([
                        'submitted' => __('Pending Review'),
                        'approved' => __('Approved'),
                        'rejected' => __('Rejected'),
                    ]),

                Tables\Filters\SelectFilter::make('payment_method')
                    ->label(__('Payment Method'))
                    ->options([
                        'baridimob' => 'BaridiMob',
                        'ccp' => 'CCP',
                        'card' => 'Card',
                    ]),
            ])
            ->actions([
                Tables\Actions\Action::make('viewReceipt')
                    ->label(__('View Receipt'))
                    ->icon('heroicon-o-eye')
                    ->color('info')
                    ->modalHeading(fn (Payment $record): string => __('Receipt Verification') . ' — ' . ($record->order?->order_number ?? ''))
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(fn (Payment $record): HtmlString => new HtmlString('
                        <div class="space-y-4 text-center">
                            <div class="flex justify-center p-2 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                                <img src="' . htmlspecialchars($record->receipt_url ?? '') . '" alt="Receipt" style="max-height: 480px;" class="rounded-lg shadow object-contain">
                            </div>
                            <div class="grid grid-cols-2 gap-3 text-start bg-slate-50 dark:bg-slate-800 p-4 rounded-xl text-sm">
                                <div><strong class="text-slate-500">' . __('Student') . ':</strong> ' . htmlspecialchars($record->order?->user?->name ?? '—') . '</div>
                                <div><strong class="text-slate-500">' . __('Amount') . ':</strong> ' . number_format($record->order?->total_dzd ?? 0, 2) . ' د.ج</div>
                                <div><strong class="text-slate-500">' . __('Payment Method') . ':</strong> ' . htmlspecialchars($record->payment_method ?? '—') . '</div>
                                <div><strong class="text-slate-500">' . __('Transaction Reference') . ':</strong> ' . htmlspecialchars($record->transaction_reference ?? '—') . '</div>
                            </div>
                        </div>
                    ')),

                Tables\Actions\Action::make('approve')
                    ->label(__('Approve'))
                    ->icon('heroicon-o-check-circle')
                    ->color('success')
                    ->requiresConfirmation()
                    ->modalHeading(__('Approve Payment & Enroll Student'))
                    ->modalDescription(__('Are you sure you want to approve this payment? The order will be completed and the student will be immediately enrolled in the course.'))
                    ->visible(fn (Payment $record): bool => $record->status !== 'approved')
                    ->action(function (Payment $record) {
                        $record->update([
                            'status' => 'approved',
                            'verified_by_user_id' => auth()->id(),
                        ]);

                        if ($record->order) {
                            $record->order->update(['status' => 'completed']);

                            // Enroll in purchased courses
                            foreach ($record->order->items as $item) {
                                if ($item->product?->course_id) {
                                    CourseEnrollment::updateOrInsert(
                                        [
                                            'user_id' => $record->order->user_id,
                                            'course_id' => $item->product->course_id,
                                        ],
                                        [
                                            'order_id' => $record->order_id,
                                            'status' => 'active',
                                            'access_until' => now()->addMonths(12),
                                            'created_at' => now(),
                                            'updated_at' => now(),
                                        ]
                                    );
                                }
                            }
                        }

                        Notification::make()
                            ->title(__('Payment Approved Successfully'))
                            ->body(__('The student has been enrolled into the course.'))
                            ->success()
                            ->send();
                    }),

                Tables\Actions\Action::make('reject')
                    ->label(__('Reject'))
                    ->icon('heroicon-o-x-circle')
                    ->color('danger')
                    ->requiresConfirmation()
                    ->modalHeading(__('Reject Payment'))
                    ->modalDescription(__('Are you sure you want to reject this payment receipt? The order will be cancelled.'))
                    ->visible(fn (Payment $record): bool => $record->status !== 'rejected')
                    ->action(function (Payment $record) {
                        $record->update([
                            'status' => 'rejected',
                            'verified_by_user_id' => auth()->id(),
                        ]);

                        if ($record->order) {
                            $record->order->update(['status' => 'cancelled']);
                        }

                        Notification::make()
                            ->title(__('Payment Rejected'))
                            ->body(__('The payment has been marked as rejected and order cancelled.'))
                            ->warning()
                            ->send();
                    }),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListPayments::route('/'),
        ];
    }
}
