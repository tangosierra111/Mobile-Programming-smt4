<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class SaveContentBlockRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'block_key' => ['required', 'string', 'max:100'],
            'block_type' => [
                'required',
                Rule::in([
                    'heading', 'paragraph', 'bullet_list', 'code',
                    'key_value', 'callout', 'image', 'demo',
                ]),
            ],
            'title' => ['nullable', 'string', 'max:191'],
            'content_json' => ['required', 'array'],
            'sort_order' => ['required', 'integer', 'min:0', 'max:65535'],
            'is_visible' => ['required', 'boolean'],
        ];
    }
}
