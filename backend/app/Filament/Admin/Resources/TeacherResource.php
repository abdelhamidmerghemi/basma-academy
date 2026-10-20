<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\TeacherResource\Pages;
use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\HtmlString;

class TeacherResource extends Resource
{
    protected static ?string $model = User::class;

    protected static ?string $navigationIcon = 'heroicon-o-user-group';

    public static function getNavigationGroup(): ?string
    {
        return __('User Management');
    }

    public static function getNavigationLabel(): string
    {
        return __('Teachers');
    }

    public static function getModelLabel(): string
    {
        return __('Teacher');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Teachers');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->whereHas('teacherProfile')
            ->with(['teacherProfile.courses']);
    }

    public static function getNavigationBadge(): ?string
    {
        return (string) static::getEloquentQuery()->count();
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Account Credentials'))
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label(__('Teacher Name'))
                            ->required()
                            ->maxLength(255),

                        Forms\Components\TextInput::make('email')
                            ->label(__('Email Address'))
                            ->email()
                            ->unique(ignoreRecord: true),

                        Forms\Components\TextInput::make('phone')
                            ->label(__('Phone Number'))
                            ->tel()
                            ->required()
                            ->unique(ignoreRecord: true),

                        Forms\Components\TextInput::make('password')
                            ->label(__('Password'))
                            ->password()
                            ->dehydrateStateUsing(fn ($state) => Hash::make($state))
                            ->dehydrated(fn ($state) => filled($state))
                            ->required(fn (string $operation): bool => $operation === 'create'),
                    ])->columns(2),

                Forms\Components\Section::make(__('Teacher Credentials & Bio'))
                    ->relationship('teacherProfile')
                    ->schema([
                        Forms\Components\TextInput::make('headline')
                            ->label(__('Headline / Specialty'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\Textarea::make('bio')
                            ->label(__('Bio & Experience'))
                            ->rows(4)
                            ->columnSpanFull(),

                        Forms\Components\TextInput::make('rating_cache')
                            ->label(__('Rating'))
                            ->numeric()
                            ->default(5.00)
                            ->minValue(1)
                            ->maxValue(5)
                            ->step(0.01),

                        Forms\Components\TextInput::make('reviews_count')
                            ->label(__('Reviews Count'))
                            ->numeric()
                            ->default(0),

                        Forms\Components\FileUpload::make('avatar_path')
                            ->label(__('Profile Avatar'))
                            ->image()
                            ->directory('avatars/teachers')
                            ->columnSpanFull(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\ImageColumn::make('avatar_path')
                    ->label(__('Avatar'))
                    ->circular()
                    ->defaultImageUrl(fn (User $record): ?string => $record->getFilamentAvatarUrl()),

                Tables\Columns\TextColumn::make('name')
                    ->label(__('Teacher Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('phone')
                    ->label(__('Phone'))
                    ->searchable()
                    ->copyable(),

                Tables\Columns\TextColumn::make('teacherProfile.headline')
                    ->label(__('Headline'))
                    ->limit(40)
                    ->tooltip(fn (User $record): ?string => $record->teacherProfile?->headline),

                Tables\Columns\TextColumn::make('teacherProfile.rating_cache')
                    ->label(__('Rating'))
                    ->badge()
                    ->color('warning')
                    ->formatStateUsing(fn ($state): string => '⭐ ' . number_format((float)$state, 2))
                    ->sortable(),

                Tables\Columns\TextColumn::make('teacherProfile.reviews_count')
                    ->label(__('Reviews'))
                    ->badge()
                    ->color('gray')
                    ->sortable(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Joined Date'))
                    ->dateTime('Y-m-d')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->actions([
                Tables\Actions\Action::make('viewTeacherCourses')
                    ->label(__('View Courses'))
                    ->icon('heroicon-o-academic-cap')
                    ->color('info')
                    ->modalHeading(fn (User $record): string => __('Courses of') . ' ' . $record->name)
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(function (User $record): HtmlString {
                        $courses = $record->teacherProfile?->courses()->with('product')->get() ?? collect();
                        if ($courses->isEmpty()) {
                            return new HtmlString('<div class="p-4 text-center text-slate-500">' . __('No courses published yet.') . '</div>');
                        }

                        $html = '<div class="space-y-3">';
                        foreach ($courses as $c) {
                            $price = $c->product?->sale_price_dzd ?? $c->product?->price_dzd ?? 0;
                            $enrolledCount = \App\Models\CourseEnrollment::where('course_id', $c->id)->count();
                            $status = $c->is_published ? '<span class="px-2 py-0.5 text-xs bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200 rounded-full font-semibold">منشور (Published)</span>' : '<span class="px-2 py-0.5 text-xs bg-slate-100 text-slate-800 rounded-full font-semibold">مسودة</span>';

                            $html .= '<div class="p-3 bg-slate-50 dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 flex justify-between items-center">
                                <div>
                                    <div class="font-semibold text-slate-900 dark:text-slate-100 text-sm">' . htmlspecialchars($c->title) . '</div>
                                    <div class="text-xs text-slate-500 mt-1">السعر: ' . number_format($price, 2) . ' د.ج | عدد الطلاب المسجلين: ' . $enrolledCount . '</div>
                                </div>
                                <div>' . $status . '</div>
                            </div>';
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
            'index' => Pages\ListTeachers::route('/'),
            'create' => Pages\CreateTeacher::route('/create'),
            'edit' => Pages\EditTeacher::route('/{record}/edit'),
        ];
    }
}
