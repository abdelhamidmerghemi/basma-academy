<?php

namespace App\Filament\Admin\Resources\CourseReviewResource\Pages;

use App\Filament\Admin\Resources\CourseReviewResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListCourseReviews extends ListRecords
{
    protected static string $resource = CourseReviewResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label(__('Add Review')),
        ];
    }
}
