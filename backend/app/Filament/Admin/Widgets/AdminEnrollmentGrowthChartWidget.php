<?php

namespace App\Filament\Admin\Widgets;

use App\Models\CourseEnrollment;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Carbon;

class AdminEnrollmentGrowthChartWidget extends ChartWidget
{
    public function getHeading(): string
    {
        return __('Academy Student Subscriptions Growth');
    }

    protected static ?int $sort = 3;

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

            return CourseEnrollment::whereBetween('created_at', [$startDate, $endDate])->count();
        });

        return [
            'datasets' => [
                [
                    'label' => __('New Subscriptions'),
                    'data' => $data->toArray(),
                    'backgroundColor' => 'rgba(37, 99, 235, 0.85)',
                    'borderColor' => '#2563eb',
                    'borderWidth' => 2,
                    'borderRadius' => 8,
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
        return 'bar';
    }
}
