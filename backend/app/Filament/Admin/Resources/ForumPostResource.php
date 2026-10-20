<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\ForumPostResource\Pages;
use App\Models\ForumPost;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\HtmlString;

class ForumPostResource extends Resource
{
    protected static ?string $model = ForumPost::class;

    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left-right';

    public static function getNavigationGroup(): ?string
    {
        return __('Marketing & Community');
    }

    public static function getNavigationLabel(): string
    {
        return __('Community Forum');
    }

    public static function getModelLabel(): string
    {
        return __('Discussion Post');
    }

    public static function getPluralModelLabel(): string
    {
        return __('Community Discussions');
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()
            ->with(['user', 'subject', 'replies.user', 'likes', 'views'])
            ->withCount(['replies', 'likes']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make(__('Post Details'))
                    ->schema([
                        Forms\Components\Select::make('user_id')
                            ->label(__('Author'))
                            ->relationship('user', 'name')
                            ->searchable()
                            ->required(),

                        Forms\Components\Select::make('subject_id')
                            ->label(__('Subject'))
                            ->relationship('subject', 'name_ar')
                            ->required(),

                        Forms\Components\Select::make('type')
                            ->label(__('Post Type'))
                            ->options([
                                'question' => __('Question'),
                                'discussion' => __('Discussion'),
                                'resource' => __('Resource / Tip'),
                            ])
                            ->required(),

                        Forms\Components\Toggle::make('is_solved')
                            ->label(__('Solved / Answered'))
                            ->default(false),

                        Forms\Components\TextInput::make('title')
                            ->label(__('Title'))
                            ->required()
                            ->maxLength(255)
                            ->columnSpanFull(),

                        Forms\Components\Textarea::make('content')
                            ->label(__('Content'))
                            ->required()
                            ->rows(5)
                            ->columnSpanFull(),

                        Forms\Components\FileUpload::make('image_path')
                            ->label(__('Attached Image'))
                            ->image()
                            ->directory('forum')
                            ->columnSpanFull(),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('created_at', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('title')
                    ->label(__('Title'))
                    ->searchable()
                    ->sortable()
                    ->limit(45)
                    ->weight('bold'),

                Tables\Columns\TextColumn::make('user.name')
                    ->label(__('Author'))
                    ->searchable()
                    ->sortable(),

                Tables\Columns\TextColumn::make('subject.name_ar')
                    ->label(__('Subject'))
                    ->badge()
                    ->color('primary')
                    ->sortable(),

                Tables\Columns\TextColumn::make('type')
                    ->label(__('Type'))
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'question' => 'warning',
                        'discussion' => 'info',
                        'resource' => 'success',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'question' => 'سؤال (Question)',
                        'discussion' => 'نقاش (Discussion)',
                        'resource' => 'ملخص (Resource)',
                        default => ucfirst($state),
                    }),

                Tables\Columns\TextColumn::make('replies_count')
                    ->label(__('Replies'))
                    ->counts('replies')
                    ->badge()
                    ->color('secondary')
                    ->sortable(),

                Tables\Columns\IconColumn::make('is_solved')
                    ->label(__('Solved'))
                    ->boolean()
                    ->sortable(),

                Tables\Columns\TextColumn::make('created_at')
                    ->label(__('Date'))
                    ->dateTime('Y-m-d H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->actions([
                Tables\Actions\Action::make('inspectReplies')
                    ->label(__('View Thread'))
                    ->icon('heroicon-o-chat-bubble-oval-left')
                    ->color('info')
                    ->modalHeading(fn (ForumPost $record): string => __('Discussion') . ' — ' . $record->title)
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel(__('Close'))
                    ->modalContent(function (ForumPost $record): HtmlString {
                        $html = '<div class="space-y-4">';
                        $html .= '<div class="p-4 bg-blue-50 dark:bg-slate-800 rounded-xl border border-blue-100 dark:border-slate-700">
                            <div class="font-bold text-slate-900 dark:text-slate-100 text-sm">' . htmlspecialchars($record->user?->name ?? '—') . '</div>
                            <div class="text-xs text-slate-700 dark:text-slate-300 mt-2 leading-relaxed">' . nl2br(htmlspecialchars($record->content)) . '</div>
                        </div>';

                        $replies = $record->replies()->with('user')->get();
                        if ($replies->isEmpty()) {
                            $html .= '<div class="p-3 text-center text-slate-400 text-xs">' . __('No replies on this discussion yet.') . '</div>';
                        } else {
                            $html .= '<div class="text-xs font-bold text-slate-500 mt-3">' . __('Replies') . ' (' . $replies->count() . '):</div>';
                            foreach ($replies as $rep) {
                                $bestBadge = $rep->is_best_answer ? '<span class="px-2 py-0.5 text-[10px] bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-200 rounded font-bold">⭐ الإجابة المعتمدة (Best Answer)</span>' : '';
                                $html .= '<div class="p-3 bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 text-xs space-y-1">
                                    <div class="flex justify-between items-center">
                                        <span class="font-semibold text-slate-900 dark:text-slate-100">' . htmlspecialchars($rep->user?->name ?? '—') . '</span>
                                        ' . $bestBadge . '
                                    </div>
                                    <div class="text-slate-600 dark:text-slate-400 mt-1 leading-relaxed">' . nl2br(htmlspecialchars($rep->content)) . '</div>
                                </div>';
                            }
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
            'index' => Pages\ListForumPosts::route('/'),
            'create' => Pages\CreateForumPost::route('/create'),
            'edit' => Pages\EditForumPost::route('/{record}/edit'),
        ];
    }
}
