import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// The adapter that makes Dio traffic visible to an HTTP debugging proxy
/// (Proxyman, Charles), or null when none is configured.
///
/// A proxy has to be named here because Dart's `HttpClient` resolves `DIRECT`
/// on every platform — it never reads the system proxy the way native
/// networking does. That is why a proxy's automatic setup captures the WebView
/// and nothing Dio sends.
///
/// [proxy] is `host:port`, and is the address of the *proxy* only: the device
/// no longer dials the API, it hands the URL over to be resolved on the
/// proxy's machine.
///
/// The certificate check goes with it. A debugging proxy terminates TLS with
/// its own CA, so a proxied build cannot validate the chain — and `dart:io`
/// carries its own root store, so trusting the CA on the device would not help
/// either. Both halves are gated on [kDebugMode] so neither can reach a
/// release build even if a proxy were somehow configured into one.
IOHttpClientAdapter? proxyHttpClientAdapter(String? proxy) {
  if (!kDebugMode || proxy == null || proxy.isEmpty) return null;

  return IOHttpClientAdapter(
    createHttpClient: () => HttpClient()
      ..findProxy = ((_) => 'PROXY $proxy')
      ..badCertificateCallback = ((_, _, _) => true),
  );
}
