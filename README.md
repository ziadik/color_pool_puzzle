# 🎨 Color Pool Puzzle

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange.svg)]()

A modern Flutter puzzle game built with Clean Architecture, featuring color-based gameplay mechanics and a robust technical foundation.

<p align="center">
  <img src="https://via.placeholder.com/300x600/4A6572/FFFFFF?text=Color+Pool+Puzzle" alt="App Preview" width="300">
</p>

## 🎯 Features

### 🎮 Gameplay
- **Color-based puzzle mechanics** - Solve challenging puzzles using color combinations
- **Progressive difficulty** - Levels that adapt to your skill level
- **Score tracking** - Compete for high scores

### 🏗️ Architecture
- **Clean Architecture** - Clear separation of concerns
- **Dependency Injection** - Custom DI container implementation
- **Repository Pattern** - Abstract data access layer

### 🌐 Technical
- **Multi-language support** - English & Russian localization
- **Custom HTTP client** - Abstract network layer
- **Persistent storage** - Secure local data storage
- **Error handling** - Centralized error management
- **Logging system** - Custom logger with multiple levels

## 📱 Screenshots

| Main Menu | Game Screen | Leaderboard | User Profile |
|-----------|-------------|-------------|--------------|
| ![Main Menu](https://via.placeholder.com/200x400/344955/FFFFFF?text=Menu) | ![Game](https://via.placeholder.com/200x400/4A6572/FFFFFF?text=Game) | ![Leaderboard](https://via.placeholder.com/200x400/232F34/FFFFFF?text=Scores) | ![Profile](https://via.placeholder.com/200x400/F9AA33/000000?text=Profile) |

## 🏗️ Project Structure

lib/
├── app/ # Application core
│ ├── di/ # Dependency Injection
│ │ ├── di_container.dart # DI container implementation
│ │ └── depends.dart # Dependency registrations
│ ├── http/ # Network layer
│ │ ├── i_http_client.dart # HTTP client interface
│ │ └── base_http_client.dart
│ ├── storage/ # Local storage
│ ├── theme/ # App theming
│ ├── utils/ # Utilities
│ │ ├── logger.dart # Custom logger
│ │ ├── error_util.dart # Error handling
│ │ └── app_zone.dart # Execution zones
│ └── widget/ # Reusable widgets
│
├── features/ # Feature modules
│ ├── user/ # User feature
│ │ ├── data/ # Data layer
│ │ │ ├── user_dto.dart
│ │ │ └── user_repository.dart
│ │ ├── domain/ # Domain layer
│ │ │ ├── user_entity.dart
│ │ │ ├── i_user_repository.dart
│ │ │ └── state/ # State management
│ │ └── presentation/ # UI layer
│ │ ├── user_screen.dart
│ │ └── components/ # UI components
│ ├── leaderboard/ # Leaderboard feature
│ ├── game/ # Game feature
│ ├── main_menu/ # Main menu
│ └── init_app/ # App initialization
│
└── l10n/ # Localization
├── app_en.arb # English translations
├── app_ru.arb # Russian translations
└── gen/ # Generated code

text

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- IDE: VS Code or Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/color_pool_puzzle.git
   cd color_pool_puzzle
Install dependencies

bash
flutter pub get
Generate localization files

bash
flutter gen-l10n
Run the app

bash
flutter run
Build Commands
bash
# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web --release
🧩 Features in Detail
User Management
Create and manage user profiles

Username validation and error handling

Profile persistence across sessions

Game Mechanics
Interactive color puzzles

Real-time score calculation

Game state persistence

Leaderboard System
Global score rankings

Real-time updates

Player statistics

Localization
Complete English & Russian support

Easy to add new languages

Automatic code generation