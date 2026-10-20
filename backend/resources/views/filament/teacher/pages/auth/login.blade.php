<x-filament-panels::page.simple>
    <div class="lang-switcher-box">
        <button 
            type="button" 
            wire:click="switchLocale('ar')" 
            class="lang-switch-btn {{ app()->getLocale() === 'ar' ? 'active' : '' }}"
        >
            <span>🇸🇦</span>
            <span>العربية</span>
        </button>

        <button 
            type="button" 
            wire:click="switchLocale('en')" 
            class="lang-switch-btn {{ app()->getLocale() === 'en' ? 'active' : '' }}"
        >
            <span>🇬🇧</span>
            <span>English</span>
        </button>

        <button 
            type="button" 
            wire:click="switchLocale('fr')" 
            class="lang-switch-btn {{ app()->getLocale() === 'fr' ? 'active' : '' }}"
        >
            <span>🇫🇷</span>
            <span>Français</span>
        </button>
    </div>

    @if (filament()->hasRegistration())
        <x-slot name="subheading">
            {{ __('filament-panels::pages/auth/login.actions.register.before') }}

            {{ $this->registerAction }}
        </x-slot>
    @endif

    {{ \Filament\Support\Facades\FilamentView::renderHook(\Filament\View\PanelsRenderHook::AUTH_LOGIN_FORM_BEFORE, scopes: $this->getRenderHookScopes()) }}

    <x-filament-panels::form wire:submit="authenticate">
        {{ $this->form }}

        <x-filament-panels::form.actions
            :actions="$this->getCachedFormActions()"
            :full-width="$this->hasFullWidthFormActions()"
        />
    </x-filament-panels::form>

    {{ \Filament\Support\Facades\FilamentView::renderHook(\Filament\View\PanelsRenderHook::AUTH_LOGIN_FORM_AFTER, scopes: $this->getRenderHookScopes()) }}
</x-filament-panels::page.simple>
