<?php

namespace App\Filament\Admin\Widgets;

use App\Models\Course;
use App\Models\Order;
use App\Models\Payment;
use App\Models\StudentProfile;
use App\Models\TeacherProfile;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class AdminOverviewWidget extends BaseWidget
{
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        $totalRevenue = Order::where('status', 'completed')->sum('total_dzd');
        $studentsCount = StudentProfile::count();
        $teachersCount = TeacherProfile::count();
        $publishedCoursesCount = Course::where('is_published', true)->count();
        $pendingPaymentsCount = Payment::whereIn('status', ['submitted', 'pending'])->count();

        return [
            Stat::make(__('Total Academy Revenue'), number_format($totalRevenue, 0) . ' د.ج')
                ->description(__('Gross Paid Orders (DZD)'))
                ->descriptionIcon('heroicon-m-banknotes')
                ->color('success')
                ->chart([15, 25, 40, 65, 95, 140]),

            Stat::make(__('Registered Students'), $studentsCount)
                ->description(__('Active BAC Students'))
                ->descriptionIcon('heroicon-m-academic-cap')
                ->color('primary')
                ->chart([8, 14, 22, 35, 48, 65]),

            Stat::make(__('Teachers & Courses'), "{$teachersCount} " . __('Teachers') . " | {$publishedCoursesCount} " . __('Courses'))
                ->description(__('Academic Faculty & Catalog'))
                ->descriptionIcon('heroicon-m-user-group')
                ->color('info'),

            Stat::make(__('Pending Payment Receipts'), $pendingPaymentsCount)
                ->description($pendingPaymentsCount > 0 ? __('Awaiting Verification') : __('All Receipts Reviewed'))
                ->descriptionIcon('heroicon-m-credit-card')
                ->color($pendingPaymentsCount > 0 ? 'warning' : 'gray'),
        ];
    }
}
