import 'dart:async';

import 'package:color_pool_puzzle/features/leaderboard/data/leaderboard_local_repository.dart';
import 'package:color_pool_puzzle/features/user/data/user_local_repository.dart';

import '../../../app/di/depends.dart';
import '../../../app/storage/storage_service.dart';
import '../../../features/user/domain/state/user_cubit.dart';
import '../../../app/utils/logger.dart';

/// Initializes the dependencies and returns a [Depends] object
Future<Depends> $initializeDepends({void Function(int progress, String message)? onProgress}) async {
  final dependencies = Depends();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;

  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.key);
      // Если у вас есть система логирования, можно добавить здесь
      l.v6('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      // Если у вас есть система логирования, можно добавить здесь
      l.e('Initialization failed at step "${step.key}": $error', stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }

  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(Depends dependencies);

final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  // 'Initialize Supabase Client': (dependencies) async {
  //   l.v('Initializing Supabase Client...');
  //   await SupabaseService.initialize();
  //   dependencies.supabaseClient = SupabaseService.client;
  //   l.i('Supabase Client initialized');
  // },
  'Initialize storage service': (dependencies) async {
    l.v('Initializing storage service...');
    dependencies.storageService = StorageService();
    await dependencies.storageService.init();
    l.i('Storage service initialized');
  },
  'Initialize leaderboard repository': (dependencies) {
    l.v('Initializing leaderboard repository...');
    dependencies.leaderRepository = LeaderboardLocalRepository();
    // dependencies.leaderRepository = LeaderboardSupabaseRepository(supabase: dependencies.supabaseClient);
    l.i('Leaderboard repository initialized');
  },
  'Initialize user repository': (dependencies) {
    l.v('Initializing user repository...');
    dependencies.userRepository = UserLocalRepository();
    // dependencies.userRepository = UserSupabaseRepository(supabase: dependencies.supabaseClient); //, storageService: dependencies.storageService);
    l.i('User repository initialized');
  },
  'Initialize user cubit': (dependencies) {
    l.v('Initializing user cubit...');
    dependencies.userCubit = UserCubit(repository: dependencies.userRepository);
    l.i('User cubit initialized');
  },
  'Collect logs': (dependencies) async {
    l.v('Setting up log collection...');

    // Настраиваем сбор важных логов в буфер
    l.stream.listen((log) {
      if (log.level.level >= LogLevel.w.level) {
        logBuffer.add(log);
      }
    });

    // Альтернативный способ буферизации (без rxdart)
    l.bufferWithFilter(interval: const Duration(seconds: 5), filter: (log) => log.level.level >= LogLevel.i.level).listen((logs) {
      if (logs.isNotEmpty) {
        // Обработка накопленных логов
        l.v('Collected ${logs.length} logs in batch (levels: ${logs.map((l) => l.level.representation).toSet()})');

        // Пример: можно сохранять в файл или отправлять на сервер
        // saveLogsToFile(logs);
      }
    });

    l.i('Log collection initialized');
  },
  'Log app initialized': (_) {
    l.i('🚀 Application initialization completed successfully');
  },
};
