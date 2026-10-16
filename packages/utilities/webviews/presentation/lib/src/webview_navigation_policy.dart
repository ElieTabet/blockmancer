import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webviews_domain/webviews_domain.dart';

/// Resolves the policy for a webview navigation.
///
/// Sub-frame (iframe) navigations are part of the current page. To avoid applying the host
/// allowlist of [shouldOverrideUrlLoading] to embedded content, the policy is only enforced
/// on main-frame navigations.
NavigationActionPolicy resolveNavigationPolicy({
  required bool isForMainFrame,
  required NavigationPredicate? shouldOverrideUrlLoading,
  required String url,
}) {
  if (!isForMainFrame) {
    return NavigationActionPolicy.ALLOW;
  }

  final predicate = shouldOverrideUrlLoading;

  if (predicate != null) {
    return predicate(url)
        ? NavigationActionPolicy.ALLOW
        : NavigationActionPolicy.CANCEL;
  }

  return NavigationActionPolicy.ALLOW;
}
