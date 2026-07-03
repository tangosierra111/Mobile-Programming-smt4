<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureContentManager
{
    public function handle(Request $request, Closure $next): Response
    {
        if (! in_array($request->user()?->role, ['lecturer', 'admin'], true)) {
            return new JsonResponse([
                'success' => false,
                'message' => 'Akses hanya tersedia untuk dosen dan admin.',
            ], 403);
        }

        return $next($request);
    }
}
