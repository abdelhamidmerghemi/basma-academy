<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database with rich, production-grade Algerian Baccalaureate data.
     */
    public function run(): void
    {
        $this->command?->info("🚀 Starting Basma Academy Rich Master Seeder...");

        Schema::disableForeignKeyConstraints();

        // TRUNCATE ALL TABLES
        DB::table('forum_reply_likes')->truncate();
        DB::table('forum_post_likes')->truncate();
        DB::table('forum_post_views')->truncate();
        DB::table('forum_replies')->truncate();
        DB::table('forum_posts')->truncate();
        DB::table('device_tokens')->truncate();
        DB::table('user_notifications')->truncate();
        DB::table('notifications')->truncate();
        DB::table('course_reviews')->truncate();
        DB::table('banners')->truncate();
        DB::table('announcement_views')->truncate();
        DB::table('announcement_saves')->truncate();
        DB::table('announcement_likes')->truncate();
        DB::table('announcement_comments')->truncate();
        DB::table('announcements')->truncate();
        DB::table('quiz_attempts')->truncate();
        DB::table('quiz_answers')->truncate();
        DB::table('quiz_questions')->truncate();
        DB::table('quizzes')->truncate();
        DB::table('user_flashcard_progress')->truncate();
        DB::table('flashcards')->truncate();
        DB::table('flashcard_decks')->truncate();
        DB::table('ai_messages')->truncate();
        DB::table('ai_conversations')->truncate();
        DB::table('lesson_progress')->truncate();
        DB::table('course_enrollments')->truncate();
        DB::table('payments')->truncate();
        DB::table('order_items')->truncate();
        DB::table('orders')->truncate();
        DB::table('products')->truncate();
        DB::table('lessons')->truncate();
        DB::table('media')->truncate();
        DB::table('course_sections')->truncate();
        DB::table('course_streams')->truncate();
        DB::table('courses')->truncate();
        DB::table('stream_subjects')->truncate();
        DB::table('subjects')->truncate();
        DB::table('admin_profiles')->truncate();
        DB::table('teacher_profiles')->truncate();
        DB::table('student_profiles')->truncate();
        DB::table('user_roles')->truncate();
        DB::table('users')->truncate();
        DB::table('otps')->truncate();
        DB::table('settings')->truncate();

        Schema::enableForeignKeyConstraints();

        $defaultPassword = Hash::make('password');
        $now = now();

        $this->command?->info("📚 Seeding Academic Structure & Streams...");

        $academicYearId = DB::table('academic_years')->where('is_active', true)->value('id');
        if (!$academicYearId) {
            $academicYearId = DB::table('academic_years')->insertGetId([
                'name' => '2026 - 2027',
                'is_active' => true,
                'starts_at' => '2026-09-01',
                'ends_at' => '2027-06-30',
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        $streams = [
            ['id' => 1, 'code' => 'BAC_Sciences', 'name_ar' => 'علوم تجريبية', 'name_fr' => 'Sciences Expérimentales', 'name_en' => 'Experimental Sciences', 'icon_name' => 'science_rounded', 'color_hex' => '#10B981', 'display_order' => 1],
            ['id' => 2, 'code' => 'BAC_Maths', 'name_ar' => 'رياضيات', 'name_fr' => 'Mathématiques', 'name_en' => 'Mathematics', 'icon_name' => 'calculate_rounded', 'color_hex' => '#2563EB', 'display_order' => 2],
            ['id' => 3, 'code' => 'BAC_Technique', 'name_ar' => 'تقني رياضي', 'name_fr' => 'Technique Mathématique', 'name_en' => 'Technical Mathematics', 'icon_name' => 'settings_suggest_rounded', 'color_hex' => '#F59E0B', 'display_order' => 3],
            ['id' => 4, 'code' => 'BAC_Lettres', 'name_ar' => 'آداب وفلسفة', 'name_fr' => 'Lettres et Philosophie', 'name_en' => 'Literature & Philosophy', 'icon_name' => 'history_edu_rounded', 'color_hex' => '#EC4899', 'display_order' => 4],
            ['id' => 5, 'code' => 'BAC_Languages', 'name_ar' => 'لغات أجنبية', 'name_fr' => 'Langues Étrangères', 'name_en' => 'Foreign Languages', 'icon_name' => 'translate_rounded', 'color_hex' => '#8B5CF6', 'display_order' => 5],
            ['id' => 6, 'code' => 'BAC_Gestion', 'name_ar' => 'تسيير واقتصاد', 'name_fr' => 'Gestion et Économie', 'name_en' => 'Management & Economy', 'icon_name' => 'analytics_rounded', 'color_hex' => '#059669', 'display_order' => 6],
        ];

        foreach ($streams as $s) {
            DB::table('streams')->updateOrInsert(['id' => $s['id']], array_merge($s, ['created_at' => $now, 'updated_at' => $now]));
        }

        $subjectsData = [
            ['id' => 1, 'name_ar' => 'العلوم الفيزيائية', 'name_fr' => 'Sciences Physiques', 'name_en' => 'Physics & Chemistry', 'icon_name' => 'electric_bolt_rounded', 'color_hex' => '#2563EB'],
            ['id' => 2, 'name_ar' => 'الرياضيات', 'name_fr' => 'Mathématiques', 'name_en' => 'Mathematics', 'icon_name' => 'calculate_rounded', 'color_hex' => '#4F46E5'],
            ['id' => 3, 'name_ar' => 'علوم الطبيعة والحياة', 'name_fr' => 'Sciences de la Nature et de la Vie', 'name_en' => 'Natural & Life Sciences', 'icon_name' => 'eco_rounded', 'color_hex' => '#10B981'],
            ['id' => 4, 'name_ar' => 'الفلسفة', 'name_fr' => 'Philosophie', 'name_en' => 'Philosophy', 'icon_name' => 'psychology_rounded', 'color_hex' => '#EC4899'],
            ['id' => 5, 'name_ar' => 'اللغة العربية وآدابها', 'name_fr' => 'Langue et Littérature Arabes', 'name_en' => 'Arabic Language & Literature', 'icon_name' => 'menu_book_rounded', 'color_hex' => '#D97706'],
            ['id' => 6, 'name_ar' => 'التاريخ والجغرافيا', 'name_fr' => 'Histoire et Géographie', 'name_en' => 'History & Geography', 'icon_name' => 'public_rounded', 'color_hex' => '#8B5CF6'],
            ['id' => 7, 'name_ar' => 'اللغة الإنجليزية', 'name_fr' => 'Langue Anglaise', 'name_en' => 'English Language', 'icon_name' => 'language_rounded', 'color_hex' => '#06B6D4'],
            ['id' => 8, 'name_ar' => 'اللغة الفرنسية', 'name_fr' => 'Langue Française', 'name_en' => 'French Language', 'icon_name' => 'spellcheck_rounded', 'color_hex' => '#3B82F6'],
            ['id' => 9, 'name_ar' => 'العلوم الإسلامية', 'name_fr' => 'Sciences Islamiques', 'name_en' => 'Islamic Sciences', 'icon_name' => 'auto_stories_rounded', 'color_hex' => '#059669'],
            ['id' => 10, 'name_ar' => 'التسيير المحاسبي والمالي', 'name_fr' => 'Comptabilité et Finance', 'name_en' => 'Accounting & Finance', 'icon_name' => 'account_balance_rounded', 'color_hex' => '#F59E0B'],
        ];

        foreach ($subjectsData as $sub) {
            DB::table('subjects')->updateOrInsert(['id' => $sub['id']], array_merge($sub, ['created_at' => $now, 'updated_at' => $now]));
        }

        // Stream subject coefficients
        $streamSubjectMappings = [
            // Sciences Expérimentales (Stream 1)
            ['stream_id' => 1, 'subject_id' => 1, 'coefficient' => 6, 'display_order' => 1],
            ['stream_id' => 1, 'subject_id' => 2, 'coefficient' => 5, 'display_order' => 2],
            ['stream_id' => 1, 'subject_id' => 3, 'coefficient' => 6, 'display_order' => 3],
            ['stream_id' => 1, 'subject_id' => 4, 'coefficient' => 2, 'display_order' => 4],
            ['stream_id' => 1, 'subject_id' => 5, 'coefficient' => 3, 'display_order' => 5],
            ['stream_id' => 1, 'subject_id' => 6, 'coefficient' => 2, 'display_order' => 6],
            // Mathématiques (Stream 2)
            ['stream_id' => 2, 'subject_id' => 2, 'coefficient' => 7, 'display_order' => 1],
            ['stream_id' => 2, 'subject_id' => 1, 'coefficient' => 6, 'display_order' => 2],
            ['stream_id' => 2, 'subject_id' => 3, 'coefficient' => 2, 'display_order' => 3],
            // Technique Math (Stream 3)
            ['stream_id' => 3, 'subject_id' => 2, 'coefficient' => 6, 'display_order' => 1],
            ['stream_id' => 3, 'subject_id' => 1, 'coefficient' => 6, 'display_order' => 2],
            // Lettres et Philo (Stream 4)
            ['stream_id' => 4, 'subject_id' => 4, 'coefficient' => 6, 'display_order' => 1],
            ['stream_id' => 4, 'subject_id' => 5, 'coefficient' => 6, 'display_order' => 2],
            ['stream_id' => 4, 'subject_id' => 6, 'coefficient' => 4, 'display_order' => 3],
            // Gestion et Economie (Stream 6)
            ['stream_id' => 6, 'subject_id' => 10, 'coefficient' => 6, 'display_order' => 1],
            ['stream_id' => 6, 'subject_id' => 2, 'coefficient' => 5, 'display_order' => 2],
        ];

        foreach ($streamSubjectMappings as $map) {
            DB::table('stream_subjects')->updateOrInsert(
                ['stream_id' => $map['stream_id'], 'subject_id' => $map['subject_id']],
                array_merge($map, ['created_at' => $now, 'updated_at' => $now])
            );
        }

        $studentRoleId = DB::table('roles')->where('name', 'student')->value('id') ?? 1;
        $teacherRoleId = DB::table('roles')->where('name', 'teacher')->value('id') ?? 2;
        $adminRoleId = DB::table('roles')->where('name', 'admin')->value('id') ?? 3;

        // Seed dedicated Admin Account
        $adminUserId = DB::table('users')->insertGetId([
            'name' => 'مدير المنصة العام',
            'email' => 'admin@basma.academy',
            'phone' => '0555000000',
            'password' => $defaultPassword,
            'email_verified_at' => $now,
            'phone_verified_at' => $now,
            'created_at' => $now,
            'updated_at' => $now,
        ]);

        DB::table('user_roles')->insert([
            'user_id' => $adminUserId,
            'role_id' => $adminRoleId,
        ]);

        DB::table('admin_profiles')->insert([
            'user_id' => $adminUserId,
            'title' => 'المدير العام للمنصة',
            'department' => 'الإدارة العامة والعمليات',
            'avatar_path' => 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
            'is_super_admin' => true,
            'created_at' => $now,
            'updated_at' => $now,
        ]);

        $this->command?->info("👨‍🏫 Seeding Realistic Algerian Teachers...");

        $teachers = [
            [
                'name' => 'أ. عبد القادر بن عيسى',
                'email' => 'teacher@basma.academy',
                'phone' => '0661112233',
                'avatar' => 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 1, // Physics
                'headline' => 'أستاذ خبير في مادة العلوم الفيزيائية للبكالوريا | خبرة 15 سنة في تصحيح البكالوريا',
                'bio' => 'أستاذ تعليم ثانوي متميز بولاية الجزائر العاصمة، مؤلف سلسلة المتميز في الفيزياء للبكالوريا. أشرف على تدريب وتفوق آلاف الطلاب الحاصلين على تقدير ممتاز.',
                'rating' => 4.95,
                'reviews_count' => 142,
            ],
            [
                'name' => 'أ. مصطفى بوعلام',
                'email' => 'math@basma.academy',
                'phone' => '0662223344',
                'avatar' => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 2, // Math
                'headline' => 'مهندس دولة وأستاذ مادة الرياضيات للبكالوريا | صاحب سلسلة المتفوق',
                'bio' => 'متخصص في تبسيط المفاهيم الرياضية المعقدة، دراسة الدوال، المتتاليات، والاحتمالات بطرق منهجية سريعة ومضمونة لنيل العلامة الكاملة 20/20.',
                'rating' => 4.98,
                'reviews_count' => 188,
            ],
            [
                'name' => 'د. أمينة زروقي',
                'email' => 'science@basma.academy',
                'phone' => '0663334455',
                'avatar' => 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 3, // Science
                'headline' => 'دكتورة في البيولوجيا وأستاذة علوم الطبيعة والحياة للطور النهائي',
                'bio' => 'خبيرة في المنهجية الجديدة لعلوم الطبيعة والحياة للبكالوريا. تبسيط الاستدلال العلمي، المسعى العلمي، وآليات تركيب البروتين والنشاط الإنزيمي والمناعة.',
                'rating' => 4.92,
                'reviews_count' => 115,
            ],
            [
                'name' => 'أ. سفيان قاسمي',
                'email' => 'philosophy@basma.academy',
                'phone' => '0664445566',
                'avatar' => 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 4, // Philosophy
                'headline' => 'أستاذ الفلسفة والمنهجية للبكالوريا | مدرب المقالات الفلسفية المضمونة',
                'bio' => 'مؤطر تربوي، مدرب على منهجية المقال المقارن، الجدلي، والاستقصاء بالوضع لجميع الشعب الأدبية والعلمية.',
                'rating' => 4.88,
                'reviews_count' => 96,
            ],
            [
                'name' => 'أ. إلياس بلحاج',
                'email' => 'history@basma.academy',
                'phone' => '0665556677',
                'avatar' => 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 6, // History Geo
                'headline' => 'أستاذ التاريخ والجغرافيا | صاحب الخرائط الذهنية ومخططات الحفظ السريع',
                'bio' => 'ابتكرت أسلوب الخرائط الذهنية التفاعلية الذي يتيح لطلاب البكالوريا حفظ التواريخ والشخصيات والمصطلحات في أقل من 7 أيام.',
                'rating' => 4.90,
                'reviews_count' => 84,
            ],
            [
                'name' => 'أ. ليلى منصوري',
                'email' => 'english@basma.academy',
                'phone' => '0666667788',
                'avatar' => 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 7, // English
                'headline' => 'أستاذة اللغة الإنجليزية للبكالوريا لجميع الشعب العلمية والأدبية',
                'bio' => 'متحصلة على شهادة تدريس اللغة الإنجليزية المعتمدة دولياً. دورات مركزة في قواعد اللغة والنصوص وقوالب التعبير الكتابي للبكالوريا.',
                'rating' => 4.96,
                'reviews_count' => 130,
            ],
            [
                'name' => 'أ. كريم سعيدي',
                'email' => 'gestion@basma.academy',
                'phone' => '0667778899',
                'avatar' => 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 10, // Accounting / Gestion
                'headline' => 'خبير المحاسبة والمالية وأستاذ شعبة تسيير واقتصاد',
                'bio' => 'مدرب مالي ومحاسب معتمد، تبسيط أعمال نهاية السنة، الميزانية الوظيفية، واختيار المشاريع الاستثمارية للبكالوريا.',
                'rating' => 4.85,
                'reviews_count' => 72,
            ],
            [
                'name' => 'أ. عثمان الشريف',
                'email' => 'islamic@basma.academy',
                'phone' => '0668889900',
                'avatar' => 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=80',
                'subject_id' => 9, // Islamic
                'headline' => 'أستاذ العلوم الإسلامية ومجاز في القراءات العشر',
                'bio' => 'شرح وتبسيط دروس العلوم الإسلامية وفق التدرج الوزاري الجديد مع جداول المقارنة وحل جميع أسئلة الفهم في البكالوريات السابقة.',
                'rating' => 4.99,
                'reviews_count' => 160,
            ],
        ];

        $teacherUserIds = [];
        $teacherProfileIds = [];

        foreach ($teachers as $idx => $t) {
            $uId = DB::table('users')->insertGetId([
                'name' => $t['name'],
                'email' => $t['email'],
                'phone' => $t['phone'],
                'password' => $defaultPassword,
                'email_verified_at' => $now,
                'phone_verified_at' => $now,
                'created_at' => $now->copy()->subMonths(6),
                'updated_at' => $now,
            ]);

            DB::table('user_roles')->insert([
                'user_id' => $uId,
                'role_id' => $teacherRoleId,
            ]);

            $pId = DB::table('teacher_profiles')->insertGetId([
                'user_id' => $uId,
                'headline' => $t['headline'],
                'bio' => $t['bio'],
                'avatar_path' => $t['avatar'],
                'rating_cache' => $t['rating'],
                'reviews_count' => $t['reviews_count'],
                'created_at' => $now->copy()->subMonths(6),
                'updated_at' => $now,
            ]);

            $teacherUserIds[$idx] = $uId;
            $teacherProfileIds[$idx] = $pId;
        }

        $this->command?->info("🎓 Seeding Diverse Algerian BAC Students...");

        $students = [
            ['name' => 'عبد الحميد مرابط', 'email' => 'abdelhamid@gmail.com', 'phone' => '0550112233', 'avatar' => 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية المقراني - بن عكنون', 'wilaya' => 16],
            ['name' => 'كريم بن ناصر', 'email' => 'karim.bac@gmail.com', 'phone' => '0550223344', 'avatar' => 'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=500&auto=format&fit=crop&q=80', 'stream_id' => 2, 'school' => 'ثانوية يوغرطة - قسنطينة', 'wilaya' => 25],
            ['name' => 'مريم بلقاسم', 'email' => 'meriem.bac@gmail.com', 'phone' => '0550334455', 'avatar' => 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية باستور - وهران', 'wilaya' => 31],
            ['name' => 'ياسين حداد', 'email' => 'yacine.tech@gmail.com', 'phone' => '0550445566', 'avatar' => 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500&auto=format&fit=crop&q=80', 'stream_id' => 3, 'school' => 'ثانوية مالك بن نبي - سطيف', 'wilaya' => 19],
            ['name' => 'سارة لعموري', 'email' => 'sarah.lit@gmail.com', 'phone' => '0550556677', 'avatar' => 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500&auto=format&fit=crop&q=80', 'stream_id' => 4, 'school' => 'ثانوية مصطفى بن بولعيد - باتنة', 'wilaya' => 5],
            ['name' => 'أمين منصوري', 'email' => 'amine.eco@gmail.com', 'phone' => '0550667788', 'avatar' => 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80', 'stream_id' => 6, 'school' => 'ثانوية مليحة حميدو - تلمسان', 'wilaya' => 13],
            ['name' => 'نور الهدى بوزيد', 'email' => 'nour.lang@gmail.com', 'phone' => '0550778899', 'avatar' => 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80', 'stream_id' => 5, 'school' => 'ثانوية القديس أوغسطين - عنابة', 'wilaya' => 23],
            ['name' => 'وليد بن سالم', 'email' => 'walid.bac@gmail.com', 'phone' => '0550889900', 'avatar' => 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية ابن رشد - البليدة', 'wilaya' => 9],
            ['name' => 'أسماء زواوي', 'email' => 'asma.math@gmail.com', 'phone' => '0550990011', 'avatar' => 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80', 'stream_id' => 2, 'school' => 'ثانوية الحمادية - بجاية', 'wilaya' => 6],
            ['name' => 'شفيق آيت علي', 'email' => 'chafik.sci@gmail.com', 'phone' => '0550113355', 'avatar' => 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية فافاطمة نسومر - تيزي وزو', 'wilaya' => 15],
            ['name' => 'لينا دربال', 'email' => 'lina.lit@gmail.com', 'phone' => '0550224466', 'avatar' => 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80', 'stream_id' => 4, 'school' => 'ثانوية النجاح - سيدي بلعباس', 'wilaya' => 22],
            ['name' => 'بلال رحماني', 'email' => 'bilal.tech@gmail.com', 'phone' => '0550335577', 'avatar' => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80', 'stream_id' => 3, 'school' => 'ثانوية زروقي - مستغانم', 'wilaya' => 27],
            ['name' => 'هبة الله قرفي', 'email' => 'hiba.bac@gmail.com', 'phone' => '0550446688', 'avatar' => 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية العربي بن مهيدي - بسكرة', 'wilaya' => 7],
            ['name' => 'حمزة بوعلام', 'email' => 'hamza.math@gmail.com', 'phone' => '0550557799', 'avatar' => 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=500&auto=format&fit=crop&q=80', 'stream_id' => 2, 'school' => 'ثانوية عبد الحميد بن باديس - المدية', 'wilaya' => 26],
            ['name' => 'فاطمة الزهراء عيساني', 'email' => 'fatima.sci@gmail.com', 'phone' => '0550668800', 'avatar' => 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية العقيد لطفي - الشلف', 'wilaya' => 2],
            ['name' => 'رضا مزيان', 'email' => 'reda.tech@gmail.com', 'phone' => '0550779911', 'avatar' => 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=500&auto=format&fit=crop&q=80', 'stream_id' => 3, 'school' => 'ثانوية هواري بومدين - الجلفة', 'wilaya' => 17],
            ['name' => 'خديجة بوكثير', 'email' => 'khadidja.eco@gmail.com', 'phone' => '0550880022', 'avatar' => 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80', 'stream_id' => 6, 'school' => 'ثانوية زيغود يوسف - سكيكدة', 'wilaya' => 21],
            ['name' => 'طارق بلحاج', 'email' => 'tarek.bac@gmail.com', 'phone' => '0550991133', 'avatar' => 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية الإدريسي - ورقلة', 'wilaya' => 30],
            ['name' => 'سندس ميباركي', 'email' => 'soundous.lang@gmail.com', 'phone' => '0550114466', 'avatar' => 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80', 'stream_id' => 5, 'school' => 'ثانوية الشيخ بيوض - غرداية', 'wilaya' => 47],
            ['name' => 'يوسف قدور', 'email' => 'youssef.sci@gmail.com', 'phone' => '0550225577', 'avatar' => 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية الأمير عبد القادر - جيجل', 'wilaya' => 18],
            ['name' => 'إيناس شريف', 'email' => 'ines.math@gmail.com', 'phone' => '0550336688', 'avatar' => 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80', 'stream_id' => 2, 'school' => 'ثانوية فرحات عباس - برج بوعريريج', 'wilaya' => 34],
            ['name' => 'إلياس عماري', 'email' => 'ilyes.lit@gmail.com', 'phone' => '0550447799', 'avatar' => 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80', 'stream_id' => 4, 'school' => 'ثانوية ابن رشد - قالمة', 'wilaya' => 24],
            ['name' => 'آية بن عيسى', 'email' => 'aya.sci@gmail.com', 'phone' => '0550558800', 'avatar' => 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500&auto=format&fit=crop&q=80', 'stream_id' => 1, 'school' => 'ثانوية ابن الهيثم - تيارت', 'wilaya' => 14],
            ['name' => 'إسلام زايدي', 'email' => 'islam.tech@gmail.com', 'phone' => '0550669911', 'avatar' => 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=80', 'stream_id' => 3, 'school' => 'ثانوية الشيخ العربي التبسي - تبسة', 'wilaya' => 12],
        ];

        $studentUserIds = [];

        foreach ($students as $st) {
            $uId = DB::table('users')->insertGetId([
                'name' => $st['name'],
                'email' => $st['email'],
                'phone' => $st['phone'],
                'password' => $defaultPassword,
                'email_verified_at' => $now,
                'phone_verified_at' => $now,
                'created_at' => $now->copy()->subMonths(5),
                'updated_at' => $now,
            ]);

            DB::table('user_roles')->insert([
                'user_id' => $uId,
                'role_id' => $studentRoleId,
            ]);

            DB::table('student_profiles')->insert([
                'user_id' => $uId,
                'academic_year_id' => $academicYearId,
                'stream_id' => $st['stream_id'],
                'school_name' => $st['school'],
                'wilaya_code' => $st['wilaya'],
                'avatar_path' => $st['avatar'],
                'created_at' => $now->copy()->subMonths(5),
                'updated_at' => $now,
            ]);

            $studentUserIds[] = $uId;
        }

        $this->command?->info("🎥 Seeding Real BAC Courses, Curriculum & Video Lessons...");

        $courseCatalog = [
            [
                'teacher_idx' => 0, // Physics
                'subject_id' => 1,
                'stream_ids' => [1, 2, 3],
                'title' => 'دورة الامتياز في المتابعة الزمنية والأكسدة والإرجاع',
                'description' => 'دورة شاملة ومفصلة تتناول الوحدة الأولى في العلوم الفيزيائية للبكالوريا: جدول التقدم، زمن نصف التفاعل، السرعات الحجمية، مع حل 15 تمريناً نموذجياً وبكالوريات سابقة.',
                'thumbnail' => 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800&auto=format&fit=crop&q=80',
                'price' => 3500.00,
                'sale_price' => 2800.00,
                'sections' => [
                    [
                        'title' => 'المحور الأول: المفاهيم الأساسية والمكتسبات القبلية',
                        'lessons' => [
                            ['title' => 'تذكير بالمفاهيم: الثنائيات المؤكسدة والمرجعة وطرق المتابعة الزمنية', 'duration' => 1840, 'preview' => true],
                            ['title' => 'المتابعة الزمنية عن طريق قياس الناقلية الكهربائية والضغط', 'duration' => 2100, 'preview' => false],
                            ['title' => 'حساب السرعة الحجمية للتفاعل وسرعة الاختفاء والتشكل', 'duration' => 1950, 'preview' => false],
                        ]
                    ],
                    [
                        'title' => 'المحور الثاني: تطبيقات نموذجية وتمارين البكالوريا',
                        'lessons' => [
                            ['title' => 'حل تمرين نموذجي شامل: تفاعل شوارد البيروكسوديكبريتات مع اليود', 'duration' => 2400, 'preview' => true],
                            ['title' => 'العوامل الحركية وتأثير درجة الحرارة وتركيز المتفاعلات', 'duration' => 1780, 'preview' => false],
                            ['title' => 'حل بكالوريا 2024 شعبة علوم تجريبية مع سلم التنقيط الوزاري', 'duration' => 3100, 'preview' => false],
                        ]
                    ]
                ]
            ],
            [
                'teacher_idx' => 0, // Physics
                'subject_id' => 1,
                'stream_ids' => [1, 2, 3],
                'title' => 'الظواهر الكهربائية: ثنائي القطب RC و RL والاهتزازات الكهربائية',
                'description' => 'الشرح الكامل للدارة RC (شحن وتفريغ مكثفة) والدارة RL (تطبيق وقطع تيار عن وشيعة) مع المعادلات التفاضلية وحلولها والتحليل البعدي لثابت الزمن.',
                'thumbnail' => 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&auto=format&fit=crop&q=80',
                'price' => 4000.00,
                'sale_price' => 3200.00,
                'sections' => [
                    [
                        'title' => 'المحور الأول: ثنائي القطب RC (المكثفة)',
                        'lessons' => [
                            ['title' => 'شحن وتفريغ المكثفة: المعادلات التفاضلية لـ uc(t) و q(t) و i(t)', 'duration' => 2250, 'preview' => true],
                            ['title' => 'التحليل البعدي لثابت الزمن تاو والطاقة المخزنة في المكثفة', 'duration' => 1650, 'preview' => false],
                        ]
                    ],
                    [
                        'title' => 'المحور الثاني: ثنائي القطب RL والتمارين المقترحة',
                        'lessons' => [
                            ['title' => 'الوشيعة: ظاهرة التحريض الذاتي ومعادلات ثنائي القطب RL', 'duration' => 2180, 'preview' => false],
                            ['title' => 'حل تمارين البكالوريا المميزة في الكهرباء مع التصحيح بالفيديو', 'duration' => 2800, 'preview' => false],
                        ]
                    ]
                ]
            ],
            [
                'teacher_idx' => 1, // Math
                'subject_id' => 2,
                'stream_ids' => [1, 2, 3],
                'title' => 'الدوال الأسية واللوغاريتمية: الدورة الاحترافية لاقتناص 20/20',
                'description' => 'دراسة شاملة وتفصيلية للدوال الأسية واللوغاريتمية النيبيرية: النهايات، المستقيمات المقاربة، المناقشة البيانية، الدوال المساعدة، ونقاط الانعطاف.',
                'thumbnail' => 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800&auto=format&fit=crop&q=80',
                'price' => 4500.00,
                'sale_price' => 3500.00,
                'sections' => [
                    [
                        'title' => 'المحور الأول: النهايات والمناقشة البيانية',
                        'lessons' => [
                            ['title' => 'إزالة حالات عدم التعيين والتزايد المقارن في الدالة الأسية', 'duration' => 2400, 'preview' => true],
                            ['title' => 'المناقشة البيانية بجميع أنواعها: الأفقية، المائلة، والدورانية', 'duration' => 2750, 'preview' => true],
                        ]
                    ],
                    [
                        'title' => 'المحور الثاني: دراسة مسائل البكالوريا الشاملة',
                        'lessons' => [
                            ['title' => 'مسألة شاملة 8 نقاط مع الدالة المساعدة وحساب المساحات والتكامل', 'duration' => 3400, 'preview' => false],
                            ['title' => 'الدوال الأصلية وحساب الحجوم الدورانية للمتفوقين', 'duration' => 2100, 'preview' => false],
                        ]
                    ]
                ]
            ],
            [
                'teacher_idx' => 2, // Natural Sciences
                'subject_id' => 3,
                'stream_ids' => [1, 2],
                'title' => 'آليات تركيب البروتين والنشاط الإنزيمي وفق المنهجية الجديدة',
                'description' => 'شرح دقيق وتفصيلي للاستنساخ، الترجمة، البنية الفراغية للبروتينات، والتأثيرات البيئية والتثبيط الإنزيمي مع تدريب عملي على صياغة النصوص العلمية.',
                'thumbnail' => 'https://images.unsplash.com/photo-1530497610245-94d3c16cda28?w=800&auto=format&fit=crop&q=80',
                'price' => 3800.00,
                'sale_price' => 2900.00,
                'sections' => [
                    [
                        'title' => 'المحور الأول: آليات الاستنساخ والترجمة ونضج ARNm',
                        'lessons' => [
                            ['title' => 'مراحل الاستنساخ الحيوي عند حقيقيات النوى ونضج الـ ARNm', 'duration' => 2100, 'preview' => true],
                            ['title' => 'تنشيط الأحماض الأمينية ومراحل الترجمة في الريبوزوم', 'duration' => 1950, 'preview' => false],
                        ]
                    ],
                    [
                        'title' => 'المحور الثاني: النشاط الإنزيمي والاستدلال العلمي',
                        'lessons' => [
                            ['title' => 'بنية الموقع الفعال والتكامل المحفز مع مادة التفاعل', 'duration' => 2200, 'preview' => false],
                            ['title' => 'كتابة النص العلمي النموذجي وفق شبكة التقويم الرسمية للبكالوريا', 'duration' => 2600, 'preview' => true],
                        ]
                    ]
                ]
            ],
            [
                'teacher_idx' => 3, // Philosophy
                'subject_id' => 4,
                'stream_ids' => [4, 5, 1, 2, 3, 6],
                'title' => 'دورة المنهجية الفلسفية والمقالات الجدلية المقترحة بقوة للبكالوريا',
                'description' => 'تعلم كيف تكتب مقالاً فلسفياً كاملاً ومحكماً (طريقة المقارنة، الجدل، الاستقصاء بالوضع) مع أقوال الفلاسفة والحجج والأمثلة الواقعية.',
                'thumbnail' => 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=800&auto=format&fit=crop&q=80',
                'price' => 2500.00,
                'sale_price' => 1900.00,
                'sections' => [
                    [
                        'title' => 'المحور الأول: منهجية كتابة المقال الفلسفي',
                        'lessons' => [
                            ['title' => 'كيفية صياغة مقدمة ممتازة وطرح الإشكال الفلسفي بدقة', 'duration' => 1700, 'preview' => true],
                            ['title' => 'خطوات الاستقصاء بالوضع من الدفاع عن الأطروحة إلى الخاتمة', 'duration' => 1900, 'preview' => false],
                        ]
                    ],
                    [
                        'title' => 'المحور الثاني: المقالات الكبرى للشعب العلمية والأدبية',
                        'lessons' => [
                            ['title' => 'مقالة البيولوجيا: هل يمكن تطبيق المنهج التجريبي على المادة الحية؟', 'duration' => 2500, 'preview' => false],
                            ['title' => 'مقالة أصل المفاهيم الرياضية: بين العقل والتجربة الحسية', 'duration' => 2400, 'preview' => true],
                        ]
                    ]
                ]
            ],
            [
                'teacher_idx' => 4, // History & Geo
                'subject_id' => 6,
                'stream_ids' => [1, 2, 3, 4, 5, 6],
                'title' => 'مخططات الحفظ الذكي للتاريخ والجغرافيا: الثورة التحريرية والحرب الباردة',
                'description' => 'احفظ جميع تواريخ، شخصيات، ومصطلحات البكالوريا عبر الخرائط الذهنية المبسطة وأسلوب الربط البصري الذي يرسخ المعلومات في الذاكرة طويلة المدى.',
                'thumbnail' => 'https://images.unsplash.com/photo-1447069387593-a5de0862481e?w=800&auto=format&fit=crop&q=80',
                'price' => 2200.00,
                'sale_price' => 1700.00,
                'sections' => [
                    [
                        'title' => 'المحور الأول: الحرب الباردة والعلاقات الدولية',
                        'lessons' => [
                            ['title' => 'معايير تشكل العالم واستراتيجيات المعسكرين الغربي والشرقي', 'duration' => 1650, 'preview' => true],
                            ['title' => 'الأزمات الدولية الكبرى: أزمة السويس، برلين، وكوبا', 'duration' => 1850, 'preview' => false],
                        ]
                    ],
                    [
                        'title' => 'المحور الثاني: الثورة التحريرية الجزائرية الكبرى',
                        'lessons' => [
                            ['title' => 'هجومات الشمال القسنطيني ومؤتمر الصومام 1956', 'duration' => 2100, 'preview' => false],
                            ['title' => 'مخططات ديغول والمفاوضات حتى الاستقلال 1962', 'duration' => 2300, 'preview' => true],
                        ]
                    ]
                ]
            ],
        ];

        $courseIds = [];
        $productIds = [];

        foreach ($courseCatalog as $c) {
            $teacherProfId = $teacherProfileIds[$c['teacher_idx']];

            $cId = DB::table('courses')->insertGetId([
                'academic_year_id' => $academicYearId,
                'subject_id' => $c['subject_id'],
                'teacher_profile_id' => $teacherProfId,
                'title' => $c['title'],
                'description' => $c['description'],
                'thumbnail_path' => $c['thumbnail'],
                'is_published' => true,
                'created_at' => $now->copy()->subMonths(6),
                'updated_at' => $now,
            ]);

            $courseIds[] = $cId;

            // Link to streams
            foreach ($c['stream_ids'] as $strId) {
                DB::table('course_streams')->insert([
                    'course_id' => $cId,
                    'stream_id' => $strId,
                ]);
            }

            // Create Product
            $prodId = DB::table('products')->insertGetId([
                'course_id' => $cId,
                'price_dzd' => $c['price'],
                'sale_price_dzd' => $c['sale_price'],
                'is_active' => true,
                'created_at' => $now->copy()->subMonths(6),
                'updated_at' => $now,
            ]);

            $productIds[$cId] = $prodId;

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

            // Create Sections and Lessons
            $lessonCounter = 0;
            foreach ($c['sections'] as $sOrder => $sec) {
                $secId = DB::table('course_sections')->insertGetId([
                    'course_id' => $cId,
                    'title' => $sec['title'],
                    'sort_order' => $sOrder + 1,
                    'created_at' => $now->copy()->subMonths(6),
                    'updated_at' => $now,
                ]);

                foreach ($sec['lessons'] as $lOrder => $les) {
                    $assignedVideoUrl = $videoSamples[$lessonCounter % count($videoSamples)];
                    $lessonCounter++;

                    $medId = DB::table('media')->insertGetId([
                        'provider' => 'local',
                        'type' => 'video',
                        'path' => $assignedVideoUrl,
                        'thumbnail_path' => $c['thumbnail'],
                        'duration_seconds' => $les['duration'],
                        'size_bytes' => $les['duration'] * 120000,
                        'created_at' => $now->copy()->subMonths(6),
                        'updated_at' => $now,
                    ]);

                    DB::table('lessons')->insert([
                        'course_id' => $cId,
                        'section_id' => $secId,
                        'media_id' => $medId,
                        'title' => $les['title'],
                        'sort_order' => $lOrder + 1,
                        'is_preview' => $les['preview'],
                        'summary_text' => 'ملخص شامل لأهم نقاط الدرس مع التمارين التفاعلية وملف PDF المرفق.',
                        'created_at' => $now->copy()->subMonths(6),
                        'updated_at' => $now,
                    ]);
                }
            }
        }

        $this->command?->info("💳 Seeding Real Payments, Orders & Month-by-Month Enrollments...");

        $paymentMethods = ['baridimob', 'ccp', 'card'];

        // Spread enrollments across the last 6 months (March -> August 2026)
        // so that the Teacher Revenue Chart and Student Growth Chart render real, realistic data curves!
        $allPossiblePairs = [];
        foreach ($studentUserIds as $sId) {
            foreach ($courseIds as $cId) {
                $allPossiblePairs[] = ['student_id' => $sId, 'course_id' => $cId];
            }
        }
        shuffle($allPossiblePairs);

        $monthlyEnrollmentPlan = [
            5 => 8,   // March: 8 subscriptions
            4 => 14,  // April: 14 subscriptions
            3 => 20,  // May: 20 subscriptions
            2 => 26,  // June: 26 subscriptions
            1 => 32,  // July: 32 subscriptions
            0 => 40,  // August: 40 subscriptions
        ];

        $pairIndex = 0;
        foreach ($monthlyEnrollmentPlan as $monthsAgo => $enrollmentCount) {
            $monthDate = $now->copy()->subMonths($monthsAgo)->startOfMonth()->addDays(rand(2, 25));

            for ($k = 0; $k < $enrollmentCount && $pairIndex < count($allPossiblePairs); $k++) {
                $pair = $allPossiblePairs[$pairIndex++];
                $studentId = $pair['student_id'];
                $targetCourseId = $pair['course_id'];
                $prodId = $productIds[$targetCourseId];
                $price = [2800, 3200, 3500, 2900, 1900, 1700][$k % 6];

                $orderNum = 'ORD-' . strtoupper(Str::random(8)) . '-' . $monthDate->format('Ym');

                $orderId = DB::table('orders')->insertGetId([
                    'user_id' => $studentId,
                    'order_number' => $orderNum,
                    'total_dzd' => $price,
                    'status' => 'completed',
                    'created_at' => $monthDate,
                    'updated_at' => $monthDate,
                ]);

                DB::table('order_items')->insert([
                    'order_id' => $orderId,
                    'product_id' => $prodId,
                    'price_dzd' => $price,
                    'created_at' => $monthDate,
                    'updated_at' => $monthDate,
                ]);

                DB::table('payments')->insert([
                    'order_id' => $orderId,
                    'payment_method' => $paymentMethods[$k % 3],
                    'transaction_reference' => 'TXN-' . strtoupper(Str::random(10)),
                    'receipt_image_path' => 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=500&auto=format&fit=crop&q=80',
                    'status' => 'approved',
                    'verified_by_user_id' => 1,
                    'created_at' => $monthDate,
                    'updated_at' => $monthDate,
                ]);

                DB::table('course_enrollments')->insert([
                    'user_id' => $studentId,
                    'course_id' => $targetCourseId,
                    'order_id' => $orderId,
                    'status' => 'active',
                    'access_until' => $now->copy()->addMonths(12),
                    'created_at' => $monthDate,
                    'updated_at' => $monthDate,
                ]);
            }
        }

        // Seed 3 Pending Payment Receipts for Admin Verification Desk
        $pendingSamples = [
            ['student_idx' => 0, 'course_idx' => 0, 'method' => 'baridimob', 'price' => 2800, 'ref' => 'RIP-982341-BM'],
            ['student_idx' => 1, 'course_idx' => 2, 'method' => 'ccp', 'price' => 3500, 'ref' => 'CCP-10492-ALG'],
            ['student_idx' => 2, 'course_idx' => 3, 'method' => 'baridimob', 'price' => 2900, 'ref' => 'BM-774102-ORN'],
        ];

        foreach ($pendingSamples as $pIdx => $ps) {
            $studentId = $studentUserIds[$ps['student_idx']];
            $courseId = $courseIds[$ps['course_idx']];
            $prodId = $productIds[$courseId];
            $pDate = $now->copy()->subHours($pIdx * 4 + 2);

            $orderNum = 'ORD-PENDING-' . strtoupper(Str::random(6));

            $orderId = DB::table('orders')->insertGetId([
                'user_id' => $studentId,
                'order_number' => $orderNum,
                'total_dzd' => $ps['price'],
                'status' => 'pending',
                'created_at' => $pDate,
                'updated_at' => $pDate,
            ]);

            DB::table('order_items')->insert([
                'order_id' => $orderId,
                'product_id' => $prodId,
                'price_dzd' => $ps['price'],
                'created_at' => $pDate,
                'updated_at' => $pDate,
            ]);

            DB::table('payments')->insert([
                'order_id' => $orderId,
                'payment_method' => $ps['method'],
                'transaction_reference' => $ps['ref'],
                'receipt_image_path' => 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=500&auto=format&fit=crop&q=80',
                'status' => 'submitted',
                'created_at' => $pDate,
                'updated_at' => $pDate,
            ]);
        }

        $this->command?->info("🎴 Seeding Rich Flashcard Decks & Spaced Repetition...");

        $flashcardDecksData = [
            [
                'subject_id' => 1, // Physics
                'title' => 'قوانين وثوابت المتابعة الزمنية والكهرباء',
                'description' => 'بطاقات مراجعة سريعة لجميع قوانين الأكسدة والإرجاع، ثوابت الزمن، وعلاقات الناقلية النوعية.',
                'cards' => [
                    ['q' => 'ما هو تعريف المؤكسد (Oxydant) في الكيمياء؟', 'a' => 'المؤكسد هو كل فرد كيميائي قادر على اكتساب إلكترون أو أكثر خلال تحول كيميائي.', 'exp' => 'الثنائية تكتب دائماً على الشكل (Ox/Red).'],
                    ['q' => 'ما هو تعريف زمن نصف التفاعل t(1/2)؟', 'a' => 'هو الزمن اللازم لبلوغ التفاعل نصف تقدمه النهائي، أي: x(t_1/2) = x_f / 2.', 'exp' => 'يسمح بتقدير المدة الزمنية المستغرقة لنهاية التفاعل.'],
                    ['q' => 'ما هو التحليل البعدي لثابت الزمن tau = R*C في الدارة RC؟', 'a' => '[tau] = [T] أي أن وحدته في الجملة الدولية هي الثانية (s).', 'exp' => 'يمكن إثباته من قانون أوم U=R*I وقانون الشحنة q=C*U.'],
                    ['q' => 'ما هي العبارة اللحظية للطاقة المخزنة في الوشيعة E_L؟', 'a' => 'E_L(t) = 1/2 * L * i(t)^2 (تقاس بالجول J).', 'exp' => 'تخزن الوشيعة طاقة كهرومغناطيسية عندما يجتازها تيار كهربائي.'],
                ]
            ],
            [
                'subject_id' => 2, // Math
                'title' => 'دستور التزايد المقارن والنهايات الشهيرة للدوال',
                'description' => 'بطاقات لحفظ جميع نهايات الدوال الأسية واللوغاريتمية الشهيرة لتجاوز حالات عدم التعيين.',
                'cards' => [
                    ['q' => 'ما هي نهاية lim (e^x / x) لما x يؤول إلى +infinity؟', 'a' => '+infinity (تزايد مقارن).', 'exp' => 'الدالة الأسية تتغلب على الدالة كثيرة الحدود عند اللانهاية.'],
                    ['q' => 'ما هي نهاية lim (x * ln(x)) لما x يؤول إلى 0 بقيم كبرى؟', 'a' => '0 (تزايد مقارن).', 'exp' => 'الدالة الخطية تتغلب على الدالة اللوغاريتمية بجوار الصفر.'],
                    ['q' => 'ما هو مشتق الدالة f(x) = ln(u(x))؟', 'a' => 'f\'(x) = u\'(x) / u(x).', 'exp' => 'يشترط أن تكون الدالة u(x) موجبة تماماً وقابلة للاشتقاق.'],
                ]
            ],
            [
                'subject_id' => 6, // History
                'title' => 'شخصيات وتواريخ الثورة التحريرية والحرب الباردة',
                'description' => 'بطاقات الحفظ السريع لأبرز تواريخ البكالوريا ومؤتمرات حركة عدم الانحياز.',
                'cards' => [
                    ['q' => 'ما هو تاريخ هجومات الشمال القسنطيني؟', 'a' => '20 أوت 1955 (بقيادة الشهيد زيغود يوسف).', 'exp' => 'فكت الحصار عن الأوراس وفتحت الباب لتدويل القضية الجزائرية في الأمم المتحدة.'],
                    ['q' => 'ما هو تاريخ مؤتمر الصومام وأهم نتائجه؟', 'a' => '20 أوت 1956 (تأسيس المجلس الوطني للثورة وإقرار أولوية العمل الداخلي على الخارجي).', 'exp' => 'عُقد في قرية إيفري بأوزلاقن بولاية بجاية.'],
                    ['q' => 'ما هو تاريخ إعلان مبدأ ترومان ومشروع مارشال؟', 'a' => 'مبدأ ترومان: 12 مارس 1947 | مشروع مارشال: 5 جوان 1947.', 'exp' => 'استراتيجيات أمريكية لاحتواء المد الشيوعي السوفياتي.'],
                ]
            ],
        ];

        foreach ($flashcardDecksData as $d) {
            $deckId = DB::table('flashcard_decks')->insertGetId([
                'subject_id' => $d['subject_id'],
                'title' => $d['title'],
                'description' => $d['description'],
                'created_at' => $now->copy()->subMonths(4),
                'updated_at' => $now,
            ]);

            foreach ($d['cards'] as $card) {
                $fId = DB::table('flashcards')->insertGetId([
                    'deck_id' => $deckId,
                    'question_text' => $card['q'],
                    'answer_text' => $card['a'],
                    'explanation_text' => $card['exp'],
                    'created_at' => $now->copy()->subMonths(4),
                    'updated_at' => $now,
                ]);

                // Seed user spaced repetition progress
                foreach (array_slice($studentUserIds, 0, 5) as $sUid) {
                    DB::table('user_flashcard_progress')->insert([
                        'user_id' => $sUid,
                        'flashcard_id' => $fId,
                        'easiness_factor' => 2.5,
                        'interval_days' => rand(1, 10),
                        'repetitions' => rand(1, 4),
                        'next_review_at' => $now->copy()->addDays(rand(1, 5)),
                        'last_reviewed_at' => $now->copy()->subDays(rand(1, 3)),
                        'created_at' => $now->copy()->subMonths(2),
                        'updated_at' => $now,
                    ]);
                }
            }
        }

        $this->command?->info("📝 Seeding BAC Evaluation Quizzes & Student Attempts...");

        $quizData = [
            [
                'title' => 'اختبار تقييمي في المتابعة الزمنية للأكسدة والإرجاع',
                'time_limit' => 20,
                'subject_id' => 1,
                'questions' => [
                    [
                        'text' => 'خلال تفاعل أكسدة-إرجاعي، يتميز المؤكسد بأنه:',
                        'points' => 2,
                        'answers' => [
                            ['text' => 'يكتسب إلكترونات ويحدث له إرجاع', 'correct' => true, 'exp' => 'صحيح، المؤكسد يكسب إلكترونات وتحدث له عملية الإرجاع.'],
                            ['text' => 'يفقد إلكترونات ويحدث له أكسدة', 'correct' => false, 'exp' => 'خطأ، هذا تعريف المرجع.'],
                            ['text' => 'لا يتبادل أي إلكترونات', 'correct' => false, 'exp' => 'خطأ، التفاعل الأكسدة-إرجاعي مبني على انتقال الإلكترونات.'],
                        ]
                    ],
                    [
                        'text' => 'عند زمن نصف التفاعل t(1/2)، تكون قيمة التقدم x(t) مساوية لـ:',
                        'points' => 2,
                        'answers' => [
                            ['text' => 'x_final / 2', 'correct' => true, 'exp' => 'صحيح وفق التعريف الرسمي لزمن نصف التفاعل.'],
                            ['text' => 'x_max * 2', 'correct' => false, 'exp' => 'خطأ.'],
                            ['text' => '0', 'correct' => false, 'exp' => 'خطأ.'],
                        ]
                    ]
                ]
            ],
            [
                'title' => 'اختبار التزايد المقارن ودراسة الدوال الأسية',
                'time_limit' => 25,
                'subject_id' => 2,
                'questions' => [
                    [
                        'text' => 'نهاية lim (x^2 * e^(-x)) لما x يؤول إلى +infinity تساوي:',
                        'points' => 2,
                        'answers' => [
                            ['text' => '0', 'correct' => true, 'exp' => 'صحيح بالتزايد المقارن لأن الدالة الأسية في المقام تؤول إلى +لانهاية أسرع.'],
                            ['text' => '+infinity', 'correct' => false, 'exp' => 'خطأ.'],
                            ['text' => '1', 'correct' => false, 'exp' => 'خطأ.'],
                        ]
                    ]
                ]
            ]
        ];

        foreach ($quizData as $qz) {
            $quizId = DB::table('quizzes')->insertGetId([
                'title' => $qz['title'],
                'time_limit_minutes' => $qz['time_limit'],
                'created_at' => $now->copy()->subMonths(3),
                'updated_at' => $now,
            ]);

            foreach ($qz['questions'] as $qOrder => $q) {
                $questId = DB::table('quiz_questions')->insertGetId([
                    'quiz_id' => $quizId,
                    'question_text' => $q['text'],
                    'points' => $q['points'],
                    'sort_order' => $qOrder + 1,
                    'created_at' => $now->copy()->subMonths(3),
                    'updated_at' => $now,
                ]);

                foreach ($q['answers'] as $ans) {
                    DB::table('quiz_answers')->insert([
                        'question_id' => $questId,
                        'answer_text' => $ans['text'],
                        'is_correct' => $ans['correct'],
                        'explanation_text' => $ans['exp'],
                        'created_at' => $now->copy()->subMonths(3),
                        'updated_at' => $now,
                    ]);
                }
            }

            // Seed student attempts
            foreach (array_slice($studentUserIds, 0, 6) as $sUid) {
                DB::table('quiz_attempts')->insert([
                    'user_id' => $sUid,
                    'quiz_id' => $quizId,
                    'score' => rand(15, 20),
                    'passed' => true,
                    'started_at' => $now->copy()->subDays(rand(5, 30)),
                    'completed_at' => $now->copy()->subDays(rand(5, 30))->addMinutes(rand(10, 18)),
                    'created_at' => $now->copy()->subDays(rand(5, 30)),
                    'updated_at' => $now,
                ]);
            }
        }

        $this->command?->info("📢 Seeding Teacher Announcements & Student Interactions...");

        $announcementsData = [
            [
                'teacher_idx' => 0, // Physics
                'content' => '🔴 تنبيه هام لجميع طلاب البكالوريا الأعزاء: سنعقد حصة مباشرة (Live Stream) يوم الجمعة على الساعة 18:00 لحل مسألة الميكانيك المقترحة بكالوريا 2025 مع الإجابة عن جميع أسئلتكم. الحضور إجباري للاستفادة القصوى!',
                'image' => 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=80',
                'comments' => [
                    ['user_idx' => 0, 'text' => 'شكراً جزيلاً أستاذنا الفاضل، هل سيتم تسجيل الحصة ونشرها للذين لا يسعفهم التوقيت؟'],
                    ['user_idx' => 1, 'text' => 'في الموعد إن شاء الله أستاذ، بارك الله فيك وجزاك كل خير!'],
                    ['user_idx' => 2, 'text' => 'أستاذ من فضلك هل يمكن التركيز على فكرة حركة الكواكب والأقمار الاصطناعية؟'],
                ]
            ],
            [
                'teacher_idx' => 0, // Physics
                'content' => '📚 تم رفع ملخص الوحدة الثانية (الظواهر الكهربائية RC و RL) بصيغة PDF عالية الدقة في قسم المرفقات. يحتوي على جميع القوانين والملاحظات المنهجية التي تضمن لكم النقاط كاملة في الامتحان.',
                'image' => 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&auto=format&fit=crop&q=80',
                'comments' => [
                    ['user_idx' => 3, 'text' => 'تم التحميل أستاذ، ملخص رائع جداً وشامل لأدق التفاصيل!'],
                    ['user_idx' => 4, 'text' => 'شكراً أستاذ عبد القادر، بفضلك أصبحت الفيزياء مادتي المفضلة!'],
                ]
            ],
            [
                'teacher_idx' => 1, // Math
                'content' => '💡 نصيحة ذهبية في مادة الرياضيات: عند دراسة الدالة الأسية، لا تتسرع في حساب النهايات قبل تبسيط العبارة وإخراج العامل المشترك لتفادي حالات عدم التعيين المعقدة. بالتوفيق لأبطال البكالوريا!',
                'image' => null,
                'comments' => [
                    ['user_idx' => 5, 'text' => 'نصيحة في وقتها أستاذ مصطفى، شكراً جزيلاً لك.'],
                    ['user_idx' => 0, 'text' => 'أستاذ هل المناقشة الدورانية مبرمجة على شعبة العلوم التجريبية أيضاً؟'],
                ]
            ],
        ];

        foreach ($announcementsData as $anc) {
            $tUserId = $teacherUserIds[$anc['teacher_idx']];

            $ancId = DB::table('announcements')->insertGetId([
                'user_id' => $tUserId,
                'content' => $anc['content'],
                'image_path' => $anc['image'],
                'created_at' => $now->copy()->subDays(rand(2, 20)),
                'updated_at' => $now,
            ]);

            // Add student comments
            foreach ($anc['comments'] as $cmt) {
                $cUserId = $studentUserIds[$cmt['user_idx'] % count($studentUserIds)];
                DB::table('announcement_comments')->insert([
                    'announcement_id' => $ancId,
                    'user_id' => $cUserId,
                    'content' => $cmt['text'],
                    'created_at' => $now->copy()->subDays(rand(1, 15)),
                    'updated_at' => $now,
                ]);
            }

            // Add likes, views and saves
            foreach (array_slice($studentUserIds, 0, 8) as $sUid) {
                DB::table('announcement_likes')->insertOrIgnore([
                    'announcement_id' => $ancId,
                    'user_id' => $sUid,
                    'created_at' => $now,
                ]);

                DB::table('announcement_views')->insertOrIgnore([
                    'announcement_id' => $ancId,
                    'user_id' => $sUid,
                    'created_at' => $now,
                ]);
            }
        }

        $this->command?->info("💬 Seeding Community Forum Discussions & Solved Q&As...");

        $forumPosts = [
            [
                'user_id' => $studentUserIds[0],
                'subject_id' => 1,
                'type' => 'question',
                'title' => 'استفسار حول كيفية تعيين زمن نصف التفاعل t(1/2) بيانياً عندما لا يبدأ المنحنى من الصفر؟',
                'content' => 'السلام عليكم زملائي وأساتذتي الكرام، في بعض التمارين تكون كمية المادة الابتدائية غير معدومة، كيف نسقط بيانياً لإيجاد زمن نصف التفاعل بدقة؟',
                'is_solved' => true,
                'replies' => [
                    [
                        'user_id' => $teacherUserIds[0], // Teacher reply
                        'content' => 'وعليكم السلام ورحمة الله بني عبد الحميد. في هذه الحالة تأخذ القيمة النهائية وتضيف إليها القيمة الابتدائية وتقسم المجموع على 2: x(t_1/2) = (x_0 + x_f) / 2، ثم تسقط الناتج على محور الأزمنة.',
                        'is_best' => true,
                    ],
                    [
                        'user_id' => $studentUserIds[1],
                        'content' => 'شكراً أستاذ للتوضيح، كانت تختلط علي هذه النقطة دائماً!',
                        'is_best' => false,
                    ]
                ]
            ],
            [
                'user_id' => $studentUserIds[2],
                'subject_id' => 2,
                'type' => 'discussion',
                'title' => 'ما هي أفضل خطة لمراجعة المتتاليات العددية وحل التمارين الصعبة؟',
                'content' => 'مرحباً بالجميع، أردت مشاركة طريقتي في حل المتتاليات بالبرهان بالتراجع وتعيين اتجاه التغير مع مناقشة أفكار التمارين المقترحة.',
                'is_solved' => false,
                'replies' => [
                    [
                        'user_id' => $studentUserIds[3],
                        'content' => 'فكرة ممتازة، البرهان بالتراجع هو المفتاح الأساسي لنيل النقاط كاملة في تمرين المتتاليات.',
                        'is_best' => false,
                    ]
                ]
            ]
        ];

        foreach ($forumPosts as $fp) {
            $postId = DB::table('forum_posts')->insertGetId([
                'user_id' => $fp['user_id'],
                'subject_id' => $fp['subject_id'],
                'type' => $fp['type'],
                'title' => $fp['title'],
                'content' => $fp['content'],
                'is_solved' => $fp['is_solved'],
                'created_at' => $now->copy()->subDays(rand(3, 18)),
                'updated_at' => $now,
            ]);

            // Seed forum post likes & views
            foreach (array_slice($studentUserIds, 0, 4) as $sUid) {
                DB::table('forum_post_likes')->insertOrIgnore([
                    'forum_post_id' => $postId,
                    'user_id' => $sUid,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);

                DB::table('forum_post_views')->insertOrIgnore([
                    'forum_post_id' => $postId,
                    'user_id' => $sUid,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }

            $bestRepId = null;

            foreach ($fp['replies'] as $rep) {
                $rId = DB::table('forum_replies')->insertGetId([
                    'forum_post_id' => $postId,
                    'user_id' => $rep['user_id'],
                    'content' => $rep['content'],
                    'is_best_answer' => $rep['is_best'],
                    'created_at' => $now->copy()->subDays(rand(1, 10)),
                    'updated_at' => $now,
                ]);

                if ($rep['is_best']) {
                    $bestRepId = $rId;
                }

                // Seed forum reply likes
                DB::table('forum_reply_likes')->insertOrIgnore([
                    'forum_reply_id' => $rId,
                    'user_id' => $studentUserIds[0],
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }

            if ($bestRepId) {
                DB::table('forum_posts')->where('id', $postId)->update(['best_reply_id' => $bestRepId]);
            }
        }

        $this->command?->info("⭐ Seeding Student Reviews & Star Ratings...");

        $reviewsList = [
            ['rating' => 5, 'comment' => 'أفضل دورة فيزياء على الإطلاق! الشرح مبسط والتمارين نموذجية تحاكي البكالوريات الرسمية تماماً.'],
            ['rating' => 5, 'comment' => 'بارك الله فيك أستاذ عبد القادر، بفضل هذه الدورة حققت علامة 19.5 في اختبار الفصل الأول!'],
            ['rating' => 5, 'comment' => 'دورة متكاملة، الفيديوهات عالية الجودة وسرعة الإجابة على الأسئلة ممتازة جداً.'],
            ['rating' => 5, 'comment' => 'أنصح كل طالب بكالوريا بالاشتراك، السعر في المتناول والفائدة لا تقدر بثمن.'],
            ['rating' => 5, 'comment' => 'شكراً لأكاديمية بصمة على هذا العمل الجبار والمنصة الاحترافية.'],
        ];

        foreach ($courseIds as $cId) {
            foreach (array_slice($studentUserIds, 0, 5) as $rIdx => $sUid) {
                $rev = $reviewsList[$rIdx % count($reviewsList)];
                DB::table('course_reviews')->updateOrInsert(
                    ['course_id' => $cId, 'user_id' => $sUid],
                    [
                        'rating' => $rev['rating'],
                        'comment' => $rev['comment'],
                        'created_at' => $now->copy()->subDays(rand(5, 45)),
                        'updated_at' => $now,
                    ]
                );
            }
        }

        DB::table('banners')->insert([
            [
                'title' => 'انطلاق التسجيلات في المراجعة النهائية الشاملة للبكالوريا 2026',
                'image_path' => 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=1200&auto=format&fit=crop&q=80',
                'target_route' => '/courses',
                'display_order' => 1,
                'is_active' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'title' => 'بنك التمارين التفاعلية وبطاقات الذاكرة Anki متاح الآن مجاناً',
                'image_path' => 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=1200&auto=format&fit=crop&q=80',
                'target_route' => '/flashcards',
                'display_order' => 2,
                'is_active' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        $this->command?->info("✅ Basma Academy Database successfully seeded with ultra-rich data!");
    }
}
