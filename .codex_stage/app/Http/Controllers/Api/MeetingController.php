<?php

namespace App\Http\Controllers\Api;

use App\Http\Resources\MeetingResource;
use App\Models\Meeting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MeetingController extends ApiController
{
    public function show(Request $request, Meeting $meeting): JsonResponse
    {
        if ($meeting->status !== 'published' && $request->user()->role === 'student') {
            return $this->error('Materi belum tersedia.', 403);
        }

        $contentBlocks = fn ($query) => $query
            ->when(
                $request->user()->role === 'student',
                fn ($query) => $query->where('is_visible', true),
            )
            ->orderBy('sort_order');

        $meeting->load(['keywords', 'contentBlocks' => $contentBlocks]);

        return $this->success(
            (new MeetingResource($meeting))->resolve($request),
            'Materi berhasil diambil.',
        );
    }
}
