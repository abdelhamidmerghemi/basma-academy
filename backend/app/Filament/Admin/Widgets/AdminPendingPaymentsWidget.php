<?php

namespace App\Filament\Admin\Widgets;

use App\Models\CourseEnrollment;
use App\Models\Payment;
use Filament\Notifications\Notification;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;
use Illuminate\Support\HtmlString;

class AdminPendingPaymentsWidget extends BaseWidget
{
    protected static ?int $sort = 4;

    protected int | string | array $columnSpan = 'full';

    public function getHeading(): string
    {
        return __('Latest Pending Payment Receipts Awaiting Verification');
    }

    public function table(Table $table): Table
    {
        return $table
            ->query(
                Payment::query()
                    ->whereIn('status', ['submitted', 'pending'])
                    ->latest()
            )
            ->columns([
                Tables\Columns\TextColumn::make('order.order_number')
                    ->label(__('Order #'))
                    ->weight('bold')
                    ->color('primary')
                    ->copyable(),

                Tables\Columns\TextColumn::make('order.user.name')
                    ->label(__('Student'))
                    ->description(fn (Payment $record) => $record->order?->user?->phone ?? ''),

                Tables\Columns\TextColumn::make('order.course.title')
                    ->label(__('Course'))
                    ->limit(35),

                Tables\Columns\TextColumn::make('order.total_dzd')
                    ->label(__('Amount'))
                    ->money('DZD')
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

                Tables\Columns\ImageColumn::make('receipt_url')
                    ->label(__('Receipt'))
                    ->square()
                    ->size(40)
                    ->checkFileExistence(false)
                    ->extraImgAttributes(['class' => 'rounded-lg border shadow-sm']),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Submitted At'))
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
            ])
            ->actions([
                Tables\Actions\Action::make('viewReceiptModal')
                    ->label(__('View Receipt'))
                    ->icon('heroicon-o-eye')
                    ->color('info')
                    ->modalHeading(fn (Payment $record): string => __('Receipt Verification') . ' — ' . ($record->order?->order_number ?? ''))
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(fn (Payment $record): HtmlString => new HtmlString('
                        <div class="space-y-4 text-center">
                            <div class="flex justify-center p-2 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                                <img src="' . htmlspecialchars($record->receipt_url ?? '') . '" alt="Receipt" style="max-height: 450px;" class="rounded-lg shadow object-contain">
                            </div>
                            <div class="grid grid-cols-2 gap-3 text-start bg-slate-50 dark:bg-slate-800 p-4 rounded-xl text-sm">
                                <div><strong class="text-slate-500">' . __('Student') . ':</strong> ' . htmlspecialchars($record->order?->user?->name ?? '—') . '</div>
                                <div><strong class="text-slate-500">' . __('Amount') . ':</strong> ' . number_format($record->order?->total_dzd ?? 0, 2) . ' د.ج</div>
                                <div><strong class="text-slate-500">' . __('Payment Method') . ':</strong> ' . htmlspecialchars($record->payment_method ?? '—') . '</div>
                                <div><strong class="text-slate-500">' . __('Transaction Reference') . ':</strong> ' . htmlspecialchars($record->transaction_reference ?? '—') . '</div>
                            </div>
                        </div>
                    ')),

                Tables\Actions\Action::make('approveDirect')
                    ->label(__('Approve'))
                    ->icon('heroicon-o-check-circle')
                    ->color('success')
                    ->requiresConfirmation()
                    ->modalHeading(__('Approve Payment & Enroll Student'))
                    ->action(function (Payment $record) {
                        $record->update([
                            'status' => 'approved',
                            'verified_by_user_id' => auth()->id(),
                        ]);

                        if ($record->order) {
                            $record->order->update(['status' => 'completed']);

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
                            ->body(__('The student was enrolled and the order marked completed.'))
                            ->success()
                            ->send();
                    }),
            ])
            ->emptyStateHeading(__('No Pending Receipts Awaiting Verification'))
            ->emptyStateDescription(__('All submitted student payments have been reviewed and approved.'))
            ->emptyStateIcon('heroicon-o-check-badge');
    }
}
