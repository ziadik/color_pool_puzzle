import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../di/di_container.dart';
import '../di/depends.dart';

/// Удобный доступ к контейнеру зависимостей
/// из любого места приложения через BuildContext
extension ContextExt on BuildContext {
  // DiContainer get di => DiContainer.of(this); <- Удалить
  Depends get di => DiContainer.of(this).depends;
  AppLocalizations get l10n => AppLocalizations.of(this);
}
