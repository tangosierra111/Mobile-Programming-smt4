<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\ExamAttemptController;
use App\Http\Controllers\Api\ExamController;
use App\Http\Controllers\Api\MeetingContentBlockController;
use App\Http\Controllers\Api\MeetingController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ProgressController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::get('/health', fn () => response()->json([
        'success' => true,
        'message' => 'Mobile Programming API is healthy.',
        'data' => ['timestamp' => now()->toISOString()],
        'meta' => null,
    ]));

    Route::middleware('firebase')->group(function (): void {
        Route::post('/auth/sync', [AuthController::class, 'sync']);

        Route::get('/courses', [CourseController::class, 'index']);
        Route::get('/courses/{course}/dashboard', [CourseController::class, 'dashboard']);

        Route::get('/meetings/{meeting}', [MeetingController::class, 'show']);
        Route::put('/meetings/{meeting}/progress', [ProgressController::class, 'update']);

        Route::get('/profile', [ProfileController::class, 'show']);
        Route::put('/profile', [ProfileController::class, 'update']);
        Route::post('/profile/photo', [ProfileController::class, 'uploadPhoto']);

        Route::get('/exams/{exam}', [ExamController::class, 'show']);
        Route::post('/exams/{exam}/attempts', [ExamController::class, 'startAttempt']);
        Route::put(
            '/attempts/{attempt}/answers/{question}',
            [ExamAttemptController::class, 'updateAnswer'],
        );
        Route::post('/attempts/{attempt}/submit', [ExamAttemptController::class, 'submit']);

        Route::middleware('content-manager')->group(function (): void {
            Route::post(
                '/meetings/{meeting}/content-blocks',
                [MeetingContentBlockController::class, 'store'],
            );
            Route::put(
                '/content-blocks/{contentBlock}',
                [MeetingContentBlockController::class, 'update'],
            );
            Route::delete(
                '/content-blocks/{contentBlock}',
                [MeetingContentBlockController::class, 'destroy'],
            );
        });
    });
});
