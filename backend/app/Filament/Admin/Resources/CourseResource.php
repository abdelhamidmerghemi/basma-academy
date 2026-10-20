<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\CourseResource\Pages;
use App\Models\Course;
use App\Models\TeacherProfile;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\HtmlString;

class CourseResource extends Resource
{
    protected static ?string $model = Course::class;

    protected static ?string $navigationIcon = 'heroicon-o-book-open';

    public static function getNavigationGroup(): ?string
    {
        return __('Academic & Curriculum');
    }

    public static function getNavigationLabel(): string
    {
        return __('Courses');
    }

    public static function getModelLabel(): string
    {
        return __('Course');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Courses');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->with(['teacherProfile.user', 'subject', 'streams', 'product', 'sections.lessons.media'])
            ->withCount(['enrollments', 'lessons']);
    }

    public static function getNavigationBadge(): ?string
    {
        return (string) static::getEloquentQuery()->count();
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('CourseDetails')
                    ->tabs([
                        Forms\Components\Tabs\Tab::make(__('Course Information'))
                            ->schema([
                                Forms\Components\TextInput::make('title')
                                    ->label(__('Course Title'))
                                    ->required()
                                    ->maxLength(255)
                                    ->columnSpanFull(),

                                Forms\Components\Select::make('academic_year_id')
                                    ->label(__('Academic Year'))
                                    ->relationship('academicYear', 'name')
                                    ->required(),

                                Forms\Components\Select::make('subject_id')
                                    ->label(__('Subject'))
                                    ->relationship('subject', 'name_ar')
                                    ->required(),

                                Forms\Components\Select::make('teacher_profile_id')
                                    ->label(__('Instructor / Teacher'))
                                    ->options(
                                        TeacherProfile::with('user')
                                            ->get()
                                            ->pluck('user.name', 'id')
                                    )
                                    ->searchable()
                                    ->required(),

                                Forms\Components\CheckboxList::make('streams')
                                    ->label(__('Target Baccalaureate Streams'))
                                    ->relationship('streams', 'name_ar')
                                    ->columns(3)
                                    ->columnSpanFull(),

                                Forms\Components\Textarea::make('description')
                                    ->label(__('Description'))
                                    ->rows(4)
                                    ->columnSpanFull(),

                                Forms\Components\FileUpload::make('thumbnail_path')
                                    ->label(__('Course Thumbnail'))
                                    ->image()
                                    ->directory('courses/thumbnails')
                                    ->columnSpanFull(),

                                Forms\Components\Toggle::make('is_published')
                                    ->label(__('Published'))
                                    ->default(true),
                            ])->columns(2),

                        Forms\Components\Tabs\Tab::make(__('Pricing & Commerce'))
                            ->relationship('product')
                            ->schema([
                                Forms\Components\TextInput::make('price_dzd')
                                    ->label(__('Original Price (DZD)'))
                                    ->numeric()
                                    ->prefix('DZD')
                                    ->required(),

                                Forms\Components\TextInput::make('sale_price_dzd')
                                    ->label(__('Discounted Sale Price (DZD)'))
                                    ->numeric()
                                    ->prefix('DZD'),

                                Forms\Components\Toggle::make('is_active')
                                    ->label(__('Product Active for Purchase'))
                                    ->default(true),
                            ])->columns(2),

                        Forms\Components\Tabs\Tab::make(__('Curriculum Builder'))
                            ->schema([
                                Forms\Components\Repeater::make('sections')
                                    ->relationship('sections')
                                    ->label(__('Chapters & Sections'))
                                    ->schema([
                                        Forms\Components\TextInput::make('title')
                                            ->label(__('Section Title'))
                                            ->required(),

                                        Forms\Components\TextInput::make('sort_order')
                                            ->label(__('Sort Order'))
                                            ->numeric()
                                            ->default(1),

                                        Forms\Components\Repeater::make('lessons')
                                            ->relationship('lessons')
                                            ->label(__('Lessons'))
                                            ->schema([
                                                Forms\Components\TextInput::make('title')
                                                    ->label(__('Lesson Title'))
                                                    ->required(),

                                                Forms\Components\Toggle::make('is_preview')
                                                    ->label(__('Free Preview'))
                                                    ->default(false),

                                                Forms\Components\TextInput::make('sort_order')
                                                    ->label(__('Lesson Order'))
                                                    ->numeric()
                                                    ->default(1),

                                                Forms\Components\Textarea::make('summary_text')
                                                    ->label(__('Summary / Notes'))
                                                    ->rows(2),
                                            ])
                                            ->columns(2)
                                            ->collapsible(),
                                    ])
                                    ->collapsible()
                                    ->columnSpanFull(),
                            ]),
                    ])
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\ImageColumn::make('thumbnail_path')
                    ->label(__('Thumbnail'))
                    ->square()
                    ->size(54)
                    ->checkFileExistence(false)
                    ->extraImgAttributes(['class' => 'rounded-lg border shadow-sm']),

                Tables\Columns\TextColumn::make('title')
                    ->label(__('Course Title'))
                    ->searchable()
                    ->sortable()
                    ->limit(40)
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('teacherProfile.user.name')
                    ->label(__('Instructor'))
                    ->searchable()
                    ->sortable(),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->badge()
                    ->color('primary')
                    ->sortable(),

                Tables\Columns\TextColumn::make('product.price_dzd')
                    ->label(__('Price'))
                    ->formatStateUsing(function (Course $record): string {
                        $original = $record->product?->price_dzd ?? 0;
                        $sale = $record->product?->sale_price_dzd;
                        if ($sale && $sale < $original) {
                            return number_format($sale, 0) . ' د.ج (' . number_format($original, 0) . ')';
                        }
                        return number_format($original, 0) . ' د.ج';
                    })
                    ->sortable(),

                Tables\Columns\TextColumn::make('lessons_count')
                    ->label(__('Lessons'))
                    ->counts('lessons')
                    ->badge()
                    ->color('info')
                    ->sortable(),

                Tables\Columns\TextColumn::make('enrollments_count')
                    ->label(__('Enrolled'))
                    ->counts('enrollments')
                    ->badge()
                    ->color('success')
                    ->sortable(),

                Tables\Columns\IconColumn::make('is_published')
                    ->label(__('Published'))
                    ->boolean()
                    ->sortable(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Created Date'))
                    ->dateTime('Y-m-d')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('subject')
                    ->label(__('Subject'))
                    ->relationship('subject', 'name_ar'),

                Tables\Filters\TernaryFilter::make('is_published')
                    ->label(__('Published Status')),
            ])
            ->actions([
                Tables\Actions\Action::make('inspectCurriculum')
                    ->label(__('Inspect Curriculum'))
                    ->icon('heroicon-o-list-bullet')
                    ->color('info')
                    ->modalHeading(fn (Course $record): string => __('Curriculum & Structure') . ' — ' . $record->title)
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(function (Course $record): HtmlString {
                        $sections = $record->sections()->with('lessons.media')->get();
                        if ($sections->isEmpty()) {
                            return new HtmlString('<div class="p-4 text-center text-slate-500">' . __('No curriculum sections added yet.') . '</div>');
                        }

                        $html = '<div class="space-y-4">';
                        foreach ($sections as $sIdx => $sec) {
                            $html .= '<div class="p-4 bg-slate-50 dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700">';
                            $html .= '<div class="font-bold text-slate-900 dark:text-slate-100 mb-2">' . ($sIdx + 1) . '. ' . htmlspecialchars($sec->title) . ' (' . $sec->lessons->count() . ' دروس)</div>';
                            $html .= '<div class="space-y-2 mt-2">';
                            foreach ($sec->lessons as $lIdx => $les) {
                                $durationMin = $les->media ? round($les->media->duration_seconds / 60) : 0;
                                $previewBadge = $les->is_preview ? '<span class="px-2 py-0.5 text-xs bg-emerald-100 text-emerald-800 rounded-full font-semibold">معاينة مجانية</span>' : '';
                                $html .= '<div class="p-2 bg-white dark:bg-slate-900 rounded-lg border border-slate-100 dark:border-slate-800 flex justify-between items-center text-xs">
                                    <div class="flex items-center space-x-2 rtl:space-x-reverse">
                                        <span class="font-medium text-slate-700 dark:text-slate-300">' . ($lIdx + 1) . '. ' . htmlspecialchars($les->title) . '</span>
                                        ' . $previewBadge . '
                                    </div>
                                    <span class="text-slate-400">' . $durationMin . ' دقيقة</span>
                                </div>';
                            }
                            $html .= '</div></div>';
                        }
                        $html .= '</div>';
                        return new HtmlString($html);
                    }),

                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListCourses::route('/'),
            'create' => Pages\CreateCourse::route('/create'),
            'edit' => Pages\EditCourse::route('/{record}/edit'),
        ];
    }
}
