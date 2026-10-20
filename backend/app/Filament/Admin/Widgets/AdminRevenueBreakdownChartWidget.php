<?php

namespace App\Filament\Admin\Widgets;

use App\Models\Order;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Carbon;

class AdminRevenueBreakdownChartWidget extends ChartWidget
{
    public function getHeading(): string
    {
        return __('Academy Monthly Revenue (DZD)');
    }

    protected static ?int $sort = 2;

    protected int | string | array $columnSpan = [
        'sm' => 1,
        'md' => 1,
        'lg' => 1,
    ];

    protected function getData(): array
    {
        $months = collect(range(5, 0))->map(fn ($i) => Carbon::now()->subMonths($i)->locale(app()->getLocale())->translatedFormat('F'));

        $data = collect(range(5, 0))->map(function ($i) {
            $startDate = Carbon::now()->subMonths($i)->startOfMonth();
            $endDate = Carbon::now()->subMonths($i)->endOfMonth();

            return (float) Order::where('status', 'completed')
                ->whereBetween('created_at', [$startDate, $endDate])
                ->sum('total_dzd');
        });

        return [
            'datasets' => [
                [
                    'label' => __('Revenue (DZD)'),
                    'data' => $data->toArray(),
                    'fill' => 'start',
                    'borderColor' => '#4f46e5',
                    'backgroundColor' => 'rgba(79, 70, 229, 0.15)',
                    'tension' => 0.4,
                    'pointBackgroundColor' => '#4f46e5',
                    'pointRadius' => 4,
                ],
            ],
            'labels' => $months->toArray(),
        ];
    }

    protected function getOptions(): array
    {
        return [
            'scales' => [
                'y' => [
                    'beginAtZero' => true,
                    'min' => 0,
                    'suggestedMin' => 0,
                    'ticks' => [
                        'precision' => 0,
                    ],
                ],
            ],
        ];
    }

    protected function getType(): string
    {
        return 'line';
    }
}
