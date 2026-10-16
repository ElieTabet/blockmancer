import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_state_notifier.br.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:screen_header/screen_header.dart';

/// The app's first tab: the shared header over a placeholder for the app's own
/// main screen.
///
/// Stateful because arriving here is the moment to ask about notifications —
/// splash would put the prompt over a transition, and login is skipped by
/// whoever already has a session.
final class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  @override
  void initState() {
    super.initState();
    // After the first frame, so the prompt lands over a drawn screen rather
    // than over the transition onto it.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(homeStateProvider.notifier).onShown(),
    );
  }

  @override
  // The band runs under the status bar, so the clock has to be light.
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.charcoal,
      body: Column(
        children: [
          ScreenHeader(
            title: context.t.home.title,
            // No login screen, so no one to sign in or out.
            showSessionAction: false,
            subtitle: const OrganizationLine(),
          ),
          const Expanded(child: _Placeholder()),
        ],
      ),
    ),
  );
}

final class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const .all(DSSpace.large),
      child: Text(
        context.t.home.placeholder,
        textAlign: .center,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: DSColor.cloud),
      ),
    ),
  );
}
