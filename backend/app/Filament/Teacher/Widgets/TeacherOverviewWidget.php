<?php

namespace App\Filament\Teacher\Widgets;

use App\Models\Announcement;
use App\Models\Course;
use App\Models\CourseEnrollment;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class TeacherOverviewWidget extends BaseWidget
{
    protected function getStats(): array
    {
        $user = auth()->user();
        $teacherProfile = $user?->teacherProfile;
        $teacherProfileId = $teacherProfile?->id ?? 0;

        $coursesCount = Course::where('teacher_profile_id', $teacherProfileId)->count();
        $publishedCoursesCount = Course::where('teacher_profile_id', $teacherProfileId)->where('is_published', true)->count();

        $enrolledStudentsCount = CourseEnrollment::whereHas('course', function ($query) use ($teacherProfileId) {
            $query->where('teacher_profile_id', $teacherProfileId);
        })->distinct('user_id')->count('user_id');

        $announcementsCount = Announcement::where('user_id', auth()->id())->count();
        $rating = number_format($teacherProfile?->rating_cache ?? 5.0, 1);

        return [
            Stat::make(__('My Courses'), $coursesCount)
                ->description(__(':count Published', ['count' => $publishedCoursesCount]))
                ->descriptionIcon('heroicon-m-academic-cap')
                ->color('primary'),

            Stat::make(__('Enrolled Students'), $enrolledStudentsCount)
                ->description(__('Active Student Enrollments'))
                ->descriptionIcon('heroicon-m-user-group')
                ->color('success'),

            Stat::make(__('Announcements'), $announcementsCount)
                ->description(__('Published Updates'))
                ->descriptionIcon('heroicon-m-megaphone')
                ->color('info'),

            Stat::make(__('Teacher Rating'), "★ {$rating}")
                ->description(__('Student Satisfaction'))
                ->descriptionIcon('heroicon-m-star')
                ->color('warning'),
        ];
    }
}
