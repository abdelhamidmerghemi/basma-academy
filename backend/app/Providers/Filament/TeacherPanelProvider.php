<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\AuthenticateSession;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Filament\Widgets;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class TeacherPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->id('teacher')
            ->path('teacher')
            ->login(\App\Filament\Teacher\Pages\Auth\Login::class)
            ->font('Cairo', provider: \Filament\FontProviders\GoogleFontProvider::class)
            ->renderHook(
                \Filament\View\PanelsRenderHook::HEAD_END,
                fn (): string => \Illuminate\Support\Facades\Blade::render('
                    <link rel="icon" type="image/png" sizes="32x32" href="{{ asset("images/favicon-white.png") }}?v=white_v1">
                    <link rel="shortcut icon" type="image/png" href="{{ asset("images/favicon-white.png") }}?v=white_v1">
                    <link rel="stylesheet" href="{{ asset("css/teacher-theme.css") }}">
                ')
            )
            ->colors([
                'primary' => Color::Blue,
                'secondary' => Color::Purple,
                'gray' => Color::Slate,
                'success' => Color::Emerald,
                'warning' => Color::Amber,
                'danger' => Color::Rose,
                'info' => Color::Sky,
            ])
            ->darkMode(true)
            ->defaultThemeMode(\Filament\Enums\ThemeMode::Light)
            ->brandName(__('Basma Academy — Teacher Portal'))
            ->brandLogo(asset('images/logo.png') . '?v=transparent_v3')
            ->brandLogoHeight('2.75rem')
            ->favicon(asset('images/favicon-white.png') . '?v=white_v1')
            ->discoverResources(in: app_path('Filament/Teacher/Resources'), for: 'App\\Filament\\Teacher\\Resources')
            ->discoverPages(in: app_path('Filament/Teacher/Pages'), for: 'App\\Filament\\Teacher\\Pages')
            ->pages([
                Pages\Dashboard::class,
            ])
            ->discoverWidgets(in: app_path('Filament/Teacher/Widgets'), for: 'App\\Filament\\Teacher\\Widgets')
            ->widgets([
                \App\Filament\Teacher\Widgets\TeacherOverviewWidget::class,
                \App\Filament\Teacher\Widgets\TeacherRevenueChartWidget::class,
                \App\Filament\Teacher\Widgets\TeacherStudentGrowthChartWidget::class,
            ])
            ->middleware([
                EncryptCookies::class,
                AddQueuedCookiesToResponse::class,
                StartSession::class,
                AuthenticateSession::class,
                ShareErrorsFromSession::class,
                VerifyCsrfToken::class,
                SubstituteBindings::class,
                DisableBladeIconComponents::class,
                DispatchServingFilamentEvent::class,
                \App\Http\Middleware\SetLocale::class,
            ])
            ->authMiddleware([
                Authenticate::class,
                \App\Http\Middleware\EnsureUserIsTeacher::class,
            ]);
    }
}
