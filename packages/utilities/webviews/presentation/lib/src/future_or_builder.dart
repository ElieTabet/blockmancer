import 'dart:async';

import 'package:flutter/widgets.dart';

/// Builds from a value that may already be available.
///
/// A plain [FutureBuilder] always draws its loading state for one frame, even when
/// the value is synchronous — which for a webview means a flash before a URL that
/// never had to be awaited.
class FutureOrBuilder<T> extends StatelessWidget {
  final FutureOr<T> futureOr;
  final Widget Function(BuildContext context, T value) builder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;

  const FutureOrBuilder({
    required this.builder,
    required this.futureOr,
    this.errorBuilder,
    this.loadingBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (futureOr is T) {
      return builder(context, futureOr as T);
    }

    return FutureBuilder<T>(
      future: futureOr as Future<T>,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loadingBuilder?.call(context) ?? const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              const SizedBox.shrink();
        }

        return builder(context, snapshot.data as T);
      },
    );
  }
}
