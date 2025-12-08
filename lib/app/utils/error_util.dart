// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

/// Error util.
abstract final class ErrorUtil {
  /// Log the error to the console and to Crashlytics.
  static Future<void> logError(Object exception, StackTrace stackTrace, {String? hint, bool fatal = false}) async {
    try {
      if (exception is String) {
        return await logMessage(exception, stackTrace: stackTrace, hint: hint, warning: true);
      }
      // Заглушка вместо $captureException
      await _captureException(exception, stackTrace, hint, fatal);

      // Простое логирование в консоль вместо l.e
      print('ERROR: $exception');
      print(stackTrace);
    } on Object catch (error, stackTrace) {
      print('Error while logging error "$error" inside ErrorUtil.logError');
      print(stackTrace);
    }
  }

  /// Logs a message to the console and to Crashlytics.
  static Future<void> logMessage(String message, {StackTrace? stackTrace, String? hint, bool warning = false}) async {
    try {
      final trace = stackTrace ?? StackTrace.current;
      print('${warning ? 'WARNING' : 'MESSAGE'}: $message');
      print(trace);

      // Заглушка вместо $captureMessage
      await _captureMessage(message, trace, hint, warning);
    } on Object catch (error, stackTrace) {
      print('Error while logging error "$error" inside ErrorUtil.logMessage');
      print(stackTrace);
    }
  }

  /// Rethrows the error with the stack trace.
  static Never throwWithStackTrace(Object error, StackTrace stackTrace) => Error.throwWithStackTrace(error, stackTrace);

  // Заглушки для замены удаленных импортов

  static Future<void> _captureException(Object exception, StackTrace stackTrace, String? hint, bool fatal) async {
    // Реализация по умолчанию - ничего не делает
    // В реальном приложении здесь может быть логика для Crashlytics и т.д.
  }

  static Future<void> _captureMessage(String message, StackTrace stackTrace, String? hint, bool warning) async {
    // Реализация по умолчанию - ничего не делает
    // В реальном приложении здесь может быть логика для Crashlytics и т.д.
  }
}
