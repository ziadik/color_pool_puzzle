import 'dart:async';

import '../../../app/di/depends.dart';
import '../../../app/http/base_http_client.dart';
import '../../../app/storage/storage_service.dart';
import '../../../features/user/data/user_repository.dart';
import '../../../features/user/domain/state/user_cubit.dart';
import '../../leaderboard/data/leaderboard_repository.dart';

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
      print('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      // Если у вас есть система логирования, можно добавить здесь
      print('Initialization failed at step "${step.key}": $error');
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }

  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(Depends dependencies);

final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  // Убраны шаги, связанные с удаленными импортами
  'Initialize HTTP Client': (dependencies) {
    dependencies.httpClient = BaseHttpClient();
  },
  'Initialize storage service': (dependencies) async {
    dependencies.storageService = StorageService();
    await dependencies.storageService.init();
  },
  'Initialize leaderboard repository': (dependencies) {
    dependencies.leaderRepository = LeaderboardRepository(httpClient: dependencies.httpClient);
  },
  'Initialize user repository': (dependencies) {
    dependencies.userRepository = UserRepository(httpClient: dependencies.httpClient, storageService: dependencies.storageService);
  },
  'Initialize user cubit': (dependencies) {
    dependencies.userCubit = UserCubit(repository: dependencies.userRepository);
  },
};
