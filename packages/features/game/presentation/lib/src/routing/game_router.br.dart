import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/package_name.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:timber/timber.dart';

part 'game_router.br.gr.dart';

/// Path for the game feature's route. Absolute: the game is pushed over the
/// tab shell, not one of its tabs.
enum GameRoutePath {
  game('/game');

  const GameRoutePath(this.path);

  final String path;
}

// Empty codegen anchor — auto_route generates the route from the @RoutePage
// class below. The actual route table is declared once by AppRouter
// (composition), never per feature.
@AutoRouterConfig()
abstract class GameRouter extends RootStackRouter {}

@RoutePage(name: 'GameRoute')
final class GamePage extends ConsumerStatefulWidget {
  const GamePage({required this.launch, super.key});

  final GameLaunch launch;

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  /// Loaded once, before the game starts: the run is saved again after every
  /// move, and a reload mid-game would restart it.
  late final Future<SavedRun?>? _resumed = widget.launch == .resume
      ? ref.read(loadSavedRunProvider)()
      : null;

  @override
  Widget build(BuildContext context) {
    final resumed = _resumed;

    if (resumed == null) return _ScopedGame(launch: widget.launch);

    return FutureBuilder(
      future: resumed,
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done) {
          return const ColoredBox(color: DSColor.primary);
        }

        // Played on rather than stranded on a blank screen. Nothing is saved
        // before the first move, so the run out of reach isn't overwritten
        // unless the player plays on.
        if (snapshot.hasError) {
          Timber.e(
            tag: packageName,
            logMessage: 'The saved run could not be loaded; playing today',
            exception: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }

        return _ScopedGame(launch: widget.launch, resumed: snapshot.data);
      },
    );
  }
}

/// The game screen, scoped to what it was opened for.
final class _ScopedGame extends StatelessWidget {
  const _ScopedGame({required this.launch, this.resumed});

  final GameLaunch launch;
  final SavedRun? resumed;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      gameLaunchProvider.overrideWithValue(launch),
      resumedRunProvider.overrideWithValue(resumed),
    ],
    child: const GameWidget(),
  );
}
