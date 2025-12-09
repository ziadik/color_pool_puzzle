import 'dart:async';
import 'dart:developer' as developer;

/// Уровни логирования
enum LogLevel {
  v(1, 'V'),
  v1(2, 'V1'),
  v2(3, 'V2'),
  v3(4, 'V3'),
  v4(5, 'V4'),
  v5(6, 'V5'),
  v6(7, 'V6'),
  i(8, 'I'),
  w(9, 'W'),
  e(10, 'E'),
  wtf(11, 'WTF'),
  s(12, 'S');

  const LogLevel(this.level, this.representation);

  final int level;
  final String representation;

  static LogLevel fromValue(int value) {
    return values.firstWhere((level) => level.level == value, orElse: () => LogLevel.i);
  }
}

/// Сообщение лога
sealed class LogMessage {
  LogMessage({required this.timestamp, required this.level, required this.message});

  final DateTime timestamp;
  final LogLevel level;
  final Object message;
}

/// Детальное сообщение лога (без stack trace)
class LogMessageVerbose extends LogMessage {
  LogMessageVerbose({required super.timestamp, required super.level, required super.message});
}

/// Сообщение об ошибке (с stack trace)
class LogMessageError extends LogMessage {
  LogMessageError({required super.timestamp, required super.level, required super.message, required this.stackTrace});

  final StackTrace stackTrace;
}

/// Кастомный StreamTransformer для буферизации по времени
StreamTransformer<T, List<T>> bufferTimeTransformer<T>(Duration duration) {
  return StreamTransformer<T, List<T>>((input, cancelOnError) {
    StreamController<List<T>>? controller;
    Timer? timer;
    List<T> buffer = [];

    void emitBuffer() {
      if (buffer.isNotEmpty) {
        controller?.add(List<T>.from(buffer));
        buffer.clear();
      }
    }

    void scheduleEmit() {
      timer?.cancel();
      timer = Timer(duration, emitBuffer);
    }

    controller = StreamController<List<T>>(
      onListen: () {
        scheduleEmit();
      },
      onPause: () {
        timer?.cancel();
      },
      onResume: () {
        scheduleEmit();
      },
      onCancel: () {
        timer?.cancel();
        timer = null;
        buffer.clear();
        return Future.value();
      },
      sync: true,
    );

    input.listen(
      (T data) {
        buffer.add(data);
        if (timer == null || !timer!.isActive) {
          scheduleEmit();
        }
      },
      onError: controller.addError,
      onDone: () {
        emitBuffer();
        controller?.close();
      },
      cancelOnError: cancelOnError,
    );

    return controller.stream.listen(null);
  });
}

/// Singleton логгер с поддержкой потоков и буферизации
class Logger {
  static final Logger _instance = Logger._internal();
  final StreamController<LogMessage> _controller = StreamController<LogMessage>.broadcast();

  factory Logger() => _instance;

  Logger._internal() {
    // Настройка логирования в консоль в режиме отладки
    _controller.stream.listen((log) {
      final levelName = log.level.representation.padRight(3);
      final time = log.timestamp.toIso8601String().substring(11, 23);

      if (log is LogMessageError) {
        developer.log('[$levelName][$time] ${log.message}', time: log.timestamp, level: log.level.level, name: 'App', stackTrace: log.stackTrace);
      } else {
        developer.log('[$levelName][$time] ${log.message}', time: log.timestamp, level: log.level.level, name: 'App');
      }
    });
  }

  /// Основной метод логирования
  void _log(LogLevel level, Object message, [StackTrace? stackTrace]) {
    final logMessage = stackTrace != null
        ? LogMessageError(timestamp: DateTime.now(), level: level, message: message, stackTrace: stackTrace)
        : LogMessageVerbose(timestamp: DateTime.now(), level: level, message: message);

    _controller.add(logMessage);
  }

  /// Логирование с уровнем Verbose (уровень 1)
  void v(Object message) => _log(LogLevel.v, message);

  /// Логирование с уровнем Verbose 1 (уровень 2)
  void v1(Object message) => _log(LogLevel.v1, message);

  /// Логирование с уровнем Verbose 2 (уровень 3)
  void v2(Object message) => _log(LogLevel.v2, message);

