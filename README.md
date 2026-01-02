# Test App

A Flutter application built with clean architecture principles, featuring authentication, state management with Bloc, and Firebase integration.

## 🚀 Features

- **Authentication**
  - Email/Password login
  - Secure token management
  - Session handling

- **State Management**
  - BLoC pattern implementation
  - Clean separation of concerns
  - Reactive UI updates

- **Architecture**
  - Clean Architecture principles
  - Dependency Injection using get_it and injectable
  - Repository pattern

- **UI/UX**
  - Responsive design
  - Material Design 3 theming
  - Custom animations and transitions

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: flutter_bloc
- **Dependency Injection**: get_it + injectable
- **Networking**: Dio
- **Local Storage**: Shared Preferences
- **Authentication**: Firebase Auth
- **Image Caching**: cached_network_image
- **Styling**: Google Fonts
- **Code Generation**: freezed, build_runner

## 📱 Screenshots

*Screenshots will be added here*

## 🏗️ Project Structure

```
lib/
├── application/      # Application layer (BLoCs, Use Cases)
│   ├── auth/        # Authentication related BLoCs and events
│   └── core/        # Core application logic and utilities
├── domain/          # Business logic layer
│   ├── auth/        # Authentication domain models and interfaces
│   └── core/        # Core domain models and interfaces
├── infrastructure/  # Infrastructure layer
│   ├── auth/        # Authentication implementation
│   └── core/        # Core infrastructure services
└── presentation/    # UI layer
    ├── pages/       # App screens
    └── widgets/     # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.10.3)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter plugins
- Firebase project setup

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd test-main
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Set up Firebase:
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`

5. Run the app:
   ```bash
   flutter run
   ```



## 📦 Dependencies

- flutter_bloc: ^8.1.6
- firebase_core: ^4.3.0
- firebase_auth: ^6.1.3
- dio: ^5.7.0
- get_it: ^8.0.3
- injectable: ^2.5.0
- freezed_annotation: ^2.4.4
- shared_preferences: ^2.5.4

