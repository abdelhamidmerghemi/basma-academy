<?php

namespace App\Domain\AI\Services;

use App\Models\AiMessage;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GeminiStreamingService 
{
    /**
     * Stream real-time Gemini AI response via Server-Sent Events (SSE) with conversation history context
     * and automatic model fallback when a model experiences high demand or rate limits.
     *
     * @param string $userPrompt
     * @param string $streamCode
     * @param int|null $conversationId
     * @param array $historyMessages Array of past AiMessage models
     * @return StreamedResponse
     */
    public function streamTutorResponse(
        ?string $userPrompt = '', 
        string $streamCode = 'BAC_Sciences',
        ?int $conversationId = null,
        array $historyMessages = [],
        ?string $imageBase64 = null,
        ?string $imageMimeType = null
    ): StreamedResponse {
        return response()->stream(function () use ($userPrompt, $streamCode, $conversationId, $historyMessages, $imageBase64, $imageMimeType) {
            $apiKey = config('services.gemini.api_key', env('GEMINI_API_KEY'));
            
            $fallbackModels = [
                config('services.gemini.model', 'gemini-2.0-flash'),
                'gemini-2.0-flash',
                'gemini-2.0-flash-lite',
                'gemini-flash-latest',
            ];

            $fallbackModels = array_values(array_unique($fallbackModels));

            $systemInstruction = <<<EOT
You are Basma Academy AI, an expert tutor for Algerian BAC students ({$streamCode} stream). Answer in Arabic or French.

PRIMARY RULE
Every new user message must be treated as a completely new task unless the user explicitly refers to something said earlier.

CONVERSATION MEMORY
The previous conversation is provided only as optional background context.
Never assume that previous assistant responses are correct or relevant to the current question.

RELEVANCE CHECK
Before generating an answer, silently determine whether the previous conversation is directly related to the user's latest message.

If the previous conversation is NOT directly related:
- Ignore all previous assistant responses.
- Ignore the wording, style and format of previous assistant responses.
- Do not continue, imitate or paraphrase previous assistant responses.
- Answer only the latest user message.

If the previous conversation IS directly related:
- Use only the minimum amount of relevant context.
- Never copy previous responses verbatim.
- Generate a fresh answer.

TOPIC CHANGES
Whenever the topic changes, completely switch context to the new topic.
Never let a previous topic influence an unrelated one.

OUTPUT RULES
Always answer the user's latest message directly.
Never repeat a previous assistant answer unless the user explicitly asks you to repeat it.
Never answer an unrelated question using information from a previous assistant message.

MATHEMATICAL & LATEX FORMATTING DIRECTIVES
- ALL math formulas, equations, probabilities, fractions, and variables MUST be wrapped in LaTeX delimiters:
  * Use inline math \$ ... \$ for single variables or small expressions inside sentences (e.g., \$X = 1\$, \$P(X = 2)\$).
  * Use block math \$\$ ... \$\$ on its own separate line for full multi-term equations or long calculations.
- NEVER write math equations or parentheses like P(X=2) as plain text. Always wrap them in LaTeX syntax (e.g. \$P(X = 2) = \\frac{27}{40}\$).
- Put long equations on their own lines as block math \$\$ ... \$\$ so they do not overflow line boundaries.

VISION EXERCISE SOLVER DIRECTIVES
When an exercise image is provided:
1. First, perform OCR to clearly extract text, equations, and diagrams from the image under: 🔍 **النص/المسألة المستخرجة**
2. List the given parameters under: 📝 **المعطيات والملاحظات**
3. Provide a clear step-by-step mathematical and physical solution using LaTeX formatting under: 💡 **خطوات الحل التفصيلية والقوانين**
4. Highlight the final numerical answer and key BAC exam tips under: 🎯 **النتيجة النهائية ونصائح البكالوريا**

TONE & STYLE DIRECTIVES
- Maintain a mature, professional, encouraging, and respectful academic tone suitable for high-school / BAC students.
- Do NOT use juvenile or patronizing nicknames such as "يا بطل" or "أختي الطالبة".
- Do NOT repeat intro greetings (such as "أهلاً بك", "أهلاً مجدداً", or "مرحباً") on every turn of an ongoing conversation. Answer the user's question directly without unnecessary greeting prefixes.

You are an educational tutor.
Your priority is answering the user's current question accurately and independently.
EOT;

            if (empty($apiKey)) {
                $fallbackText = "مرحباً بك! أنا مساعدك الذكي لمراجعة البكالوريا. كيف يمكنني مساعدتك اليوم؟";
                if ($conversationId) {
                    AiMessage::create([
                        'conversation_id' => $conversationId,
                        'sender_type'     => 'assistant',
                        'content_text'    => $fallbackText,
                    ]);
                }
                echo "data: " . json_encode(['chunk' => $fallbackText]) . "\n\n";
                ob_flush();
                flush();
                return;
            }

            $recentHistory = array_slice($historyMessages, -6);
            $contents = [];
            foreach ($recentHistory as $msg) {
                $role = ($msg['sender_type'] === 'user') ? 'user' : 'model';
                $contents[] = [
                    'role'  => $role,
                    'parts' => [['text' => $msg['content_text']]],
                ];
            }

            $userParts = [];
            if (!empty($imageBase64)) {
                $userParts[] = [
                    'inline_data' => [
                        'mime_type' => $imageMimeType ?: 'image/jpeg',
                        'data'      => $imageBase64,
                    ],
                ];
            }

            $userPromptText = !empty($userPrompt) 
                ? $userPrompt 
                : (!empty($imageBase64) ? "قم بحل وفحص هذا التمرين المرفق بالصورة تفصيلياً لشهادة البكالوريا." : "");

            $userParts[] = ['text' => $userPromptText];

            $contents[] = [
                'role'  => 'user',
                'parts' => $userParts,
            ];

            $fallbackModels = [
                config('services.gemini.model', 'gemini-2.0-flash'),
                'gemini-2.0-flash',
                'gemini-2.0-flash-lite',
                'gemini-flash-latest',
                'gemini-flash-lite-latest',
            ];

            $fallbackModels = array_values(array_unique($fallbackModels));

            $response = null;
            $lastError = 'Gemini API high demand / service temporarily unavailable';

            foreach ($fallbackModels as $model) {
                try {
                    $url = "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent?key={$apiKey}";

                    $res = Http::timeout(15)
                        ->withHeaders(['Content-Type' => 'application/json'])
                        ->post($url, [
                            'system_instruction' => [
                                'parts' => [['text' => $systemInstruction]],
                            ],
                            'contents' => $contents,
                            'generationConfig' => [
                                'temperature'     => 0.7,
                                'maxOutputTokens' => 4096,
                            ],
                        ]);

                    if ($res->successful()) {
                        $response = $res;
                        break;
                    }

                    $lastError = $res->json('error.message', 'Gemini API error (Status ' . $res->status() . ')');
                    Log::warning("Gemini model [{$model}] failed with status {$res->status()}: {$lastError}. Trying next model.");
                } catch (\Throwable $e) {
                    $lastError = $e->getMessage();
                    Log::warning("Gemini model [{$model}] exception: {$lastError}. Trying next model.");
                }
            }

            if (!$response || $response->failed()) {
                $friendlyFallback = "أعتذر منك، خوادم الذكاء الاصطناعي تشهد ضغطاً عالياً حالياً. يرجى إعادة محاولة طرح السؤال بعد لحظات! 💡";
                if ($conversationId) {
                    AiMessage::create([
                        'conversation_id' => $conversationId,
                        'sender_type'     => 'assistant',
                        'content_text'    => $friendlyFallback,
                    ]);
                }
                echo "data: " . json_encode(['chunk' => $friendlyFallback]) . "\n\n";
                ob_flush();
                flush();
                return;
            }

            $text = data_get($response->json(), 'candidates.0.content.parts.0.text', '');

            if ($conversationId && !empty($text)) {
                AiMessage::create([
                    'conversation_id' => $conversationId,
                    'sender_type'     => 'assistant',
                    'content_text'    => $text,
                ]);
            }

            echo "data: " . json_encode(['chunk' => $text]) . "\n\n";
            ob_flush();
            flush();

        }, 200, [
            'Content-Type'      => 'text/event-stream',
            'Cache-Control'     => 'no-cache',
            'X-Accel-Buffering' => 'no',
        ]);
    }

    /**
     * Generate a synchronous non-streaming Gemini AI response for evaluation/grading.
     *
     * @param string $prompt
     * @return string
     */
    public function generateResponse(string $prompt): string
    {
        $apiKey = config('services.gemini.api_key', env('GEMINI_API_KEY'));
        if (empty($apiKey)) {
            return '';
        }

        $fallbackModels = [
            config('services.gemini.model', 'gemini-2.0-flash'),
            'gemini-2.0-flash',
            'gemini-2.0-flash-lite',
            'gemini-flash-latest',
        ];
        $fallbackModels = array_values(array_unique($fallbackModels));

        foreach ($fallbackModels as $model) {
            try {
                $url = "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent?key={$apiKey}";
                $res = Http::timeout(30)
                    ->withHeaders(['Content-Type' => 'application/json'])
                    ->post($url, [
                        'contents' => [
                            [
                                'role'  => 'user',
                                'parts' => [['text' => $prompt]],
                            ],
                        ],
                        'generationConfig' => [
                            'temperature'     => 0.2,
                            'maxOutputTokens' => 4096,
                        ],
                    ]);

                if ($res->successful()) {
                    $json = $res->json();
                    return $json['candidates'][0]['content']['parts'][0]['text'] ?? '';
                }
            } catch (\Throwable $e) {
                Log::warning("Gemini generateResponse fallback model {$model} failed: " . $e->getMessage());
            }
        }

        return '';
    }
}
