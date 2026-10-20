<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\QuizResource\Pages;
use App\Models\Quiz;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\HtmlString;

class QuizResource extends Resource
{
    protected static ?string $model = Quiz::class;

    protected static ?string $navigationIcon = 'heroicon-o-clipboard-document-check';

    public static function getNavigationGroup(): ?string
    {
        return __('Assessments & Question Banks');
    }

    public static function getNavigationLabel(): string
    {
        return __('Quizzes & Question Banks');
    }

    public static function getModelLabel(): string
    {
        return __('Quiz');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Quizzes');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->with(['lesson.course', 'subject', 'questions.answers', 'attempts.user'])
            ->withCount(['questions', 'attempts']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Quiz Details'))
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label(__('Quiz Title'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\Select::make('subject_id')
                            ->label(__('Subject'))
                            ->relationship('subject', 'name_ar')
                            ->required(),

                        Forms\Components\Select::make('lesson_id')
                            ->label(__('Attached Lesson (Optional)'))
                            ->relationship('lesson', 'title')
                            ->searchable(),

                        Forms\Components\TextInput::make('time_limit_minutes')
                            ->label(__('Time Limit (Minutes)'))
                            ->numeric()
                            ->default(20)
                            ->suffix(__('min'))
                            ->required(),
                    ])->columns(3),

                Forms\Components\Section::make(__('Question Bank & MCQ Answers'))
                    ->schema([
                        Forms\Components\Repeater::make('questions')
                            ->relationship('questions')
                            ->label(__('Questions'))
                            ->schema([
                                Forms\Components\Textarea::make('question_text')
                                    ->label(__('Question Text'))
                                    ->required()
                                    ->rows(2)
                                    ->columnSpanFull(),

                                Forms\Components\TextInput::make('points')
                                    ->label(__('Points / Weight'))
                                    ->numeric()
                                    ->default(2),

                                Forms\Components\TextInput::make('sort_order')
                                    ->label(__('Order'))
                                    ->numeric()
                                    ->default(1),

                                Forms\Components\Repeater::make('answers')
                                    ->relationship('answers')
                                    ->label(__('Answer Options'))
                                    ->schema([
                                        Forms\Components\TextInput::make('answer_text')
                                            ->label(__('Answer Option'))
                                            ->required(),

                                        Forms\Components\Toggle::make('is_correct')
                                            ->label(__('Correct Answer'))
                                            ->default(false),

                                        Forms\Components\TextInput::make('explanation_text')
                                            ->label(__('Explanation (Optional)'))
                                            ->columnSpanFull(),
                                    ])
                                    ->columns(2)
                                    ->columnSpanFull(),
                            ])
                            ->collapsible()
                            ->columnSpanFull(),
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('title')
                    ->label(__('Quiz Title'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->badge()
                    ->color('primary')
                    ->sortable(),

                Tables\Columns\TextColumn::make('lesson.title')
                    ->label(__('Lesson'))
                    ->limit(25)
                    ->placeholder('—'),

                Tables\Columns\TextColumn::make('time_limit_minutes')
                    ->label(__('Time Limit'))
                    ->formatStateUsing(fn ($state) => $state . ' دقيقة')
                    ->sortable(),

                Tables\Columns\TextColumn::make('questions_count')
                    ->label(__('Questions'))
                    ->counts('questions')
                    ->badge()
                    ->color('info')
                    ->sortable(),

                Tables\Columns\TextColumn::make('attempts_count')
                    ->label(__('Student Attempts'))
                    ->counts('attempts')
                    ->badge()
                    ->color('success')
                    ->sortable(),
            ])
            ->actions([
                Tables\Actions\Action::make('inspectQuestions')
                    ->label(__('View Questions'))
                    ->icon('heroicon-o-eye')
                    ->color('info')
                    ->modalHeading(fn (Quiz $record): string => __('Question Bank') . ' — ' . $record->title)
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(function (Quiz $record): HtmlString {
                        $questions = $record->questions()->with('answers')->get();
                        if ($questions->isEmpty()) {
                            return new HtmlString('<div class="p-4 text-center text-slate-500">' . __('No questions added yet.') . '</div>');
                        }

                        $html = '<div class="space-y-4">';
                        foreach ($questions as $qIdx => $q) {
                            $html .= '<div class="p-4 bg-slate-50 dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700">';
                            $html .= '<div class="font-bold text-slate-900 dark:text-slate-100 text-sm mb-2">' . ($qIdx + 1) . '. ' . htmlspecialchars($q->question_text) . ' (' . $q->points . ' نقاط)</div>';
                            $html .= '<div class="space-y-1.5">';
                            foreach ($q->answers as $a) {
                                $correctIcon = $a->is_correct ? '✅' : '⚪';
                                $badgeClass = $a->is_correct ? 'bg-emerald-50 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-200 font-semibold border-emerald-300' : 'bg-white dark:bg-slate-900 border-slate-100 dark:border-slate-800';
                                $html .= '<div class="p-2 ' . $badgeClass . ' rounded-lg border text-xs flex justify-between items-center">
                                    <span>' . $correctIcon . ' ' . htmlspecialchars($a->answer_text) . '</span>
                                    ' . ($a->explanation_text ? '<span class="text-slate-400 text-[10px]">' . htmlspecialchars($a->explanation_text) . '</span>' : '') . '
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
            'index' => Pages\ListQuizzes::route('/'),
            'create' => Pages\CreateQuiz::route('/create'),
            'edit' => Pages\EditQuiz::route('/{record}/edit'),
        ];
    }
}
