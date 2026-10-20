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

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->login(\App\Filament\Admin\Pages\Auth\Login::class)
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
                'primary' => Color::Indigo,
                'secondary' => Color::Blue,
                'gray' => Color::Slate,
                'success' => Color::Emerald,
                'warning' => Color::Amber,
                'danger' => Color::Rose,
                'info' => Color::Sky,
            ])
            ->darkMode(true)
            ->defaultThemeMode(\Filament\Enums\ThemeMode::Light)
            ->brandName(__('Basma Academy — Administration Console'))
            ->brandLogo(asset('images/logo.png') . '?v=transparent_v3')
            ->brandLogoHeight('2.75rem')
            ->favicon(asset('images/favicon-white.png') . '?v=white_v1')
            ->navigationGroups([
                __('Finance & Payments'),
                __('User Management'),
                __('Academic & Curriculum'),
                __('Assessments & Question Banks'),
                __('Marketing & Community'),
                __('System Settings'),
            ])
            ->discoverResources(in: app_path('Filament/Admin/Resources'), for: 'App\\Filament\\Admin\\Resources')
            ->discoverPages(in: app_path('Filament/Admin/Pages'), for: 'App\\Filament\\Admin\\Pages')
            ->pages([
                Pages\Dashboard::class,
            ])
            ->discoverWidgets(in: app_path('Filament/Admin/Widgets'), for: 'App\\Filament\\Admin\\Widgets')
            ->widgets([
                \App\Filament\Admin\Widgets\AdminOverviewWidget::class,
                \App\Filament\Admin\Widgets\AdminRevenueBreakdownChartWidget::class,
                \App\Filament\Admin\Widgets\AdminEnrollmentGrowthChartWidget::class,
                \App\Filament\Admin\Widgets\AdminPendingPaymentsWidget::class,
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
                \App\Http\Middleware\EnsureUserIsAdmin::class,
            ]);
    }
}
