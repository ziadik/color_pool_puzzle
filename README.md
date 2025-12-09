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
<img width="483" height="1047" alt="image" src="https://github.com/user-attachments/assets/44efa385-a1fa-46e4-a30f-ae9c58ad6d6c" />

# 📁 Проектная структура

## 🏗️ Обзор архитектуры

Проект построен по принципам **Clean Architecture** с четким разделением на слои и модульную организацию по фичам.

## 📂 Детальная структура

### **`lib/`** - Корневая директория приложения
lib/
├── app/ # 🏛️ Ядро приложения (общие компоненты)
│ ├── di/ # 💉 Dependency Injection
│ │ ├── di_container.dart # Контейнер зависимостей
│ │ └── depends.dart # Регистрация зависимостей
│ │
│ ├── http/ # 🌐 Сетевой слой
│ │ ├── i_http_client.dart # Интерфейс HTTP-клиента
│ │ └── base_http_client.dart # Базовая реализация
│ │
│ ├── storage/ # 💾 Локальное хранилище
│ │ ├── i_storage_service.dart
│ │ └── storage_service.dart
│ │
│ ├── theme/ # 🎨 Тема приложения
│ │ └── app_theme.dart # Конфигурация тем
│ │
│ ├── utils/ # 🛠️ Утилиты
│ │ ├── logger.dart # Кастомный логгер
│ │ ├── error_util.dart # Обработка ошибок
│ │ └── app_zone.dart # Зоны выполнения
│ │
│ ├── ext/ # 🔧 Расширения
│ │ └── context_ext.dart # Расширения BuildContext
│ │
│ ├── widget/ # 🧩 Переиспользуемые виджеты
│ │ └── app_error.dart # Виджет ошибки
│ │
│ ├── equals_mixin.dart # 🔁 Миксин для сравнения объектов
│ └── game_router.dart # 🧭 Навигация
│
├── features/ # 🚀 Фичи приложения (по модулям)
│ │
│ ├── user/ # 👤 Пользовательская система
│ │ ├── data/ # 📊 Data Layer
│ │ │ ├── user_dto.dart # Data Transfer Object
│ │ │ └── user_repository.dart # Реализация репозитория
│ │ │
│ │ ├── domain/ # 🧠 Domain Layer
│ │ │ ├── user_entity.dart # Сущность пользователя
│ │ │ ├── i_user_repository.dart # Интерфейс репозитория
│ │ │ └── state/ # 🎛️ Управление состоянием
│ │ │ ├── user_cubit.dart # Cubit для пользователя
│ │ │ └── user_state.dart # Состояния пользователя
│ │ │
│ │ └── presentation/ # 🎨 Presentation Layer
│ │ ├── user_screen.dart # Основной экран
│ │ └── components/ # 🧱 UI компоненты
│ │ ├── username_field.dart # Поле ввода имени
│ │ ├── user_created.dart # Виджет успеха
│ │ └── user_error.dart # Виджет ошибки
│ │
│ ├── leaderboard/ # 🏆 Таблица лидеров
│ │ ├── data/ # 📊 Data Layer
│ │ │ ├── leaderboard_dto.dart
│ │ │ └── leaderboard_repository.dart
│ │ │
│ │ ├── domain/ # 🧠 Domain Layer
│ │ │ ├── leaderboard_entity.dart
│ │ │ ├── i_leaderboard_repository.dart
│ │ │ └── state/ # 🎛️ Управление состоянием
│ │ │ ├── leaderboard_cubit.dart
│ │ │ └── leaderboard_state.dart
│ │ │
│ │ └── presentation/ # 🎨 Presentation Layer
│ │ └── leaderboard_screen.dart
│ │
│ ├── game/ # 🎮 Игровой процесс
│ │ └── game_screen.dart # Игровой экран
│ │
│ ├── main_menu/ # 📱 Главное меню
│ │ └── main_menu_screen.dart # Экран меню
│ │
│ └── init_app/ # ⚙️ Инициализация приложения
│ ├── data/ # 📊 Data Layer
│ │ ├── initialization.dart
│ │ └── initialize_dependencies.dart
│ │
│ └── widget/ # 🎨 Presentation Layer
│ # Виджеты инициализации
│
└── l10n/ # 🌍 Локализация
├── app_en.arb # 🇬🇧 Английские переводы
├── app_ru.arb # 🇷🇺 Русские переводы
└── gen/ # 🔧 Сгенерированный код
├── app_localizations.dart
├── app_localizations_en.dart
└── app_localizations_ru.dart

text

## 🎯 Назначение директорий

### **`app/`** - Общие компоненты
- Содержит код, используемый во всем приложении
- Независим от конкретных фич
- Включает инфраструктурные компоненты

### **`features/`** - Модули фич
- Каждая фича - изолированный модуль
- Соблюдает принцип **вертикального разделения**
- Каждый модуль имеет свою архитектуру:
  - `data/` - работа с данными
  - `domain/` - бизнес-логика
  - `presentation/` - пользовательский интерфейс

### **`l10n/`** - Локализация
- Поддержка нескольких языков
- Генерация кода из ARB файлов
- Легкое добавление новых языков

## 🔄 Взаимодействие слоев
Presentation → Domain → Data
(UI) (Logic) (Sources)
↑ ↑ ↑
Cubits Entities Repositories
↑ ↑ ↑
States Use Cases APIs / DB

text

## 📝 Ключевые файлы

| Файл | Назначение | Расположение |
|------|------------|--------------|
| `main.dart` | Точка входа в приложение | `lib/` |
| `di_container.dart` | Реализация DI контейнера | `app/di/` |
| `depends.dart` | Регистрация зависимостей | `app/di/` |
| `app_theme.dart` | Конфигурация тем | `app/theme/` |
| `logger.dart` | Система логирования | `app/utils/` |
| `user_cubit.dart` | Управление состоянием пользователя | `features/user/domain/state/` |
| `user_repository.dart` | Работа с данными пользователя | `features/user/data/` |
| `app_localizations.dart` | Локализация | `l10n/gen/` |

## 🏆 Преимущества структуры

1. **Модульность** - Каждая фича независима
2. **Тестируемость** - Легко мокать зависимости
3. **Масштабируемость** - Просто добавлять новые фичи
4. **Поддержка** - Четкое разделение ответственности
5. **Переиспользуемость** - Общие компоненты в `app/`

## 🚀 Рекомендации по разработке

### Добавление новой фичи:
lib/features/new_feature/
├── data/
│ ├── new_feature_dto.dart
│ └── new_feature_repository.dart
├── domain/
│ ├── new_feature_entity.dart
│ ├── i_new_feature_repository.dart
│ └── state/
│ ├── new_feature_cubit.dart
│ └── new_feature_state.dart
└── presentation/
├── new_feature_screen.dart
└── components/

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
