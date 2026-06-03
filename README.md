<div align="center">

# 🎱 Color Pool Puzzle

### Логическая головоломка с цветными шариками

<img width="2440" alt="Color Pool Puzzle Banner" src="https://github.com/user-attachments/assets/95cacf31-5301-43fc-ba31-32883a6e5d7c" />

[![Play Online](https://img.shields.io/badge/Play_Online-Web-blue?style=for-the-badge&logo=google-chrome)](https://qlutter.ziidik.ru/)
[![RuStore](https://img.shields.io/badge/RuStore-Android-green?style=for-the-badge&logo=android)](https://apps.rustore.ru/app/ru.ziidik.qlutter)
[![App Store](https://img.shields.io/badge/App_Store-iOS-black?style=for-the-badge&logo=apple)](https://apps.apple.com/us/app/color-pool-puzzle/id6760399649)
[![Windows](https://img.shields.io/badge/Windows-7%2F8%2F10%2F11-0078D6?style=for-the-badge&logo=windows)](#-установка-на-windows)

[![Flutter](https://img.shields.io/badge/Flutter-3.19.6-02569B?style=flat-square&logo=flutter)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20iOS%20%7C%20Android%20%7C%20Windows-orange?style=flat-square)]()

</div>

---

## 📖 О игре

**Color Pool Puzzle** — это увлекательная логическая игра, цель которой закатить все цветные шарики на игровом поле в лунки того же цвета.

### 🎮 Как играть

- 🎯 **Цель:** Закатить все цветные шарики в лунки соответствующего цвета
- ➡️ **Движение:** Шарики двигаются только по прямой
- 🛑 **Остановка:** Шарик останавливается у первого препятствия
- 🧱 **Препятствия:** Неподвижные блоки или другие шарики

<img src="https://github.com/user-attachments/assets/f2589a88-6b58-4e2c-955b-d70d7a0c020e" alt="Gameplay" width="100%" />

---

## ✨ Особенности

- 🧩 **Сотни уникальных уровней** с возрастающей сложностью
- 🎨 **Красивая графика** и плавные анимации
- 🎵 **Приятное звуковое сопровождение**
- 📱 **Кроссплатформенность:** Играйте на любом устройстве
- 🌐 **Играйте онлайн** прямо в браузере
- 💾 **Сохранение прогресса** автоматически
- 🚫 **Без рекламы** и внутренних покупок
- 🎯 **Простое управление** — swipe для движения шариков

---

## 📥 Установка

### 🌐 Веб-версия (онлайн)
Просто откройте в браузере: **[qlutter.ziidik.ru](https://qlutter.ziidik.ru/)**

### 📱 Мобильные устройства

| Платформа | Ссылка |
|-----------|--------|
| **Android** | [Скачать в RuStore](https://apps.rustore.ru/app/ru.ziidik.qlutter) |
| **iOS** | [Скачать в App Store](https://apps.apple.com/us/app/color-pool-puzzle/id6760399649) |

### 💻 Windows (Desktop)

Поддерживаются **Windows 7, 8, 10, 11** (32-bit и 64-bit).

**Системные требования:**
- Windows 7 SP1 или новее
- Обновления KB4474419 и KB4490628 (для Windows 7)
- 2 ГБ RAM
- 200 МБ свободного места

**Установка:**
1. Скачайте последнюю версию из [Releases](../../releases)
2. Выберите файл:
   - `Color-Pool-Puzzle-x64.exe` — для 64-битной Windows
   - `Color-Pool-Puzzle-ia32.exe` — для 32-битной Windows
3. Запустите скачанный файл
4. Играйте без установки! (портативная версия)

---

## 🛠️ Для разработчиков

### Требования

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (версия 3.19.6)
- [FVM](https://fvm.app/) (Flutter Version Manager)
- [Node.js](https://nodejs.org/) (версия 18.x или 16.x)
- [Git](https://git-scm.com/)

### Установка и запуск

#### 1. Клонирование репозитория

```bash
git clone https://github.com/yourusername/color-pool-puzzle.git
cd color-pool-puzzle
# Установка FVM (если ещё не установлен)
dart pub global activate fvm

# Установка Flutter 3.19.6
fvm install 3.19.6
# 1. Сборка Flutter (в папке Flutter-проекта)
cd C:\Projects\flutter\color_pool_puzzle
fvm use 3.19.6
fvm flutter clean
fvm flutter pub get
fvm flutter build web --release --web-renderer html

# 2. Правка base href
# Откройте build/web/index.html и замените <base href="/"> на <base href="./">

# 3. Копирование в Electron
Remove-Item -Recurse -Force ..\color_pool_puzzle_electron\app\*
Copy-Item -Path build\web\* -Destination ..\color_pool_puzzle_electron\app\ -Recurse

# 4. Тест
cd ..\color_pool_puzzle_electron
npm start

# 5. Финальная сборка (если тест прошёл)
npm run dist