import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_presentation/src/webview_navigation_policy.dart';

bool _allowHost(String _) => true;

bool _rejectHost(String _) => false;

void main() {
  group('Navigating inside a webview', () {
    test(
      'Given a webview whose allowlist would reject an embedded host '
      'When that host loads inside an embedded frame '
      'Then the embedded content keeps loading inside the webview',
      () => expect(
        resolveNavigationPolicy(
          isForMainFrame: false,
          shouldOverrideUrlLoading: _rejectHost,
          url: 'https://checkout.example.com',
        ),
        NavigationActionPolicy.ALLOW,
      ),
    );

    test(
      'Given a webview whose allowlist rejects external hosts '
      'When the page itself navigates to a rejected host '
      'Then the navigation is handed off instead of loading inside the webview',
      () => expect(
        resolveNavigationPolicy(
          isForMainFrame: true,
          shouldOverrideUrlLoading: _rejectHost,
          url: 'https://checkout.example.com',
        ),
        NavigationActionPolicy.CANCEL,
      ),
    );

    test(
      'Given a webview whose allowlist accepts the host '
      'When the page itself navigates to an allowed host '
      'Then the page keeps loading inside the webview',
      () => expect(
        resolveNavigationPolicy(
          isForMainFrame: true,
          shouldOverrideUrlLoading: _allowHost,
          url: 'https://app.example.com',
        ),
        NavigationActionPolicy.ALLOW,
      ),
    );

    test(
      'Given a webview with no navigation policy configured '
      'When the page itself navigates '
      'Then the page keeps loading inside the webview',
      () => expect(
        resolveNavigationPolicy(
          isForMainFrame: true,
          shouldOverrideUrlLoading: null,
          url: 'https://app.example.com',
        ),
        NavigationActionPolicy.ALLOW,
      ),
    );
  });
}
