<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserIsTeacher
{
    /**
     * Handle an incoming request.
     * Ensure user is authenticated and has an active TeacherProfile.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user || !$user->teacherProfile) {
            abort(403, 'Access denied. Only registered teachers can access the Teacher Dashboard.');
        }

        return $next($request);
    }
}
