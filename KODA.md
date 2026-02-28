# KODA.md — Инструкции для работы с проектом Color Pool Puzzle

## Обзор проекта

**Название:** Color Pool Puzzle  
**Тип:** Flutter мобильное приложение (игра-головоломка)  
**Описание:** Головоломка с цветными пулами — игра, где игрокам нужно решать задачи, связанные с цветами и пулами.

## Основные технологии

| Компонент | Технология |
|-----------|------------|
| Фреймворк | Flutter SDK ^3.10.7 |
| Язык | Dart |
| Бэкенд | Supabase (supabase_flutter) |
| Локальное хранилище | shared_preferences |
| Конфигурация | flutter_dotenv |
| HTTP-клиент | http |
| Локализация | flutter_localizations + intl |

## Архитектура проекта

Проект построен на принципах **Clean Architecture** с чётким разделением на слои:

```
lib/
├── app/                    # Инфраструктура приложения
│   ├── di/                 # Внедрение зависимостей (Depends, DiContainer)
│   ├── http/               # HTTP-клиент (BaseHttpClient, IHttpClient)
│   ├── storage/            # Сервис хранилища (IStorageService, StorageService)
│   ├── supabase/           # Supabase сервис
│   ├── theme/              # Темизация (AppTheme)
│   ├── widget/             # Общие виджеты (AppError)
│   ├── utils/              # Утилиты (logger, error_util, app_zone)
│   ├── ext/                # Расширения (ContextExtensions)
│   ├── equals_mixin.dart   # Миксин для сравнения объектов
│   └── game_router.dart    # Маршрутизация
│
├── features/               # Бизнес-фичи
│   ├── user/               # Пользователь (data/domain/presentation)
│   ├── leaderboard/        # Таблица лидеров
│   ├── main_menu/          # Главное меню
│   └── init_app/           # Инициализация приложения
│
├── l10n/                   # Локализация (автогенерация)
└── main.dart               # Точка входа
```

### Пакетная структура (packages)

Проект использует монорепозиторий с переиспользуемыми пакетами в директории `packages/`:

| Пакет | Назначение |
|-------|------------|
| `game_q` | Игровая логика и экраны |
| `levels` | Уровни игры |
| `ui` | Переиспользуемые UI-компоненты |
| `map_editor` | Редактор карт |

### Паттерны разработки

- **Dependency Injection:** Ручное внедрение через класс `Depends` и `DiContainer`
- **State Management:** Cubit (flutter_bloc-подобный паттерн)
- **Repository Pattern:** Интерфейсы репозиториев (`IUserRepository`, `ILeaderboardRepository`)
- **DTO (Data Transfer Object):** Для работы с данными из API/БД

## Сборка и запуск проекта

### Установка зависимостей

```bash
flutter pub get
```

### Запуск приложения

```bash
flutter run
```

Для запуска на конкретном устройстве:

```bash
flutter run -d <device_id>
flutter run -d android
flutter run -d ios
```

### Сборка APK (Android)

```bash
flutter build apk --debug
flutter build apk --release
```

### Сборка iOS

```bash
flutter build ios --debug
flutter build ios --release
```

### Анализ кода

```bash
flutter analyze
```

### Форматирование кода

```bash
flutter format .
```

## Конфигурация окружения

Проект использует `.env` файл для конфигурации. Пример структуры:

```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
```

Загрузка переменных окружения выполняется в `main.dart` через `flutter_dotenv`.

## Правила разработки

### Стиль кода

- Используется `flutter_lints` (см. `analysis_options.yaml`)
- Следование Dart/Flutter гайдам по именованию
- Типизация: явные типы, nullable типы с `?`

### Структура фич (features)

Каждая фича организована по трём слоям:

```
features/<feature_name>/
├── data/           # Работа с данными (DTO, репозитории)
├── domain/         # Бизнес-логика (сущности, интерфейсы репозиториев, Cubit)
└── presentation/   # UI (экраны, виджеты)
```

### Коммиты и версионирование

- Версия приложения: `0.1.0` (из `pubspec.yaml`)
- Semantic Versioning: MAJOR.MINOR.PATCH

## Ключевые файлы

| Файл | Назначение |
|------|------------|
| `lib/main.dart` | Точка входа, инициализация приложения |
| `lib/app/di/depends.dart` | Регистрация зависимостей |
| `lib/app/di/di_container.dart` | Контейнер зависимостей (InheritedWidget) |
| `lib/app/game_router.dart` | Маршрутизация между экранами |
| `lib/app/theme/app_theme.dart` | Определение тем (light/dark) |
| `pubspec.yaml` | Зависимости проекта |
| `analysis_options.yaml` | Настройки анализатора |

## Работа с зависимостями

### Добавление новой зависимости

```bash
flutter pub add <package_name>
```

### Добавление dev-зависимости

```bash
flutter pub add --dev <package_name>
```

### Обновление зависимостей

```bash
flutter pub upgrade
```

## Тестирование

Тесты располагаются рядом с исходными файлами с суффиксом `_test.dart`. Запуск тестов:

```bash
flutter test
```

## Известные особенности

- Локализация: Поддержка русского языка (по умолчанию), настройка хранится в `shared_preferences`
- Темы: Светлая/тёмная тема с возможностью переключения
- Обработка ошибок: Единая система через `AppError` виджет и `ErrorUtil.logError()`
- Supabase: Используется для хранения данных пользователей и таблицы лидеров

## Структура импортов

В проекте используются относительные импорты. Пример:

```dart
import '../storage/i_storage_service.dart';
import '../../features/user/domain/i_user_repository.dart';
```

Для пакетов:

```dart
import 'package:game_q/game_screen.dart';
```
