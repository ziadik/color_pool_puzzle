import 'dart:async';
import 'dart:developer';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => runZonedGuarded<void>(() => fn(), (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
