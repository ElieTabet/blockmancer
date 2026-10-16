import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timber/timber.dart';
import 'package:webviews_domain/webviews_domain.dart';
import 'package:webviews_presentation/src/configuration/resolve_webview_ui_configuration.dart';
import 'package:webviews_presentation/src/configuration/webview_ui_configuration.br.dart';
import 'package:webviews_presentation/src/future_or_builder.dart';
import 'package:webviews_presentation/src/package_name.dart';
import 'package:webviews_presentation/src/providers_di.br.dart' as di;
import 'package:webviews_presentation/src/server_trust.dart';
import 'package:webviews_presentation/src/webview_keep_alive.dart';
import 'package:webviews_presentation/src/webview_navigation_policy.dart';
import 'package:webviews_presentation/src/webview_url_redaction.dart';

part 'webview_javascript.dart';
part 'webview_js_dialog_handler.dart';
part 'webview_url_handler.dart';

class Webview extends ConsumerStatefulWidget {
  final WebViewConfiguration configuration;
  final WebviewController? controller;
  final Widget? errorWidget;

  /// When false, the webview claims no gestures, so touches reach whatever is behind/around it instead
  /// of the page — used for an inert preview. When true (default) it eagerly grabs every touch in its
  /// area, as a normal interactive page does.
  final bool interactive;

  /// Leaves drags to an enclosing scrollable while taps still reach the page.
  ///
  /// For a page embedded in a scrolling host that does not scroll internally: the default
  /// [EagerGestureRecognizer] claims every touch the moment it lands, so a drag started anywhere over
  /// the page is swallowed and the host does not move — the reader has to find a gap beside the
  /// webview to scroll at all. Claiming taps alone leaves the vertical drag to lose the arena, so the
  /// host scrolls, and a page that does scroll internally would stop being able to.
  ///
  /// Ignored when [interactive] is false, which already claims nothing.
  final bool scrollsWithHost;

  /// Keeps the underlying native webview alive across widget disposal, so its loaded page is
  /// re-attached rather than reloaded when this [Webview] re-mounts. Pass the same instance to
  /// re-attach to the same webview.
  final WebviewKeepAlive? keepAlive;
  final Widget? loadingWidget;

  /// Reports how tall the page's content actually is, in logical pixels, so a host sizing a slot
  /// around it can shrink to what was drawn instead of reserving a fixed block.
  ///
  /// Measured in the page and pushed out on every change, because neither platform hands it over the
  /// same way: the plugin's own `onContentSizeChanged` is iOS-only (it forwards
  /// `WKWebView.scrollView.contentSize`), and Android's `getContentHeight` is a pull that says nothing
  /// about when it changed. A `ResizeObserver` on the document is one mechanism reporting the same
  /// number on both, and it keeps reporting as the page reflows rather than answering once on load.
  final ValueChanged<double>? onContentHeightChanged;

  /// Page body must be transparent too.
  final bool transparentBackground;

  const Webview({
    required this.configuration,
    this.controller,
    this.errorWidget,
    this.interactive = true,
    this.keepAlive,
    this.loadingWidget,
    this.onContentHeightChanged,
    this.scrollsWithHost = false,
    this.transparentBackground = false,
    super.key,
  });

  @override
  ConsumerState<Webview> createState() => _WebviewState();
}

class _WebviewState extends ConsumerState<Webview> {
  InAppWebViewController? _controller;

  /// Resolved once per configuration rather than per build: an asynchronous URL would otherwise be
  /// re-awaited on every rebuild, and the widget would flash its loading state each time.
  late FutureOr<WebViewUiConfiguration> _uiConfiguration;

  WebViewConfiguration get _configuration => widget.configuration;

  @override
  void initState() {
    super.initState();
    _uiConfiguration = resolveWebviewUiConfiguration(_configuration);
  }

