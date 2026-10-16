import 'package:external_links/src/package_name.dart';
import 'package:flutter/services.dart';
import 'package:timber/timber.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a link from an announcement's body in whatever the device browses
/// with, and answers whether it went.
///
/// Anything but http or https is refused outright: an announcement is authored
/// in a CMS, and a `tel:`, `mailto:` or custom scheme the app never meant to
/// honour should do nothing rather than hand the device an intent nobody
/// reviewed. The refusal lives here rather than in `news` because this package
/// is what knows a link is about to leave the app — the feature only knows it
/// has one.
///
/// The catches are the one kind this codebase allows: the boundary is the
/// operating system, and it refuses a launch for reasons the app cannot
/// enumerate — no browser installed, a policy on a managed device. Without them
/// the throw lands in the renderer's `await` as an unhandled async error, and a
/// tap that failed is indistinguishable from a tap that was never wired.
///
/// [MissingPluginException] is caught beside [PlatformException] and is not the
/// same failure: it means url_launcher is not in this binary at all, which a
/// native build one plugin behind the Dart code produces. It is not a subtype
/// of [PlatformException], so naming only that one let exactly the failure this
/// docblock claims to cover escape unlogged.
Future<bool> openExternalUrl(String url) async {
  final target = Uri.tryParse(url);

  if (target == null) return false;

  if (!target.isScheme('http') && !target.isScheme('https')) {
    Timber.d(
      tag: packageName,
      logMessage: 'Refused a link that was not http or https',
    );

    return false;
  }

  try {
    return await launchUrl(target, mode: .externalApplication);
  } on PlatformException catch (error, stackTrace) {
    return _launchFailed(
      error,
      'Opening a link outside the app failed',
      stackTrace,
    );
  } on MissingPluginException catch (error, stackTrace) {
    return _launchFailed(
      error,
      'Opening a link outside the app failed',
      stackTrace,
    );
  }
}

/// Opens a mail draft, and answers whether one opened.
///
/// Separate from [openExternalUrl] on purpose, rather than the one launcher
/// with a wider allowlist. That one refuses every scheme but http and https
/// because the links it carries are authored in a CMS — `mailto:` is named in
/// its own docblock as one of the schemes it exists to stop. An address the app
/// built itself is the opposite case, so the two have opposite jobs and the
/// guard stays as strict as it was written to be.
///
/// The same two catches, for the same reason: no mail app configured is
/// ordinary, not exceptional, and the caller shows the address instead when
/// this answers false.
Future<bool> composeEmail(Uri mailto) async {
  if (!mailto.isScheme('mailto')) return false;

  try {
    return await launchUrl(mailto);
  } on PlatformException catch (error, stackTrace) {
    return _launchFailed(error, 'Could not open a mail draft', stackTrace);
  } on MissingPluginException catch (error, stackTrace) {
    return _launchFailed(error, 'Could not open a mail draft', stackTrace);
  }
}

/// Reports a launch the operating system would not perform, and answers the
/// `false` both callers hand back.
///
/// The URL itself is deliberately absent: a link in an announcement can carry
/// anything, and a log line is not the place for it.
bool _launchFailed(Object error, String message, StackTrace stackTrace) {
  Timber.e(
    tag: packageName,
    logMessage: message,
    exception: error,
    stackTrace: stackTrace,
  );

  return false;
}
