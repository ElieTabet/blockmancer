// screen_header — the band every main screen wears: its title, an optional
// subtitle, and the one control a session needs.
//
// It sits outside `features/` because more than one feature draws it, and
// outside `design_system` because it watches the session and reads
// translations — neither of which that package is allowed to know.
export 'src/providers.br.dart';
export 'src/routing/screen_header_routing.dart';
export 'src/widgets/organization_line.dart';
export 'src/widgets/screen_header.dart';
export 'src/widgets/session_action_button.dart';
