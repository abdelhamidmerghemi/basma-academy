# Basma Academy — API Backend & Admin Panel

> Robust, scalable RESTful API and administration engine powering the Basma Academy mobile learning experience, built on Laravel 13, Filament PHP, and MySQL.

---

## ⚡ Features

- **🔐 Sanctum API Authentication**: Token-based authentication for students, teachers, and administrators.
- **🖥️ Filament Admin Panel**: Administration dashboard for managing courses, lessons, quizzes, flashcards, teacher accounts, and review workflows.
- **📚 Baccalaureate Curriculum Engine**: Multi-stream course structures (Sciences, Math, Literature, Management) with section-by-section video streaming and progress tracking.
- **💬 Forum & Announcements API**: Discussion boards, comments, likes, best-answer marking, and teacher broadcast channels.
- **💳 Order & Payment Verification**: In-app purchase workflow with receipt proof upload and status review.
- **🌱 Production-Grade Master Seeder**: Complete seeded curriculum ready for testing and demoing immediately.

---

## 🛠️ Tech Stack

- **Framework**: [Laravel 13](https://laravel.com) (PHP 8.3+)
- **Admin Engine**: [Filament v3](https://filamentphp.com)
- **Database**: MySQL / SQLite
- **Authentication**: Laravel Sanctum
- **Asset Pipeline**: Vite

---

## 🚀 Getting Started

### Prerequisites

- PHP `>= 8.3`
- Composer `>= 2.5`
- MySQL or SQLite

### Installation

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install PHP dependencies:
   ```bash
   composer install
   ```

3. Setup environment configuration:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. Configure database in `.env`:
   ```ini
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=basma_academy
   DB_USERNAME=root
   DB_PASSWORD=
   ```

5. Run migrations & rich master seeder:
   ```bash
   php artisan migrate --seed
   ```

6. Start local development server:
   ```bash
   php artisan serve --port=8000
   ```
