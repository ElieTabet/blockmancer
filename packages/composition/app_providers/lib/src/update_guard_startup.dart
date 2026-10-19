import 'package:app_update_presentation/app_update_presentation.dart'
    as app_update_ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Puts the update screen up whenever a minimum above this version is
/// published while the app is open, listened to for the app's life. The
/// splash still decides at launch.
void startUpdateGuard(ProviderContainer container) =>
    container.listen(app_update_ui.updateGuardProvider, (_, _) {});
