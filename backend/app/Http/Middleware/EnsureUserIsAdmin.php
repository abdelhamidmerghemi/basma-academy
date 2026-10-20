<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserIsAdmin
{
    /**
     * Handle an incoming request.
     * Ensure user is authenticated and has the admin role.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user || !$user->adminProfile) {
            abort(403, 'Access denied. Only system administrators with an active Admin Profile can access the Admin Panel.');
        }

        return $next($request);
    }
}
