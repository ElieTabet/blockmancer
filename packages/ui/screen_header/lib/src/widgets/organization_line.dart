import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_header/src/providers_di.br.dart' as di;

/// The organization's name, for a [ScreenHeader]'s second line.
///
/// A widget rather than a string the screen passes in, so the subscription sits
/// here: the name arriving from the server rebuilds this line, not the screen.
///
/// It carries its own gap, so a name not known yet leaves the band exactly as
/// it is with no second line at all.
final class OrganizationLine extends ConsumerWidget {
  const OrganizationLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(di.organizationNameProvider);

    if (name == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: DSSpace.xxsmall),
      child: Text(name),
    );
  }
}
