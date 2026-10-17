import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/package_name.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:shared_domain/shared_domain.dart';
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
  const GamePage({required this.launch, this.world, super.key});

  final GameLaunch launch;

  /// The world a [GameLaunch.world] launch plays.
  final WorldId? world;

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

typedef _Loaded = ({Progression progression, SavedRun? resumed});

class _GamePageState extends ConsumerState<GamePage> {
  /// Loaded once, before the game starts: the run is saved again after every
  /// move, and a reload mid-game would restart it; and a run's jokers are the
  /// ones it started with. A daily run needs neither.
  late final Future<_Loaded>? _loaded = widget.launch == .daily
      ? null
      : _load();

  @override
  Widget build(BuildContext context) {
    final loaded = _loaded;

    if (loaded == null) {
      return _ScopedGame(launch: widget.launch, world: widget.world);
    }

    return FutureBuilder(
      future: loaded,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) return const ColoredBox(color: DSColor.primary);

        return _ScopedGame(
          launch: widget.launch,
          progression: data.progression,
          resumed: data.resumed,
          world: widget.world,
        );
      },
    );
  }

  Future<_Loaded> _load() async {
    final resumed = widget.launch == .resume ? _loadResumed() : null;
    final progression = _loadProgression();

    return (progression: await progression, resumed: await resumed);
  }

  /// Played with a new player's jokers rather than stranded on a blank screen.
  Future<Progression> _loadProgression() async {
    // Both read up front: the page may be gone by the time the load fails.
    final load = ref.read(loadProgressionProvider);
    final newPlayer = ref.read(initialProgressionProvider);

    try {
      return await load();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The progression could not be loaded; starting jokers only',
        exception: error,
        stackTrace: stackTrace,
      );

      return newPlayer;
    }
  }

  /// Played on rather than stranded on a blank screen. Nothing is saved
  /// before the first move, so the run out of reach isn't overwritten unless
  /// the player plays on.
  Future<SavedRun?> _loadResumed() async {
    final load = ref.read(loadSavedRunProvider);

    try {
      return await load();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The saved run could not be loaded; playing today',
        exception: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }
}

/// The game screen, scoped to what it was opened for.
final class _ScopedGame extends StatelessWidget {
  const _ScopedGame({
    required this.launch,
    this.progression,
    this.resumed,
    this.world,
  });

  final GameLaunch launch;
  final Progression? progression;
  final SavedRun? resumed;
  final WorldId? world;

  @override
  Widget build(BuildContext context) {
    final progression = this.progression;

    return ProviderScope(
      overrides: [
        gameLaunchProvider.overrideWithValue(launch),
        if (progression != null)
          launchProgressionProvider.overrideWithValue(progression),
        launchedWorldProvider.overrideWithValue(world),
        resumedRunProvider.overrideWithValue(resumed),
      ],
      child: const GameWidget(),
    );
  }
}
