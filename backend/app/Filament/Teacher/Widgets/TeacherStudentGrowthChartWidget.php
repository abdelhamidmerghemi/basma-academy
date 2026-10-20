<?php

namespace App\Filament\Teacher\Widgets;

use App\Models\CourseEnrollment;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Carbon;

class TeacherStudentGrowthChartWidget extends ChartWidget
{
    public function getHeading(): string
    {
        return __('Student Subscriptions & Growth');
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

        $teacherProfileId = auth()->user()?->teacherProfile?->id ?? 0;

        $data = collect(range(5, 0))->map(function ($i) use ($teacherProfileId) {
            $startDate = Carbon::now()->subMonths($i)->startOfMonth();
            $endDate = Carbon::now()->subMonths($i)->endOfMonth();

            return CourseEnrollment::whereHas('course', function ($q) use ($teacherProfileId) {
                $q->where('teacher_profile_id', $teacherProfileId);
            })->whereBetween('created_at', [$startDate, $endDate])
              ->count();
        });

        return [
            'datasets' => [
                [
                    'label' => __('Enrolled Students'),
                    'data' => $data->toArray(),
                    'backgroundColor' => 'rgba(79, 70, 229, 0.85)',
                    'borderColor' => '#4f46e5',
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
