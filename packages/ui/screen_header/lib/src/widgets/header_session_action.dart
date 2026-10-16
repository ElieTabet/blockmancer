import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_header/src/providers_di.br.dart' as di;
import 'package:screen_header/src/widgets/session_action_button.dart';

/// The band's trailing slot: a way in for a guest, and nothing at all for a
/// member.
///
/// Signing *out* is deliberately absent. It lives on the account page, which is
/// the screen about the account — and a copy of it in the band on every tab was
/// three places to answer one question, two of which a member passes through on
/// the way to something else.
///
/// Its own widget rather than a branch inside [ScreenHeader] so the session
/// subscription sits in the leaf: a sign-in redraws this slot, not the title
/// beside it, and the header itself stays `const`.
final class HeaderSessionAction extends ConsumerWidget {
  const HeaderSessionAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(
      di.isAuthenticatedProvider.select((session) => session.value),
    );

    // Null is "not known yet", which draws nothing for the same reason a member
    // does: the band must never show the wrong verb for a frame.
    if (isAuthenticated != false) return const SizedBox.shrink();

    // The spacer belongs to the slot, not the row: left in the header it would
    // pad a band that has nothing at the end of it.
    return const Row(
      mainAxisSize: .min,
      children: [DSHorizontalSpace.small, SessionActionButton()],
    );
  }
}