  /// Логирование с уровнем Verbose 3 (уровень 4)
  void v3(Object message) => _log(LogLevel.v3, message);

  /// Логирование с уровнем Verbose 4 (уровень 5)
  void v4(Object message) => _log(LogLevel.v4, message);

  /// Логирование с уровнем Verbose 5 (уровень 6)
  void v5(Object message) => _log(LogLevel.v5, message);

  /// Логирование с уровнем Verbose 6 (уровень 7)
  void v6(Object message) => _log(LogLevel.v6, message);

  /// Логирование с уровнем Info (уровень 8)
  void i(Object message) => _log(LogLevel.i, message);

  /// Логирование с уровнем Warning (уровень 9)
  void w(Object message) => _log(LogLevel.w, message);

  /// Логирование с уровнем Error (уровень 10)
  void e(Object message, [StackTrace? stackTrace]) => _log(LogLevel.e, message, stackTrace);

  /// Логирование с уровнем WTF (What a Terrible Failure) (уровень 11)
  void wtf(Object message, [StackTrace? stackTrace]) => _log(LogLevel.wtf, message, stackTrace);

  /// Логирование с уровнем Silent (уровень 12) - обычно не используется
  void s(Object message) => _log(LogLevel.s, message);

  /// Поток сообщений лога
  Stream<LogMessage> get stream => _controller.stream;

  /// Метод map для преобразования сообщений
  Stream<R> map<R>(R Function(LogMessage) mapper) => stream.map(mapper);

  /// Буферизация сообщений по времени (альтернатива bufferTime из rxdart)
  Stream<List<T>> bufferTime<T>(Duration duration) {
    return stream.map<T>((log) => log as T).transform(bufferTimeTransformer(duration));
  }

  /// Альтернативный упрощенный метод для буферизации с фильтрацией
  Stream<List<LogMessage>> bufferWithFilter({Duration interval = const Duration(seconds: 5), bool Function(LogMessage)? filter}) async* {
    List<LogMessage> buffer = [];
    DateTime lastEmitTime = DateTime.now();

    await for (final log in stream) {
      if (filter == null || filter(log)) {
        buffer.add(log);
      }

      final now = DateTime.now();
      if (now.difference(lastEmitTime) >= interval && buffer.isNotEmpty) {
        yield List<LogMessage>.from(buffer);
        buffer.clear();
        lastEmitTime = now;
      }
    }

    // Эмитим оставшиеся логи при завершении потока
    if (buffer.isNotEmpty) {
      yield buffer;
    }
  }

  /// Закрытие контроллера (вызывать при завершении работы приложения)
  void dispose() {
    _controller.close();
  }
}

/// Глобальный экземпляр логгера (аналог 'l' из пакета l)
final Logger l = Logger();

/// Буфер для хранения логов (аналог LogBuffer)
class LogBuffer {
  static final LogBuffer _instance = LogBuffer._internal();
  final List<LogMessage> _buffer = [];
  static const int bufferLimit = 1000;

  factory LogBuffer() => _instance;

  LogBuffer._internal();

  /// Добавить сообщение в буфер
  void add(LogMessage message) {
    _buffer.add(message);
    if (_buffer.length > bufferLimit) {
      _buffer.removeRange(0, _buffer.length - bufferLimit);
    }
  }

  /// Добавить несколько сообщений в буфер
  void addAll(Iterable<LogMessage> messages) {
    _buffer.addAll(messages);
    if (_buffer.length > bufferLimit) {
      _buffer.removeRange(0, _buffer.length - bufferLimit);
    }
  }

  /// Получить все сообщения из буфера
  List<LogMessage> get all => List.unmodifiable(_buffer);

  /// Очистить буфер
  void clear() => _buffer.clear();

  /// Получить последние N сообщений
  List<LogMessage> getLast(int count) {
    if (count >= _buffer.length) {
      return List.unmodifiable(_buffer);
    }
    return List.unmodifiable(_buffer.sublist(_buffer.length - count));
  }
}

/// Глобальный экземпляр буфера логов
final LogBuffer logBuffer = LogBuffer();