  @override
  Widget build(BuildContext context) {
    final untrustedCertificatesAllowed = ref.watch(
      di.untrustedWebviewCertificatesAllowedProvider,
    );
    final serverTrustResponse = serverTrustAuthResponse(
      untrustedCertificatesAllowed: untrustedCertificatesAllowed,
    );

    return FutureOrBuilder<WebViewUiConfiguration>(
      futureOr: _uiConfiguration,
      builder: (context, configuration) => _buildWebView(
        configuration: configuration,
        serverTrustResponse: serverTrustResponse,
      ),
      errorBuilder: (context, error) =>
          widget.errorWidget ?? const SizedBox.shrink(),
      loadingBuilder: (context) =>
          widget.loadingWidget ?? const SizedBox.shrink(),
    );
  }

  /// Makes the page itself ignore input when the webview is inert, and accept it again when it is not.
  ///
  /// Inertness needs two layers, and a Flutter-side barrier — `AbsorbPointer`, `IgnorePointer`, or an
  /// overlay that swallows taps — only provides the first:
  ///
  /// 1. **Who wins the gesture** is decided in Flutter's arena, by the empty `gestureRecognizers` below:
  ///    the platform view claims nothing, so the host's own handler takes the tap. A barrier does the
  ///    same job, and for a plain Flutter subtree it would be enough on its own.
  /// 2. **What the page does with a touch it still receives** is not Flutter's to decide. The embedded
  ///    webview is a native view with its own touch handling; a barrier sits *above* it in the Flutter
  ///    tree and cannot reach inside the document. In practice a kept-alive native view re-attached
  ///    from an interactive slot keeps reacting to touches — scrolling and pressing inside the page —
  ///    even with the host swallowing the gesture, which is the failure this call fixes.
  ///
  /// So the barrier decides who *handles* the tap, and this decides whether the page *reacts* to it.
  /// The element may not exist yet on a freshly created view, hence the guard.
  Future<void> _applyPointerEvents(
    InAppWebViewController controller,
  ) => controller.evaluateJavascript(
    source:
        'if (document.documentElement) '
        "document.documentElement.style.pointerEvents = '${widget.interactive ? '' : 'none'}';",
  );

