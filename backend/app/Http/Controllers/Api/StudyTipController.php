<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\StudyTip;

class StudyTipController extends Controller
{
    public function index()
    {
        $tips = StudyTip::latest()->get();

        return response()->json([
            'success' => true,
            'data' => $tips,
        ]);
    }
}
