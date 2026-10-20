# Basma Academy — Mobile Application

> High-performance educational platform built with Flutter, designed for Algerian Baccalaureate students featuring an interactive curriculum, AI-powered voice tutor, active-recall flashcards, and video lessons.

---

## 📱 Features

- **🎓 Comprehensive Course Catalog**: Stream-specific baccalaureate courses with structured video sections and lessons.
- **🤖 AI Voice & Chat Tutor**: Real-time voice and text tutoring engine for instant homework clarification and concept explanation.
- **🗂️ Active Recall Flashcards**: Spaced repetition flashcard decks for memorization and exam revision.
- **💬 Community Forum**: Collaborative Q&A feed with verified answers and discussion threads.
- **📢 Real-time Announcements**: Teacher updates, notifications, and interactive announcement boards.
- **💳 Seamless Enrollments**: In-app course ordering and automated proof-of-payment submission.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart 3.x)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Networking**: [Dio](https://pub.dev/packages/dio) with token interceptors and automatic platform base URL resolution
- **Media**: Cached Network Images, Custom Video Player, Audio playback engines
- **Storage**: GetStorage / Local Storage abstraction
- **Architecture**: Modular Feature-First Architecture (`lib/features/*`, `lib/core/*`)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.24.0`
- Dart SDK `^3.5.0`
- Android Studio / Xcode

### Installation

1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure API Endpoint (Optional):
   By default, the app connects to `http://10.0.2.2:8000/api` on Android emulator and `http://127.0.0.1:8000/api` on iOS simulator / desktop.
   To target a custom backend:
   ```bash
   flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com/api
   ```

4. Run the application:
   ```bash
   flutter run
   ```