  Widget _buildWebView({
    required WebViewUiConfiguration configuration,
    required ServerTrustAuthResponse? serverTrustResponse,
  }) => InAppWebView(
    keepAlive: widget.keepAlive?.delegate,
    // Eagerly claim every touch when interactive; claim taps alone when the host owns the scroll, so a
    // drag over the page loses the arena to it; claim nothing for an inert preview, so the surrounding
    // shell handles the gesture instead of the page.
    gestureRecognizers: switch ((
      interactive: widget.interactive,
      scrollsWithHost: widget.scrollsWithHost,
    )) {
      (interactive: false, scrollsWithHost: _) =>
        const <Factory<OneSequenceGestureRecognizer>>{},
      (interactive: true, scrollsWithHost: true) => const {
        Factory<TapGestureRecognizer>(TapGestureRecognizer.new),
      },
      (interactive: true, scrollsWithHost: false) => const {
        Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new),
      },
    },
    initialUrlRequest: configuration.initialUrlRequest,
    initialData: configuration.initialData,
    initialSettings: _settings,
    initialUserScripts: _initialUserScripts,
    onWebViewCreated: (controller) {
      _controller = controller;
      _registerJavascriptBridges(controller);
      widget.controller?.attach(controller.toJavascriptEvaluator());
      // Both directions on attach: a kept-alive view carries its document — and so its previous
      // pointer-events value — from slot to slot, so moving inert -> interactive must clear it again.
      unawaited(_applyPointerEvents(controller));
    },
    onLoadStop: (controller, url) {
      Timber.d(
        tag: packageName,
        logMessage: 'onLoadStop: ${redactUrlForLog(url?.toString() ?? '')}',
      );
      // A load swaps `document.documentElement`, dropping the inline style set at attach time, so an
      // inert view has to re-assert it. The interactive case needs nothing: a fresh document starts
      // without the style, and re-asserting it here would put a JS eval on every page load app-wide.
      if (!widget.interactive) unawaited(_applyPointerEvents(controller));

      _configuration.onPageFinished?.call(url?.toString());
    },
    shouldOverrideUrlLoading: (_, navigationAction) =>
        _handleShouldOverrideUrlLoading(navigationAction),
    onJsAlert: _configuration.onJsAlert != null ? _handleJsAlert : null,
    onJsConfirm: _configuration.onJsConfirm != null ? _handleJsConfirm : null,
    onJsPrompt: _configuration.onJsPrompt != null ? _handleJsPrompt : null,
    onCreateWindow: _configuration.onCreateWindow != null
        ? _handleCreateWindow
        : null,
    onConsoleMessage: (controller, consoleMessage) {
      Timber.d(
        tag: packageName,
        logMessage: 'Console: ${consoleMessage.message}',
      );
    },
    onReceivedError: (controller, request, error) {
      _configuration.onError?.call(
        WebviewError.runtimeError(
          requestUrl: request.url.toString(),
          description: error.description,
          isMainFrame: request.isForMainFrame ?? true,
        ),
      );
    },
    onReceivedHttpError: (controller, request, errorResponse) {
      _configuration.onError?.call(
        WebviewError.httpError(
          requestUrl: request.url.toString(),
          statusCode: errorResponse.statusCode,
          isMainFrame: request.isForMainFrame ?? true,
        ),
      );
    },
    onReceivedServerTrustAuthRequest: serverTrustResponse == null
        ? null
        : (_, _) async => serverTrustResponse,
  );

  @override
  void didUpdateWidget(covariant Webview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.configuration != widget.configuration) {
      _uiConfiguration = resolveWebviewUiConfiguration(_configuration);
    }

    if (oldWidget.controller != widget.controller) {
      if (_controller case final controller?) {
        widget.controller?.attach(controller.toJavascriptEvaluator());
      }
      oldWidget.controller?.detach();
    }
  }

  @override
  void dispose() {
    if (_controller case final controller?) {
      _unregisterJavascriptBridges(controller);
    }
    widget.controller?.detach();
    super.dispose();
  }

  /// The directory a local document may read from, or null for anything else.
  ///
  /// On iOS this is load-bearing rather than a hardening extra: the plugin only
  /// takes WKWebView's `loadFileURL(_:allowingReadAccessTo:)` path when this
  /// setting is present, and a plain `load(URLRequest)` of a `file://` URL is
  /// refused outright.
  WebUri? get _readAccessRoot => switch (_configuration) {
    WebViewConfigurationFromLocalFile(:final readAccessRoot) => WebUri(
      Uri.directory(readAccessRoot).toString(),
    ),
    _ => null,
  };

  InAppWebViewSettings get _settings => InAppWebViewSettings(
    // Left off for everything else, so a remote page can never reach the
    // filesystem. `allowFileAccessFromFileURLs` and its universal counterpart
    // stay off in both cases — the bundle contract requires it, which is why a
    // document may use `<script src>` and `<link>` but not `fetch` or modules.
    allowFileAccess: _readAccessRoot != null,
    allowingReadAccessTo: _readAccessRoot,
    allowsInlineMediaPlayback: _configuration.allowsInlineMediaPlayback,
    applePayAPIEnabled: false,
    applicationNameForUserAgent: _configuration.identifyAsNativeApp
        ? _nativeAppUserAgentMarker
        : '',
    javaScriptEnabled: true,
    mediaPlaybackRequiresUserGesture: !_configuration.allowsInlineMediaPlayback,
    supportMultipleWindows: _configuration.onCreateWindow != null,
    transparentBackground: widget.transparentBackground,
    useHybridComposition:
        !(_configuration.allowsBackdropBlur || _configuration.compositeInScene),
    useShouldOverrideUrlLoading:
        _configuration.shouldOverrideUrlLoading != null,
    useWideViewPort: _configuration.useWideViewPort,
  );

  UnmodifiableListView<UserScript>
  get _initialUserScripts => UnmodifiableListView([
    if (_configuration.preventFullscreen)
      UserScript(
        source: _preventFullscreenScriptSource,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        forMainFrameOnly: false, // injects into iframes too
      ),
    if (widget.onContentHeightChanged != null)
      UserScript(
        source: _reportContentHeightScriptSource,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        // The main frame's document is what the host sizes to; an iframe reporting its own height
        // would race the page's and win half the time.
        forMainFrameOnly: true,
      ),
  ]);
}

