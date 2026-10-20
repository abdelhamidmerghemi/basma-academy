<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/lang/{lang}', function (string $lang) {
    if (in_array($lang, ['ar', 'en', 'fr'])) {
        session(['locale' => $lang]);
    }
    return redirect()->back();
})->name('lang.switch');
