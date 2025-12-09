import 'dart:async';
import 'logger.dart';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => runZonedGuarded<void>(() => fn(), l.e);
