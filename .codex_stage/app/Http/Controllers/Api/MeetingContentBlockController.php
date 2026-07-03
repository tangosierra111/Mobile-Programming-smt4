<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\SaveContentBlockRequest;
use App\Http\Resources\ContentBlockResource;
use App\Models\Meeting;
use App\Models\MeetingContentBlock;
use Illuminate\Http\JsonResponse;

class MeetingContentBlockController extends ApiController
{
    public function store(
        SaveContentBlockRequest $request,
        Meeting $meeting,
    ): JsonResponse {
        $block = $meeting->contentBlocks()->create($request->validated());

        return $this->success(
            (new ContentBlockResource($block))->resolve($request),
            'Blok konten berhasil ditambahkan.',
            201,
        );
    }

    public function update(
        SaveContentBlockRequest $request,
        MeetingContentBlock $contentBlock,
    ): JsonResponse {
        $contentBlock->update($request->validated());

        return $this->success(
            (new ContentBlockResource($contentBlock->fresh()))->resolve($request),
            'Blok konten berhasil diperbarui.',
        );
    }

    public function destroy(MeetingContentBlock $contentBlock): JsonResponse
    {
        $contentBlock->delete();

        return $this->success(null, 'Blok konten berhasil dihapus.');
    }
}
