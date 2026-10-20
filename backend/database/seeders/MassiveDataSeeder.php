<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use App\Models\Lesson;
use App\Models\Quiz;

class MassiveDataSeeder extends Seeder
{
    /**
     * Seed massive, realistic Algerian BAC data:
     * - 30+ Video Lessons per Subject
     * - 30+ Quizzes per Subject (10 Questions per quiz = 300 questions per subject)
     * - Rich Flashcards, Announcements, Comments, Likes, Views, Reviews, and Progress.
     */
    public function run(): void
    {
        $this->command?->info("🚀 Starting Massive BAC Data Seeder...");

        Schema::disableForeignKeyConstraints();

        DB::table('announcement_comments')->truncate();
        DB::table('announcement_likes')->truncate();
        DB::table('announcement_views')->truncate();
        DB::table('announcements')->truncate();
        DB::table('course_reviews')->truncate();
        DB::table('quiz_attempts')->truncate();
        DB::table('quiz_answers')->truncate();
        DB::table('quiz_questions')->truncate();
        DB::table('quizzes')->truncate();
        DB::table('user_flashcard_progress')->truncate();
        DB::table('flashcards')->truncate();
        DB::table('flashcard_decks')->truncate();
        DB::table('lesson_progress')->truncate();
        DB::table('course_enrollments')->truncate();
        DB::table('lessons')->truncate();
        DB::table('media')->truncate();
        DB::table('course_sections')->truncate();
        DB::table('course_streams')->truncate();
        DB::table('courses')->truncate();
        DB::table('teacher_profiles')->truncate();

        Schema::enableForeignKeyConstraints();

        $studentRoleId = DB::table('roles')->where('name', 'student')->value('id') ?? 1;
        $teacherRoleId = DB::table('roles')->where('name', 'teacher')->value('id') ?? 2;
        $academicYearId = DB::table('academic_years')->where('is_active', true)->value('id') ?? 1;
        $studentUserId = DB::table('users')->where('email', 'abdelhamid@gmail.com')->value('id') ?? 1;

        $this->command?->info("👨‍🏫 Seeding Teachers...");
        $teachersData = [
            ['name' => 'الأستاذ نور الدين', 'email' => 'noureddine@basma.dz', 'bio' => 'أستاذ خبير في الرياضيات للبكالوريا خبرة أكثر من 15 سنة.', 'avatar' => 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&q=80'],
            ['name' => 'الأستاذ شريفي', 'email' => 'cherifi@basma.dz', 'bio' => 'أستاذ العلوم الفيزيائية وتطبيقات المتابعة الزمنية والكهرباء.', 'avatar' => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80'],
            ['name' => 'الأستاذة خيرة سواد', 'email' => 'khaira@basma.dz', 'bio' => 'استاذة علوم الطبيعة والحياة والمناعة والتركيب الضوئي.', 'avatar' => 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&q=80'],
            ['name' => 'الأستاذ سعيداني', 'email' => 'saidani@basma.dz', 'bio' => 'مختص في منهجية المقالة الفلسفية وتحليل النصوص.', 'avatar' => 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80'],
            ['name' => 'الأستاذ بوكلي', 'email' => 'boukli@basma.dz', 'bio' => 'استاذ الأدب العربي والبلاغة وتقنيات الإعراب.', 'avatar' => 'https://images.unsplash.com/photo-1580894732413-a75151b91361?w=400&q=80'],
            ['name' => 'Prof. Harrison', 'email' => 'harrison@basma.dz', 'bio' => 'Senior Foreign Languages Expert for BAC English & French.', 'avatar' => 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80'],
        ];

        $teacherUserIds = [];
        $teacherProfileIds = [];

        foreach ($teachersData as $t) {
            $uId = DB::table('users')->where('email', $t['email'])->value('id');
            if (!$uId) {
                $uId = DB::table('users')->insertGetId([
                    'name' => $t['name'],
                    'phone' => '06' . rand(10000000, 99999999),
                    'email' => $t['email'],
                    'password' => Hash::make('password123'),
                    'email_verified_at' => now(),
                    'phone_verified_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                DB::table('user_roles')->insert(['user_id' => $uId, 'role_id' => $teacherRoleId]);
            }

            $pId = DB::table('teacher_profiles')->where('user_id', $uId)->value('id');
            if (!$pId) {
                $pId = DB::table('teacher_profiles')->insertGetId([
                    'user_id' => $uId,
                    'headline' => 'أستاذ متميز في البكالوريا',
                    'bio' => $t['bio'],
                    'avatar_path' => $t['avatar'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }

            $teacherUserIds[] = $uId;
            $teacherProfileIds[] = $pId;
        }

        $this->command?->info("👥 Seeding Student Community Users...");
        $sampleStudents = [
            'أنور بن علي', 'مريم بلقاسم', 'إلياس تبسي', 'سارة سعيدي', 'أحمد زروقي',
            'فاطمة الزهراء', 'مهدي قواسمي', 'صفاء الشريف', 'ياسين حماني', 'لينا مرابط'
        ];

        $studentUserIds = [$studentUserId];
        foreach ($sampleStudents as $sName) {
            $sPhone = '07' . rand(10000000, 99999999);
            $stId = DB::table('users')->insertGetId([
                'name' => $sName,
                'phone' => $sPhone,
                'email' => Str::slug($sName) . rand(10, 99) . '@gmail.com',
                'password' => Hash::make('password123'),
                'created_at' => now()->subDays(rand(1, 60)),
                'updated_at' => now(),
            ]);
            DB::table('user_roles')->insert(['user_id' => $stId, 'role_id' => $studentRoleId]);
            DB::table('student_profiles')->insert([
                'user_id' => $stId,
                'academic_year_id' => $academicYearId,
                'stream_id' => rand(1, 3),
                'school_name' => 'ثانوية البكالوريا الممتازة',
                'wilaya_code' => rand(1, 58),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            $studentUserIds[] = $stId;
        }

        $subjects = DB::table('subjects')->get();
        if ($subjects->isEmpty()) {
            $this->command?->error("No subjects found! Make sure Base Seeder ran.");
            return;
        }

        $videoSamples = [
            'https://cdn.plyr.io/static/demo/View_From_A_Blue_Moon_Trailer-720p.mp4',
            'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4',
            'https://test-videos.co.uk/vids/jellyfish/mp4/h264/720/Jellyfish_720_10s_5MB.mp4',
            'https://test-videos.co.uk/vids/sintel/mp4/h264/720/Sintel_720_10s_5MB.mp4',
            'https://media.w3.org/2010/05/bunny/trailer.mp4',
            'https://media.w3.org/2010/05/video/movie_300.mp4',
            'https://cdn.plyr.io/static/demo/View_From_A_Blue_Moon_Trailer-576p.mp4',
            'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
            'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/friday.mp4',
            'https://www.w3schools.com/html/mov_bbb.mp4',
            'https://www.w3schools.com/html/movie.mp4',
        ];

        $courseThumbnails = [
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800&q=80',
            'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800&q=80',
            'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80',
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80',
            'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=800&q=80',
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&q=80',
        ];

        foreach ($subjects as $sIndex => $sub) {
            $this->command?->info("📚 Populating Subject: {$sub->name_ar} (ID: {$sub->id})...");

            $teacherProfileId = $teacherProfileIds[$sIndex % count($teacherProfileIds)];

            $courseTitles = [
                "الدورة الشاملة في {$sub->name_ar} — الجزء الأول",
                "سلسلة التمارين النموذجية والبكالوريات السابقة في {$sub->name_ar}",
                "البرنامج المتقدم والملخصات المركزة في {$sub->name_ar}",
            ];

            $subjectLessonIds = [];
            $subjectQuizIds = [];

            foreach ($courseTitles as $cIdx => $cTitle) {
                $thumbUrl = $courseThumbnails[($sIndex * 3 + $cIdx) % count($courseThumbnails)];

                $cId = DB::table('courses')->insertGetId([
                    'subject_id' => $sub->id,
                    'academic_year_id' => $academicYearId,
                    'teacher_profile_id' => $teacherProfileId,
                    'title' => $cTitle,
                    'description' => "شرح مفصل ومترابط لبرنامج {$sub->name_ar} للبكالوريا وفق التدرج الوزاري الجديد مع حل تمارين وتمارين منهجية.",
                    'thumbnail_path' => $thumbUrl,
                    'is_published' => true,
                    'created_at' => now()->subDays(rand(10, 90)),
                    'updated_at' => now(),
                ]);

                for ($stId = 1; $stId <= 5; $stId++) {
                    DB::table('course_streams')->insertOrIgnore([
                        'course_id' => $cId,
                        'stream_id' => $stId,
                    ]);
                }

                $pId = DB::table('products')->insertGetId([
                    'course_id' => $cId,
                    'price_dzd' => (float) (2000 + ($cIdx * 500)),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                if ($cIdx == 0) {
                    DB::table('course_enrollments')->insertOrIgnore([
                        'user_id' => $studentUserId,
                        'course_id' => $cId,
                        'status' => 'active',
                        'created_at' => now()->subDays(15),
                        'updated_at' => now(),
                    ]);
                }

                for ($secIdx = 1; $secIdx <= 5; $secIdx++) {
                    $secId = DB::table('course_sections')->insertGetId([
                        'course_id' => $cId,
                        'title' => "المحور {$secIdx}: " . $this->getSectionName($sub->id, $secIdx),
                        'sort_order' => $secIdx,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);

                    $lessonsInSec = rand(2, 3);
                    for ($lIdx = 1; $lIdx <= $lessonsInSec; $lIdx++) {
                        $mId = DB::table('media')->insertGetId([
                            'provider' => 'local',
                            'type' => 'video',
                            'path' => $videoSamples[rand(0, count($videoSamples) - 1)],
                            'duration_seconds' => rand(600, 2400),
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);

                        $lesId = DB::table('lessons')->insertGetId([
                            'course_id' => $cId,
                            'section_id' => $secId,
                            'media_id' => $mId,
                            'title' => "الدرس {$secIdx}.{$lIdx}: " . $this->getLessonTitle($sub->id, $secIdx, $lIdx),
                            'is_preview' => ($secIdx == 1 && $lIdx == 1),
                            'summary_text' => "ملخص وافي وأفكار أساسية لدرس " . $this->getLessonTitle($sub->id, $secIdx, $lIdx) . " مع المنهجية الرسمية.",
                            'sort_order' => $lIdx,
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);

                        $subjectLessonIds[] = $lesId;
                    }
                }

                for ($r = 0; $r < rand(3, 6); $r++) {
                    $reviewerId = $studentUserIds[rand(0, count($studentUserIds) - 1)];
                    DB::table('course_reviews')->insertOrIgnore([
                        'course_id' => $cId,
                        'user_id' => $reviewerId,
                        'rating' => rand(4, 5),
                        'comment' => $this->getRandomComment(),
                        'created_at' => now()->subDays(rand(1, 30)),
                        'updated_at' => now(),
                    ]);
                }
            }

            $this->command?->info("   ❓ Generating 30 Quizzes (300 Questions) for {$sub->name_ar}...");

            for ($qIdx = 1; $qIdx <= 30; $qIdx++) {
                $linkedLessonId = !empty($subjectLessonIds) ? $subjectLessonIds[($qIdx - 1) % count($subjectLessonIds)] : null;

                $quizId = DB::table('quizzes')->insertGetId([
                    'subject_id' => $sub->id,
                    'lesson_id' => $linkedLessonId,
                    'title' => "اختبار تقويمي {$qIdx} — {$sub->name_ar}: " . $this->getQuizTopic($sub->id, $qIdx),
                    'time_limit_minutes' => rand(10, 20),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                $subjectQuizIds[] = $quizId;

                // 10 Questions per Quiz
                for ($qn = 1; $qn <= 10; $qn++) {
                    $qText = "السؤال {$qn}: " . $this->getQuestionText($sub->id, $qIdx, $qn);

                    $qId = DB::table('quiz_questions')->insertGetId([
                        'quiz_id' => $quizId,
                        'question_text' => $qText,
                        'points' => 2,
                        'sort_order' => $qn,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);

                    $options = $this->getQuestionAnswers($sub->id, $qIdx, $qn);
                    foreach ($options as $optIdx => $opt) {
                        DB::table('quiz_answers')->insert([
                            'question_id' => $qId,
                            'answer_text' => $opt['text'],
                            'is_correct' => $opt['is_correct'],
                            'explanation_text' => $opt['explanation'] ?? 'الشرح والتبرير العلمي الصحيح بناءً على المنهاج الرسمى.',
                            'created_at' => now(),
                            'updated_at' => now(),
                        ]);
                    }
                }
            }

            for ($d = 1; $d <= 6; $d++) {
                $deckId = DB::table('flashcard_decks')->insertGetId([
                    'subject_id' => $sub->id,
                    'title' => "بطاقات الذاكرة {$d}: " . $this->getDeckTitle($sub->id, $d),
                    'description' => "بطاقات المراجعة السريعة والمصطلحات والقوانين الحاسمة للبكالوريا.",
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                for ($fc = 1; $fc <= 6; $fc++) {
                    DB::table('flashcards')->insert([
                        'deck_id' => $deckId,
                        'question_text' => "سؤال البطاقة {$fc}: " . $this->getFlashcardQuestion($sub->id, $d, $fc),
                        'answer_text' => "الإجابة النموذجية: " . $this->getFlashcardAnswer($sub->id, $d, $fc),
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        }

        $this->command?->info("📢 Seeding Community Announcements, Comments & Likes...");

        $announcementPhotos = [
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=1000&q=80',
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1000&q=80',
            'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=1000&q=80',
            'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=1000&q=80',
            'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1000&q=80',
        ];

        $announcementTopics = [
            ['title' => 'نصائح حاسمة لتنظيم الوقت خلال تحضيرات البكالوريا 🎯', 'body' => 'أعزائي الطلاب، الانضباط اليومي وحل البكالوريات السابقة بجدية هو المفتاح الذهبي لنيل معدل ممتاز.'],
            ['title' => 'تنبيه: تم نشر دورة التمارين النموذجية في المتابعة الزمنية والكهرباء ⚡', 'body' => 'تجدون الآن مجموعة من التمارين المرفقة بالحلول المفصلة وفق سلم التنقيط الرسمي.'],
            ['title' => 'كيفية الحصول على العلامة الكاملة في المقالة الفلسفية 📝', 'body' => 'المنهجية الصحيحة (مقدمة، طرح الأطروحة، نقد، تركيب، وخاتمة) ترتكز على التبرير بالاستشهادات الفلسفية.'],
            ['title' => 'مراجعة شاملة لآليات تركيب البروتين والمناعة 🧬', 'body' => 'تم إضافة ملخصات بصرية تفاعلية ورسومات تخطيطية لمساعدتكم على ترسيخ الحفظ والفهم.'],
            ['title' => 'برنامج البث المباشر لأسبوع التقييم والمراجعة 🎥', 'body' => 'انضموا إلينا هذا الجمعة في تمام الساعة 19:00 في بث مباشر للإجابة عن تساؤلاتكم.'],
        ];

        foreach ($announcementTopics as $idx => $aTopic) {
            $authorId = $teacherUserIds[$idx % count($teacherUserIds)];
            $photoUrl = $announcementPhotos[$idx % count($announcementPhotos)];

            $annId = DB::table('announcements')->insertGetId([
                'user_id' => $authorId,
                'content' => "{$aTopic['title']}\n\n{$aTopic['body']}",
                'image_path' => $photoUrl,
                'created_at' => now()->subDays(rand(1, 20)),
                'updated_at' => now(),
            ]);

            // Add 5-10 Likes per announcement
            foreach ($studentUserIds as $stId) {
                if (rand(0, 1) == 1) {
                    DB::table('announcement_likes')->insertOrIgnore([
                        'announcement_id' => $annId,
                        'user_id' => $stId,
                        'created_at' => now(),
                    ]);
                }
                DB::table('announcement_views')->insertOrIgnore([
                    'announcement_id' => $annId,
                    'user_id' => $stId,
                    'created_at' => now(),
                ]);
            }

            // Add 3-5 Comments per announcement
            for ($cm = 0; $cm < rand(3, 5); $cm++) {
                $commenterId = $studentUserIds[rand(0, count($studentUserIds) - 1)];
                DB::table('announcement_comments')->insert([
                    'announcement_id' => $annId,
                    'user_id' => $commenterId,
                    'content' => $this->getRandomStudentComment(),
                    'created_at' => now()->subHours(rand(1, 48)),
                    'updated_at' => now(),
                ]);
            }
        }

        $this->command?->info("📊 Seeding Student Progress & Attempts for Knowledge Graph...");

        $allLessons = DB::table('lessons')->pluck('id');
        $allQuizzes = DB::table('quizzes')->pluck('id');

        // Mark ~35% of lessons completed for realistic roadmap statuses
        foreach ($allLessons as $lIndex => $lId) {
            if ($lIndex % 3 == 0) {
                DB::table('lesson_progress')->insert([
                    'user_id' => $studentUserId,
                    'lesson_id' => $lId,
                    'seconds_watched' => 1200,
                    'last_position_seconds' => 1200,
                    'is_completed' => true,
                    'last_watched_at' => now()->subDays(rand(1, 10)),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        // Record Quiz Attempts
        foreach ($allQuizzes as $qIndex => $qId) {
            if ($qIndex % 3 == 0) {
                $score = rand(60, 100);
                DB::table('quiz_attempts')->insert([
                    'user_id' => $studentUserId,
                    'quiz_id' => $qId,
                    'score' => $score,
                    'passed' => $score >= 50,
                    'started_at' => now()->subMinutes(15),
                    'completed_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        $this->command?->info("💬 Seeding Student Community Forum Questions & Discussions...");
        $this->call(ForumSeeder::class);

        $this->command?->info("✅ Massive Seeding Completed Successfully!");
    }

    private function getSectionName(int $subId, int $idx): String
    {
        $names = [
            1 => ['المتابعة الزمنية كيميائياً', 'التحولات النووية', 'الدارات RC و RL', 'توازن أحماض وأسس', 'حركة الكواكب والميكانيك'],
            3 => ['عموميات على الدوال والاستمرارية', 'الدوال الأسية والتطبيقات', 'الدوال اللوغاريتمية والمعادلات', 'المتتاليات العددية والبرهان بالتراجع', 'الاحتمالات الشرطية والاستثنائية'],
            2 => ['تركيب البروتين والاستنساخ', 'البنية ثلاثية الأبعاد للبروتينات', 'النشاط الإنزيمي والشروط المحيطية', 'المناعة والدفاع عن الذات', 'الأتصال العصبي والمشابك'],
        ];
        return $names[$subId][$idx - 1] ?? "المحور الرئيسي {$idx}";
    }

    private function getLessonTitle(int $subId, int $sec, int $les): String
    {
        return "المفهوم والتطبيقات الأساسية {$sec}.{$les} (منهجية البكالوريا)";
    }

    private function getQuizTopic(int $subId, int $idx): String
    {
        $topics = [
            'الناقلية وسرعة التفاعل', 'عمر النصف والتفكك الإشعاعي', 'شحن وتفريغ المكثفة', 'البيئة الحمضية ومعايرة pH',
            'قوانين كبلر والحركة الدائرية', 'حساب النهايات والتزايد المقارن', 'المعادلات التفاضلية للنمو الأسية', 'حساب حدود متتالية هندسية',
            'التحفيز الإنزيمي والموقع الفعال', 'الاستجابة المناعية الخلطية والخلوية'
        ];
        return $topics[($idx - 1) % count($topics)];
    }

    private function getQuestionText(int $subId, int $qIdx, int $qn): String
    {
        return "اختر الإجابة الدقيقة المتعلقة بالمفهوم {$qn} في هذا الجزء من المقرر؟";
    }

    private function getQuestionAnswers(int $subId, int $qIdx, int $qn): array
    {
        return [
            ['text' => 'الخيار الأول: إجابة نموذجية دقيقة وفق المنهاج', 'is_correct' => true, 'explanation' => 'إجابة صحيحة لأن القانون ينطبق تماماً.'],
            ['text' => 'الخيار الثاني: إجابة خاطئة تفتقد للتحليل', 'is_correct' => false, 'explanation' => 'غير صحيحة بسبب إهمال الشروط الابتدائية.'],
            ['text' => 'الخيار الثالث: اقتراح غير دقيق', 'is_correct' => false, 'explanation' => 'غير دقيقة علمياً.'],
        ];
    }

    private function getDeckTitle(int $subId, int $idx): String
    {
        $titles = ['القوانين والمفاهيم المفتاحية', 'التعاريف والمصطلحات الرسمية', 'أفكار البكالوريات السابقة', 'أهم المخططات والمنحنيات البيانية', 'المعادلات والحسابات النموذجية', 'المستهدفات والتركيبات الأساسية'];
        return $titles[($idx - 1) % count($titles)];
    }

    private function getFlashcardQuestion(int $subId, int $d, int $fc): String
    {
        return "ما هو التعريف الدقيق والقانون المباشر للمفهوم رقم {$d}.{$fc}؟";
    }

    private function getFlashcardAnswer(int $subId, int $d, int $fc): String
    {
        return "هو المفهوم الأساسي المعلل بالمعادلة التالية مع احترام الوحدات الدولية.";
    }

    private function getRandomComment(): String
    {
        $comments = [
            'دورة ممتازة جداً وشرح في القمة، بارك الله فيكم!',
            'طريقة الشرح والتمارين النموذجية مكنتني من فهم النقاط الصعبة بسهولة.',
            'أستاذ رايع جداً شكراً جزيلاً على هذا الجهد المبذول.',
            'أفضل منصة لتحضير البكالوريا بمعدل ممتاز إن شاء الله.',
        ];
        return $comments[rand(0, count($comments) - 1)];
    }

    private function getRandomStudentComment(): String
    {
        $comments = [
            'شكراً أستاذنا القدير على النصائح القيمّة!',
            'إن شاء الله سنعمل بالنصيحة ونحقق أفضل نتائج في البكالوريا.',
            'جزاكم الله كل خير على المتابعة والاهتمام بالتلاميذ.',
            'تمت مراجعة المنشور، بالتوفيق لجميع زملائي!',
        ];
        return $comments[rand(0, count($comments) - 1)];
    }
}
