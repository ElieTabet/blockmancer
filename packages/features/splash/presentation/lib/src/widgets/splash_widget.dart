import 'package:assets/assets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splash_presentation/src/notifiers/splash_state_notifier.br.dart';

final class SplashWidget extends ConsumerStatefulWidget {
  const SplashWidget({super.key});

  @override
  ConsumerState<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends ConsumerState<SplashWidget> {
  var _logoPrecached = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashStateProvider.notifier).onReady(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_logoPrecached) return;

    _logoPrecached = true;
    // The OS keeps its launch screen up until Flutter's first frame, so holding
    // that frame until the logo is decoded means the logo never blinks out.
    // A no-op once the first frame is out, e.g. when a lifted block returns here.
    final binding = WidgetsBinding.instance..deferFirstFrame();
    precacheImage(
      Assets.images.logo.provider(),
      context,
    ).whenComplete(binding.allowFirstFrame);
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    // Same colour and logo as the native launch screen, so the hand-off from
    // the OS screen to this one is invisible.
    backgroundColor: DSColor.primary,
    body: Center(child: _SplashLogo()),
  );
}

final class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  // Exactly what the native launch screen draws, so the hand-off is invisible:
  // flutter_native_splash scales the source ÷4, and the master is 1024px wide.
  // Tied to that master — if it is ever re-exported at another size, this has to
  // follow, or the logo will jump when the branded splash takes over.
  static const _logoWidth = 1024 / 4;

  @override
  Widget build(BuildContext context) => Assets.images.logo.image(
    width: _logoWidth,
    errorBuilder: (context, error, stackTrace) =>
        const SizedBox(width: _logoWidth),
  );
}
