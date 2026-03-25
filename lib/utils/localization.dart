import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Localization {
  static const List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'displayName': 'English'},
    {'code': 'ru', 'displayName': 'Русский'},
    {'code': 'uk', 'displayName': 'Українська'},
    {'code': 'kk', 'displayName': 'Қазақша'},
    {'code': 'be', 'displayName': 'Беларуская'},
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
    Locale('kk'),
    Locale('be'),
  ];

  static String _currentLanguageCode = 'en';

  static String get currentLanguageCode => _currentLanguageCode;

  static void setLanguage(String code) {
    _currentLanguageCode = code;
  }

  static Map<String, Map<String, String>> strings = {
    'en': _englishStrings,
    'ru': _russianStrings,
    'uk': _ukrainianStrings,
    'kk': _kazakhStrings,
    'be': _belarusianStrings,
  };

  static String getString(String key, [dynamic arg]) {
    final langStrings = strings[_currentLanguageCode] ?? strings['en']!;
    String value = langStrings[key] ?? key;

    if (arg != null) {
      if (key == 'moves') {
        return _pluralizeMoves(arg as int);
      }
      if (value.contains('%d')) {
        return value.replaceAll('%d', arg.toString());
      }
      if (value.contains('%@')) {
        return value.replaceAll('%@', arg.toString());
      }
    }
    return value;
  }

  static String plural(String key, int number) {
    if (key == 'moves') {
      return _pluralizeMoves(number);
    }
    return getString(key);
  }

  static String _pluralizeMoves(int number) {
    final langStrings = strings[_currentLanguageCode] ?? strings['en']!;
    final language = _currentLanguageCode;

    if (language == 'ru' || language == 'uk' || language == 'be') {
      final mod10 = number % 10;
      final mod100 = number % 100;

      if (mod10 == 1 && mod100 != 11) {
        return langStrings['moves_one']?.replaceAll('%d', number.toString()) ??
            '$number ход';
      } else if ((mod10 >= 2 && mod10 <= 4) &&
          !(mod100 >= 12 && mod100 <= 14)) {
        return langStrings['moves_few']?.replaceAll('%d', number.toString()) ??
            '$number хода';
      } else {
        return langStrings['moves_many']?.replaceAll('%d', number.toString()) ??
            '$number ходов';
      }
    } else {
      return number == 1
          ? langStrings['moves_one']?.replaceAll('%d', number.toString()) ??
              '$number move'
          : langStrings['moves']?.replaceAll('%d', number.toString()) ??
              '$number moves';
    }
  }

  static const Map<String, String> _englishStrings = {
    'unlockAllLevels': 'Unlock All Levels',
    'unlockAllLevelsConfirm':
        'Unlock all levels? This will allow you to play any level without completing previous ones.',
    'unlockAllLevelsWarning':
        'This is for testing purposes only. You can still reset progress later.',
    'developer': 'Developer',
    'developerName': 'Developer',
    'website': 'Website',
    'email': 'Email',
    'version': 'Version',
    'build': 'build',
    'cannotOpenLink': 'Cannot open link',
    'level': 'Level',
    'undo': 'Undo',
    'restart': 'Restart',
    'settings': 'Settings',
    'language': 'Language',
    'sound': 'Sound',
    'progress': 'Progress',
    'resetResults': 'Reset Results',
    'levelComplete': 'Level Complete!',
    'nextLevel': 'Next Level',
    'allLevelsPassed': 'You passed all levels!',
    'close': 'Close',
    'soundOn': 'Sound On',
    'selectLanguage': 'Select Language',
    'cancel': 'Cancel',
    'reset': 'Reset',
    'resetConfirmation': 'Reset progress?',
    'resetWarning': 'You will start the game from the beginning.',
    'theme': 'Theme',
    'systemTheme': 'System',
    'lightTheme': 'Light',
    'darkTheme': 'Dark',
    'vibration': 'Vibration',
    'vibrationEnabled': 'Enable Vibration',
    'vibrationStrength': 'Vibration Strength',
    'vibrationLight': 'Light',
    'vibrationMedium': 'Medium',
    'vibrationStrong': 'Strong',
    'hint': '💡 Hint',
    'leaderboard': 'Leaderboard',
    'moves': '%d moves',
    'moves_one': '%d move',
    'moves_few': '%d moves',
    'moves_many': '%d moves',
    'bestResults': 'Best Results',
    'noRecords': 'No records yet',
    'startGame': 'Start Game',
    'unsavedChanges': 'Unsaved Changes',
    'unsavedChangesNavigation':
        'You have unsaved changes on this level. Go to %@ level?',
    'unsavedChangesRestart': 'You have unsaved changes. Restart the level?',
    'restartLevel': 'Restart Level',
    'levelLocked': 'Level Locked',
    'completePreviousLevels': 'Complete previous levels first',
    'continue': 'Continue',
    'previous': 'Previous',
    'next': 'Next',
    'noHints': 'No hints available',
    'ok': 'OK',
  };

  static const Map<String, String> _russianStrings = {
    'unlockAllLevels': 'Открыть все уровни',
    'unlockAllLevelsConfirm':
        'Открыть все уровни? Это позволит играть на любом уровне без прохождения предыдущих.',
    'unlockAllLevelsWarning':
        'Это только для тестирования. Вы всегда можете сбросить прогресс позже.',
    'developer': 'Разработчик',
    'developerName': 'Разработчик',
    'website': 'Сайт',
    'email': 'Email',
    'version': 'Версия',
    'build': 'сборка',
    'cannotOpenLink': 'Не удалось открыть ссылку',
    'level': 'Уровень',
    'undo': 'Отменить',
    'restart': 'Заново',
    'settings': 'Настройки',
    'language': 'Язык',
    'sound': 'Звук',
    'progress': 'Прогресс',
    'resetResults': 'Сбросить результаты',
    'levelComplete': 'Уровень пройден!',
    'nextLevel': 'Следующий уровень',
    'allLevelsPassed': 'Вы прошли все уровни!',
    'close': 'Закрыть',
    'soundOn': 'Включить звук',
    'selectLanguage': 'Выберите язык',
    'cancel': 'Отмена',
    'reset': 'Сбросить',
    'resetConfirmation': 'Сбросить прогресс?',
    'resetWarning': 'Вы начнете игру с самого начала.',
    'theme': 'Тема',
    'systemTheme': 'Системная',
    'lightTheme': 'Светлая',
    'darkTheme': 'Темная',
    'vibration': 'Вибрация',
    'vibrationEnabled': 'Включить вибрацию',
    'vibrationStrength': 'Сила вибрации',
    'vibrationLight': 'Легкая',
    'vibrationMedium': 'Средняя',
    'vibrationStrong': 'Сильная',
    'hint': '💡 Подсказка',
    'leaderboard': 'Таблица рекордов',
    'moves': '%d ходов',
    'moves_one': '%d ход',
    'moves_few': '%d хода',
    'moves_many': '%d ходов',
    'bestResults': 'Лучшие результаты',
    'noRecords': 'Рекордов пока нет',
    'startGame': 'Начать игру',
    'unsavedChanges': 'Несохраненные изменения',
    'unsavedChangesNavigation':
        'У вас есть несохраненные изменения на этом уровне. Перейти на %@ уровень?',
    'unsavedChangesRestart':
        'У вас есть несохраненные изменения. Начать уровень заново?',
    'restartLevel': 'Перезапустить уровень',
    'levelLocked': 'Уровень заблокирован',
    'completePreviousLevels': 'Сначала пройдите предыдущие уровни',
    'continue': 'Продолжить',
    'previous': 'Предыдущий',
    'next': 'Следующий',
    'noHints': 'Нет доступных подсказок',
    'ok': 'OK',
  };

  static const Map<String, String> _ukrainianStrings = {
    'level': 'Рівень',
    'undo': 'Скасувати',
    'restart': 'Спочатку',
    'settings': 'Налаштування',
    'language': 'Мова',
    'sound': 'Звук',
    'progress': 'Прогрес',
    'resetResults': 'Скинути результати',
    'levelComplete': 'Рівень пройдено!',
    'nextLevel': 'Наступний рівень',
    'allLevelsPassed': 'Ви пройшли всі рівні!',
    'close': 'Закрити',
    'soundOn': 'Увімкнути звук',
    'selectLanguage': 'Виберіть мову',
    'cancel': 'Скасувати',
    'reset': 'Скинути',
    'resetConfirmation': 'Скинути прогрес?',
    'resetWarning': 'Ви почнете гру спочатку.',
    'theme': 'Тема',
    'systemTheme': 'Системна',
    'lightTheme': 'Світла',
    'darkTheme': 'Темна',
    'vibration': 'Вібрація',
    'vibrationEnabled': 'Увімкнути вібрацію',
    'vibrationStrength': 'Сила вібрації',
    'vibrationLight': 'Легка',
    'vibrationMedium': 'Середня',
    'vibrationStrong': 'Сильна',
    'hint': '💡 Підказка',
    'leaderboard': 'Таблиця рекордів',
    'moves': '%d ходів',
    'moves_one': '%d хід',
    'moves_few': '%d ходи',
    'moves_many': '%d ходів',
    'bestResults': 'Найкращі результати',
    'noRecords': 'Рекордів поки немає',
    'startGame': 'Почати гру',
    'unsavedChanges': 'Незбережені зміни',
    'unsavedChangesNavigation':
        'У вас є незбережені зміни на цьому рівні. Перейти на %@ рівень?',
    'unsavedChangesRestart': 'У вас є незбережені зміни. Почати рівень заново?',
    'restartLevel': 'Перезапустити рівень',
    'levelLocked': 'Рівень заблоковано',
    'completePreviousLevels': 'Спочатку пройдіть попередні рівні',
    'continue': 'Продовжити',
    'previous': 'Попередній',
    'next': 'Наступний',
    'noHints': 'Немає доступних підказок',
    'ok': 'Гаразд',
  };

  static const Map<String, String> _kazakhStrings = {
    'level': 'Деңгей',
    'undo': 'Болдырмау',
    'restart': 'Қайта бастау',
    'settings': 'Баптаулар',
    'language': 'Тіл',
    'sound': 'Дыбыс',
    'progress': 'Прогресс',
    'resetResults': 'Нәтижелерді қалпына келтіру',
    'levelComplete': 'Деңгей өтті!',
    'nextLevel': 'Келесі деңгей',
    'allLevelsPassed': 'Сіз барлық деңгейлерді өттіңіз!',
    'close': 'Жабу',
    'soundOn': 'Дыбысты қосу',
    'selectLanguage': 'Тілді таңдаңыз',
    'cancel': 'Бас тарту',
    'reset': 'Қалпына келтіру',
    'resetConfirmation': 'Прогресті қалпына келтіру?',
    'resetWarning': 'Сіз ойынды басынан бастайсыз.',
    'theme': 'Тақырып',
    'systemTheme': 'Жүйелік',
    'lightTheme': 'Ашық',
    'darkTheme': 'Қараңғы',
    'vibration': 'Діріл',
    'vibrationEnabled': 'Дірілді қосу',
    'vibrationStrength': 'Діріл күші',
    'vibrationLight': 'Жеңіл',
    'vibrationMedium': 'Орташа',
    'vibrationStrong': 'Күшті',
    'hint': '💡 Кеңес',
    'leaderboard': 'Рекордтар кестесі',
    'moves': '%d қозғалыс',
    'moves_one': '%d қозғалыс',
    'bestResults': 'Үздік нәтижелер',
    'noRecords': 'Әзірге рекордтар жоқ',
    'startGame': 'Ойынды бастау',
    'unsavedChanges': 'Сақталмаған өзгерістер',
    'unsavedChangesNavigation':
        'Осы деңгейде сақталмаған өзгерістер бар. %@ деңгейге өту?',
    'unsavedChangesRestart':
        'Сақталмаған өзгерістер бар. Деңгейді қайта бастау?',
    'restartLevel': 'Деңгейді қайта бастау',
    'levelLocked': 'Деңгей бұғатталған',
    'completePreviousLevels': 'Алдымен алдыңғы деңгейлерді өтіңіз',
    'continue': 'Жалғастыру',
    'previous': 'Алдыңғы',
    'next': 'Келесі',
    'noHints': 'Қолжетімді кеңестер жоқ',
    'ok': 'OK',
  };

  static const Map<String, String> _belarusianStrings = {
    'level': 'Узровень',
    'undo': 'Адмяніць',
    'restart': 'Занава',
    'settings': 'Налады',
    'language': 'Мова',
    'sound': 'Гук',
    'progress': 'Прагрэс',
    'resetResults': 'Скінуць вынікі',
    'levelComplete': 'Узровень пройдзены!',
    'nextLevel': 'Наступны ўзровень',
    'allLevelsPassed': 'Вы прайшлі ўсе ўзроўні!',
    'close': 'Закрыць',
    'soundOn': 'Уключыць гук',
    'selectLanguage': 'Выберыце мову',
    'cancel': 'Адмена',
    'reset': 'Скінуць',
    'resetConfirmation': 'Скінуць прагрэс?',
    'resetWarning': 'Вы пачнеце гульню з самага пачатку.',
    'theme': 'Тэма',
    'systemTheme': 'Сістэмная',
    'lightTheme': 'Светлая',
    'darkTheme': 'Цёмная',
    'vibration': 'Вібрацыя',
    'vibrationEnabled': 'Уключыць вібрацыю',
    'vibrationStrength': 'Сіла вібрацыі',
    'vibrationLight': 'Лёгкая',
    'vibrationMedium': 'Сярэдняя',
    'vibrationStrong': 'Моцная',
    'hint': '💡 Падказка',
    'leaderboard': 'Табліца рэкордаў',
    'moves': '%d ходаў',
    'moves_one': '%d ход',
    'moves_few': '%d хады',
    'moves_many': '%d ходаў',
    'bestResults': 'Лепшыя вынікі',
    'noRecords': 'Рэкордаў пакуль няма',
    'startGame': 'Пачаць гульню',
    'unsavedChanges': 'Незахаваныя змены',
    'unsavedChangesNavigation':
        'У вас ёсць незахаваныя змены на гэтым узроўні. Перайсці на %@ узровень?',
    'unsavedChangesRestart':
        'У вас ёсць незахаваныя змены. Пачаць узровень занава?',
    'restartLevel': 'Перазапусціць узровень',
    'levelLocked': 'Узровень заблакіраваны',
    'completePreviousLevels': 'Спачатку пройдзіце папярэднія ўзроўні',
    'continue': 'Працягнуць',
    'previous': 'Папярэдні',
    'next': 'Наступны',
    'noHints': 'Няма даступных падказак',
    'ok': 'OK',
  };
}