const _contentHeightHandlerName = 'appWebviewContentHeight';

/// Reports how far down the page actually drew, on every reflow.
///
/// The union of the body's children, not `scrollHeight`: a page whose `body` fills the viewport
/// reports back exactly the height it was given, so a host that over-reserved would measure its own
/// guess and never shrink. The children are laid out to their content whatever the body does, so their
/// lowest edge is the only honest answer. Nothing is reported when there is nothing laid out, which
/// leaves the host on the height it chose rather than collapsing it.
///
/// Children are observed one by one, and a mutation observer re-arms that list: a body pinned to the
/// viewport never resizes itself, so an observer watching only the body would never fire. The interval
/// covers what neither sees — a page with no `ResizeObserver`, and a child that moves without resizing,
/// since the measurement reads positions and `ResizeObserver` only watches boxes.
const _reportContentHeightScriptSource =
    '''
(function(){
  var last = 0;
  var observer = window.ResizeObserver ? new ResizeObserver(function(){ report(); }) : null;

  function measure() {
    var body = document.body;
    if (!body) return 0;

    var bottom = 0;
    var children = body.children;
    for (var i = 0; i < children.length; i++) {
      var rect = children[i].getBoundingClientRect();
      if (rect.width <= 0 && rect.height <= 0) continue;
      var candidate = rect.bottom + (window.scrollY || 0);
      if (candidate > bottom) bottom = candidate;
    }
    return Math.ceil(bottom);
  }

  function report() {
    var height = measure();
    if (!height || Math.abs(height - last) < 1) return;
    last = height;
    window.flutter_inappwebview.callHandler('$_contentHeightHandlerName', height);
  }

  function observeChildren() {
    if (!observer || !document.body) return;
    observer.disconnect();
    var children = document.body.children;
    for (var i = 0; i < children.length; i++) observer.observe(children[i]);
  }

  function start() {
    observeChildren();
    report();
    if (window.MutationObserver && document.body) {
      new MutationObserver(function(){ observeChildren(); report(); })
        .observe(document.body, { childList: true, subtree: false });
    }
    setInterval(report, 200);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', start);
  } else {
    start();
  }
  window.addEventListener('load', report);
})();
''';

String get _nativeAppUserAgentMarker => switch (defaultTargetPlatform) {
  TargetPlatform.iOS => 'nativeios',
  _ => 'nativeandroid',
};

const _preventFullscreenScriptSource = '''
(function(){
  var noop = function(){ return Promise.resolve(); };
  ['requestFullscreen','webkitRequestFullscreen','webkitRequestFullScreen','mozRequestFullScreen','msRequestFullscreen']
    .forEach(function(name){ if (name in Element.prototype) { Element.prototype[name] = noop; } });
  ['exitFullscreen','webkitExitFullscreen','webkitCancelFullScreen','mozCancelFullScreen','msExitFullscreen']
    .forEach(function(name){ try { if (name in document) { document[name] = noop; } } catch (e) {} });
})();
''';

extension on InAppWebViewController {
  JavascriptEvaluator toJavascriptEvaluator() =>
      (source) async => (await evaluateJavascript(source: source))?.toString();
}
