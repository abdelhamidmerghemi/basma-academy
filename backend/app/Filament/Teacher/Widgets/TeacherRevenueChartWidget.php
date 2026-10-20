<?php

namespace App\Filament\Teacher\Widgets;

use App\Models\CourseEnrollment;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Carbon;

class TeacherRevenueChartWidget extends ChartWidget
{
    public function getHeading(): string
    {
        return __('Monthly Earnings & Revenue (DZD)');
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

        $teacherProfileId = auth()->user()?->teacherProfile?->id ?? 0;

        $data = collect(range(5, 0))->map(function ($i) use ($teacherProfileId) {
            $startDate = Carbon::now()->subMonths($i)->startOfMonth();
            $endDate = Carbon::now()->subMonths($i)->endOfMonth();

            $enrollments = CourseEnrollment::with(['course.product'])
                ->whereHas('course', function ($q) use ($teacherProfileId) {
                    $q->where('teacher_profile_id', $teacherProfileId);
                })
                ->whereBetween('created_at', [$startDate, $endDate])
                ->get();

            return (float) $enrollments->sum(function ($enrollment) {
                $product = $enrollment->course?->product;
                return $product ? ($product->sale_price_dzd ?? $product->price_dzd ?? 0) : 0;
            });
        });

        return [
            'datasets' => [
                [
                    'label' => __('Earnings (DZD)'),
                    'data' => $data->toArray(),
                    'fill' => 'start',
                    'borderColor' => '#2563eb',
                    'backgroundColor' => 'rgba(37, 99, 235, 0.15)',
                    'tension' => 0.4,
                    'pointBackgroundColor' => '#2563eb',
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
