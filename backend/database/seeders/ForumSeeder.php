<?php

namespace Database\Seeders;

use App\Models\ForumPost;
use App\Models\ForumReply;
use App\Models\Subject;
use App\Models\User;
use Illuminate\Database\Seeder;

class ForumSeeder extends Seeder
{
    public function run(): void
    {
        $students = User::where('email', '!=', 'abdelhamid@gmail.com')->limit(10)->get();
        $abdelhamid = User::where('email', 'abdelhamid@gmail.com')->first();
        $subjects = Subject::all();

        if ($students->isEmpty() || $subjects->isEmpty()) return;

        $postsData = [
            [
                'type' => 'question',
                'title' => 'كيف أفرق بين الاستجابة المناعية الخلطية والخلوية في تمارين العلوم؟',
                'content' => 'السلام عليكم زملاء، دائماً أجد صعوبة في التمييز بين نمط الاستجابة المناعية عندما يكون التمرين يتناول مصل أو خلايا LTH. هل هناك قاعدة أساسية للاستدلال المنهجي؟',
                'subject_id' => $subjects->firstWhere('name_ar', 'علوم الطبيعة والحياة')?->id ?? 2,
                'image_path' => 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=1000&q=80',
                'replies' => [
                    [
                        'content' => 'وعليكم السلام! القاعدة الذهبية: إذا كان الاختبار يتضمن نقل المصل فقط وأدى للحماية $\rightarrow$ استجابة خلطية (بواسطة الأجسام المضادة LB). أما إذا تطلب نقل الخلايا اللمفاوية التائية LTC $\rightarrow$ استجابة خلوية.',
                        'is_best' => true,
                    ],
                    [
                        'content' => 'شكراً جزيلاً! هذا التبسيط واضح جداً.',
                        'is_best' => false,
                    ]
                ]
            ],
            [
                'type' => 'discussion',
                'title' => 'أفضل طريقة لمراجعة الرياضيات وتجنب الوقوع في أخطاء الحساب',
                'content' => 'أشارككم تجربتي في تحسين علامتي من 11 إلى 18.5 في الرياضيات: حل البكالوريات السابقة بالوقت المحدد وإعادة التمارين التي أخطأت فيها بنفسي دون النظر للحل المباشر.',
                'subject_id' => $subjects->firstWhere('name_ar', 'الرياضيات')?->id ?? 3,
                'image_path' => 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=1000&q=80',
                'replies' => [
                    [
                        'content' => 'نصيحة ممتازة! التركيز على الدوال والأعداد المركبة يضمن أكثر من 12 نقطة.',
                        'is_best' => false,
                    ]
                ]
            ],
            [
                'type' => 'resource',
                'title' => 'ملخص شامل ومكثف للمتابعة الزمنية والكهرباء (Physics BAC 2026)',
                'content' => 'جمعت لكم جميع القوانين والعلاقات الرياضية في المتابعة الزمنية عن طريق قياس الناقلية وضغط الغاز، إضافة إلى قوانين الوشيعة والمكثفة في ملف واحد.',
                'subject_id' => $subjects->firstWhere('name_ar', 'العلوم الفيزيائية')?->id ?? 1,
                'image_path' => 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1000&q=80',
                'replies' => [
                    [
                        'content' => 'بارك الله فيك ملخص رائع ومفيد جداً!',
                        'is_best' => false,
                    ]
                ]
            ],
            [
                'type' => 'question',
                'title' => 'ماهي خطوات كتابة مقدمة المقالة الفلسفية بطريقة استقصاء بالوضع؟',
                'content' => 'أحتاج تذكير دقيق بالتمهيد، الفكرة الشائعة، ونقيضها، وطرح المشكلة بالنسبة للمنهجية الاستقصائية.',
                'subject_id' => $subjects->firstWhere('name_ar', 'الفلسفة')?->id ?? 6,
                'image_path' => null,
                'replies' => [
                    [
                        'content' => 'المقدمة: 1. تمهيد عام 2. الفكرة الشائعة (عكس الأطروحة) 3. نقيضها (الأطروحة المراد الدفاع عنها) 4. طرح الإشكال: كيف يمكننا الدفاع عن هذه الأطروحة والأخذ برأيها؟',
                        'is_best' => true,
                    ]
                ]
            ],
        ];

        foreach ($postsData as $idx => $p) {
            $author = $students[$idx % count($students)];

            $post = ForumPost::create([
                'user_id' => $author->id,
                'subject_id' => $p['subject_id'],
                'type' => $p['type'],
                'title' => $p['title'],
                'content' => $p['content'],
                'image_path' => $p['image_path'],
                'is_solved' => collect($p['replies'])->contains('is_best', true),
                'created_at' => now()->subDays(rand(1, 10)),
            ]);

            foreach ($p['replies'] as $rep) {
                $replier = $students->random();
                $reply = ForumReply::create([
                    'forum_post_id' => $post->id,
                    'user_id' => $replier->id,
                    'content' => $rep['content'],
                    'is_best_answer' => $rep['is_best'],
                    'created_at' => now()->subHours(rand(2, 24)),
                ]);

                if ($rep['is_best']) {
                    $post->update(['best_reply_id' => $reply->id]);
                }
            }
        }
    }
}
