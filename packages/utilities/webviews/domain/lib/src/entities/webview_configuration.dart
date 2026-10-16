import 'dart:async';

import 'package:webviews_domain/src/entities/javascript_bridge.dart';
import 'package:webviews_domain/src/entities/webview_errors.br.dart';

typedef NavigationPredicate = bool Function(String url);

typedef OnPageFinished = void Function(String? url);

typedef OnWebViewError = void Function(WebviewError error);

sealed class WebViewConfiguration {
  const WebViewConfiguration({
    required this.javascriptBridges,
    this.allowsBackdropBlur = false,
    this.allowsInlineMediaPlayback = false,
    this.compositeInScene = false,
    this.identifyAsNativeApp = false,
    this.onCreateWindow,
    this.onError,
    this.onJsAlert,
    this.onJsConfirm,
    this.onJsPrompt,
    this.onPageFinished,
    this.preventFullscreen = false,
    this.shouldOverrideUrlLoading,
    this.useWideViewPort = true,
  });

  /// Lets Flutter widgets painted above the webview (e.g. a `BackdropFilter`
  /// blur) sample its pixels on Android, by compositing the webview inside
  /// Flutter's scene (Virtual Display) instead of as a separate native overlay
  /// (Hybrid Composition, the default). No effect on iOS.
  ///
  /// Off by default: Virtual Display has known IME / text-selection / a11y
  /// trade-offs, so only enable it where a blur over the webview is required.
  final bool allowsBackdropBlur;

  /// Lets embedded media play inline and autoplay without a user gesture (iOS `allowsInlineMediaPlayback`
  /// + no `mediaPlaybackRequiresUserGesture`) — needed to auto-start video, which iOS blocks by default.
  final bool allowsInlineMediaPlayback;

  /// Composites the webview inside Flutter's scene (Virtual Display) instead of
  /// as a native overlay (Hybrid Composition, the default) on Android — same
  /// mechanism as [allowsBackdropBlur] but for a performance reason rather than
  /// a blur one. A native overlay forces the engine to re-composite the whole
  /// Flutter view every frame through the external view embedder — a standing
  /// raster cost even for a 0×0 offscreen webview — which stutters animations
  /// running around a mounted-but-invisible webview. An in-scene texture has no
  /// such per-frame tax. Enable for a webview that stays mounted while mostly
  /// invisible/non-interactive. Trades away the IME / text-selection / a11y
  /// fidelity of Hybrid Composition — fine for tap-only content. No effect on iOS.
  final bool compositeInScene;

  final bool identifyAsNativeApp;

  final List<JavascriptBridge<dynamic>> javascriptBridges;

  final Future<bool> Function(String url)? onCreateWindow;

  final OnWebViewError? onError;

  final Future<bool> Function(String message)? onJsAlert;
  final Future<bool> Function(String message)? onJsConfirm;
  final Future<String?> Function(String message, String defaultValue)?
  onJsPrompt;

  final OnPageFinished? onPageFinished;

  final bool preventFullscreen;

  final NavigationPredicate? shouldOverrideUrlLoading;

  final bool useWideViewPort;
}

class WebViewConfigurationFromUrl extends WebViewConfiguration {
  const WebViewConfigurationFromUrl({
    required this.url,
    required super.javascriptBridges,
    super.allowsBackdropBlur,
    super.allowsInlineMediaPlayback,
    super.compositeInScene,
    super.identifyAsNativeApp,
    super.onCreateWindow,
    super.onError,
    super.onJsAlert,
    super.onJsConfirm,
    super.onJsPrompt,
    super.onPageFinished,
    super.preventFullscreen,
    super.shouldOverrideUrlLoading,
    super.useWideViewPort,
  });

  /// A [Future] here is resolved once, when the widget mounts — the loading and
  /// error widgets cover that resolution.
  final FutureOr<String> url;
}

class WebViewConfigurationFromData extends WebViewConfiguration {
  const WebViewConfigurationFromData({
    required this.htmlData,
    required super.javascriptBridges,
    super.allowsBackdropBlur,
    super.allowsInlineMediaPlayback,
    super.compositeInScene,
    this.baseUrl,
    super.onCreateWindow,
    super.onError,
    super.onJsAlert,
    super.onJsConfirm,
    super.onJsPrompt,
    super.onPageFinished,
    super.preventFullscreen,
    super.shouldOverrideUrlLoading,
    super.useWideViewPort,
  });

  final FutureOr<String> htmlData;
  final String? baseUrl;
}

/// A document already on this device, rendered from the filesystem.
///
/// Separate from [WebViewConfigurationFromUrl] rather than a `file://` string
/// passed through it, because a local document needs something a remote one has
/// no concept of: a directory it is allowed to read. iOS enforces
/// [readAccessRoot] natively, and it is the only real confinement available —
/// [shouldOverrideUrlLoading] judges main-frame navigations only, never the
/// subresource loads that make up most of a page.
class WebViewConfigurationFromLocalFile extends WebViewConfiguration {
  const WebViewConfigurationFromLocalFile({
    required this.filePath,
    required this.readAccessRoot,
    required super.javascriptBridges,
    super.allowsInlineMediaPlayback,
    super.onError,
    super.onJsAlert,
    super.onJsConfirm,
    super.onJsPrompt,
    super.onPageFinished,
    super.preventFullscreen,
    super.shouldOverrideUrlLoading,
    super.useWideViewPort,
  });

  /// Absolute path of the document to render. A plain [String], not a
  /// [FutureOr]: unlike a URL, this is only knowable once the bytes are already
  /// on disk, so there is nothing left to wait for.
  final String filePath;

  /// The directory the page may read from. Everything the document pulls in has
  /// to live under it.
  final String readAccessRoot;
}
