<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\StudentResource\Pages;
use App\Models\Course;
use App\Models\CourseEnrollment;
use App\Models\Stream;
use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\HtmlString;

class StudentResource extends Resource
{
    protected static ?string $model = User::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';

    public static function getNavigationGroup(): ?string
    {
        return __('User Management');
    }

    public static function getNavigationLabel(): string
    {
        return __('Students');
    }

    public static function getModelLabel(): string
    {
        return __('Student');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Students');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->whereHas('studentProfile')
            ->with(['studentProfile.stream', 'studentProfile.academicYear', 'enrollments.course'])
            ->withCount('enrollments');
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
                            ->label(__('Full Name'))
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

                Forms\Components\Section::make(__('Academic Profile'))
                    ->relationship('studentProfile')
                    ->schema([
                        Forms\Components\Select::make('academic_year_id')
                            ->label(__('Academic Year'))
                            ->relationship('academicYear', 'name')
                            ->required(),

                        Forms\Components\Select::make('stream_id')
                            ->label(__('Baccalaureate Stream'))
                            ->relationship('stream', 'name_ar')
                            ->required(),

                        Forms\Components\TextInput::make('school_name')
                            ->label(__('High School Name'))
                            ->maxLength(255),

                        Forms\Components\Select::make('wilaya_code')
                            ->label(__('Wilaya'))
                            ->options([
                                1 => '01 - أدرار (Adrar)',
                                2 => '02 - الشلف (Chlef)',
                                3 => '03 - الأغواط (Laghouat)',
                                4 => '04 - أم البواقي (Oum El Bouaghi)',
                                5 => '05 - باتنة (Batna)',
                                6 => '06 - بجاية (Béjaïa)',
                                7 => '07 - بسكرة (Biskra)',
                                8 => '08 - بشار (Béchar)',
                                9 => '09 - البليدة (Blida)',
                                10 => '10 - البويرة (Bouira)',
                                11 => '11 - تمنراست (Tamanrasset)',
                                12 => '12 - تبسة (Tébessa)',
                                13 => '13 - تلمسان (Tlemcen)',
                                14 => '14 - تيارت (Tiaret)',
                                15 => '15 - تيزي وزو (Tizi Ouzou)',
                                16 => '16 - الجزائر العاصمة (Algiers)',
                                17 => '17 - الجلفة (Djelfa)',
                                18 => '18 - جيجل (Jijel)',
                                19 => '19 - سطيف (Sétif)',
                                20 => '20 - سعيدة (Saïda)',
                                21 => '21 - سكيكدة (Skikda)',
                                22 => '22 - سيدي بلعباس (Sidi Bel Abbès)',
                                23 => '23 - عنابة (Annaba)',
                                24 => '24 - قالمة (Guelma)',
                                25 => '25 - قسنطينة (Constantine)',
                                26 => '26 - المدية (Médéa)',
                                27 => '27 - مستغانم (Mostaganem)',
                                28 => '28 - المسيلة (M\'Sila)',
                                29 => '29 - معسكر (Mascara)',
                                30 => '30 - ورقلة (Ouargla)',
                                31 => '31 - وهران (Oran)',
                                32 => '32 - البيض (El Bayadh)',
                                33 => '33 - إليزي (Illizi)',
                                34 => '34 - برج بوعريريج (Bordj Bou Arréridj)',
                                35 => '35 - بومرداس (Boumerdès)',
                                36 => '36 - الطارف (El Tarf)',
                                37 => '37 - تندوف (Tindouf)',
                                38 => '38 - تسمسيلت (Tissemsilt)',
                                39 => '39 - الوادي (El Oued)',
                                40 => '40 - خنشلة (Khenchela)',
                                41 => '41 - سوق أهراس (Souk Ahras)',
                                42 => '42 - تيبازة (Tipaza)',
                                43 => '43 - ميلة (Mila)',
                                44 => '44 - عين الدفلى (Aïn Defla)',
                                45 => '45 - النعامة (Naâma)',
                                46 => '46 - عين تموشنت (Aïn Témouchent)',
                                47 => '47 - غرداية (Ghardaïa)',
                                48 => '48 - غليزان (Relizane)',
                            ])
                            ->searchable(),

                        Forms\Components\FileUpload::make('avatar_path')
                            ->label(__('Avatar Image'))
                            ->image()
                            ->directory('avatars/students'),
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
                    ->label(__('Student Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('phone')
                    ->label(__('Phone'))
                    ->searchable()
                    ->copyable(),

                Tables\Columns\TextColumn::make('studentProfile.stream.name_ar')
                    ->label(__('Stream'))
                    ->badge()
                    ->color(fn (User $record): string => match ($record->studentProfile?->stream_id) {
                        1 => 'success',
                        2 => 'primary',
                        3 => 'warning',
                        4 => 'danger',
                        5 => 'secondary',
                        default => 'info',
                    }),

                Tables\Columns\TextColumn::make('studentProfile.wilaya_code')
                    ->label(__('Wilaya'))
                    ->formatStateUsing(fn (?int $state): string => match ($state) {
                        16 => '16 - الجزائر',
                        25 => '25 - قسنطينة',
                        31 => '31 - وهران',
                        19 => '19 - سطيف',
                        5 => '05 - باتنة',
                        13 => '13 - تلمسان',
                        23 => '23 - عنابة',
                        9 => '09 - البليدة',
                        6 => '06 - بجاية',
                        15 => '15 - تيزي وزو',
                        22 => '22 - سيدي بلعباس',
                        27 => '27 - مستغانم',
                        null => '—',
                        default => (string) $state,
                    })
                    ->sortable(),

                Tables\Columns\TextColumn::make('studentProfile.school_name')
                    ->label(__('School'))
                    ->limit(25)
                    ->toggleable(),

                Tables\Columns\TextColumn::make('enrollments_count')
                    ->label(__('Courses'))
                    ->counts('enrollments')
                    ->badge()
                    ->color('primary')
                    ->sortable(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Joined At'))
                    ->dateTime('Y-m-d')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('stream')
                    ->label(__('Stream'))
                    ->relationship('studentProfile.stream', 'name_ar'),
            ])
            ->actions([
                Tables\Actions\Action::make('manualEnroll')
                    ->label(__('Enroll In Course'))
                    ->icon('heroicon-o-plus-circle')
                    ->color('success')
                    ->form([
                        Forms\Components\Select::make('course_id')
                            ->label(__('Select Course'))
                            ->options(Course::pluck('title', 'id'))
                            ->searchable()
                            ->required(),

                        Forms\Components\Select::make('duration_months')
                            ->label(__('Access Duration'))
                            ->options([
                                1 => 'شهر واحد (1 Month)',
                                3 => '3 أشهر (3 Months)',
                                6 => '6 أشهر (6 Months)',
                                12 => 'سنة دراسية كاملة (12 Months)',
                            ])
                            ->default(12)
                            ->required(),
                    ])
                    ->action(function (User $record, array $data): void {
                        CourseEnrollment::updateOrInsert(
                            [
                                'user_id' => $record->id,
                                'course_id' => $data['course_id'],
                            ],
                            [
                                'status' => 'active',
                                'access_until' => now()->addMonths((int)$data['duration_months']),
                                'created_at' => now(),
                                'updated_at' => now(),
                            ]
                        );

                        Notification::make()
                            ->title(__('Course Access Granted'))
                            ->body(__('The student was successfully enrolled into the course.'))
                            ->success()
                            ->send();
                    }),

                Tables\Actions\Action::make('viewEnrollments')
                    ->label(__('View Courses'))
                    ->icon('heroicon-o-book-open')
                    ->color('info')
                    ->modalHeading(fn (User $record): string => __('Enrolled Courses for') . ' ' . $record->name)
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(function (User $record): HtmlString {
                        $enrollments = $record->enrollments()->with('course')->get();
                        if ($enrollments->isEmpty()) {
                            return new HtmlString('<div class="p-4 text-center text-slate-500">' . __('No active course enrollments.') . '</div>');
                        }

                        $html = '<div class="space-y-3">';
                        foreach ($enrollments as $enr) {
                            $courseTitle = htmlspecialchars($enr->course?->title ?? '—');
                            $status = $enr->status === 'active' ? '<span class="px-2 py-0.5 text-xs bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200 rounded-full font-semibold">نشط (Active)</span>' : '<span class="px-2 py-0.5 text-xs bg-rose-100 text-rose-800 rounded-full font-semibold">غير نشط</span>';
                            $validUntil = $enr->access_until ? \Carbon\Carbon::parse($enr->access_until)->format('Y-m-d') : 'دائم';

                            $html .= '<div class="p-3 bg-slate-50 dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 flex justify-between items-center">
                                <div>
                                    <div class="font-semibold text-slate-900 dark:text-slate-100 text-sm">' . $courseTitle . '</div>
                                    <div class="text-xs text-slate-500 mt-1">صلاحية الوصول حتى: ' . $validUntil . '</div>
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
            'index' => Pages\ListStudents::route('/'),
            'create' => Pages\CreateStudent::route('/create'),
            'edit' => Pages\EditStudent::route('/{record}/edit'),
        ];
    }
}
