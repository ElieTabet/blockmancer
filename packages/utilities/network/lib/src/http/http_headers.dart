import 'package:flutter/foundation.dart';

/// Value-equality wrapper over a header map, so headers can be compared and
/// used as part of a provider key without identity churn.
@immutable
class HttpHeaders {
  static const empty = HttpHeaders._({});

  final Map<String, dynamic> _headers;

  const HttpHeaders._(this._headers);

  factory HttpHeaders.from(Map<String, dynamic> headers) =>
      HttpHeaders._(Map.unmodifiable(headers));

  Map<String, dynamic> toMap() => _headers;

  HttpHeaders merge(HttpHeaders headers) =>
      HttpHeaders._(Map.from(_headers)..addAll(headers._headers));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpHeaders &&
          runtimeType == other.runtimeType &&
          mapEquals(_headers, other._headers);

  @override
  int get hashCode => _headers.entries.fold(
    0,
    (hashcode, element) =>
        element.key.hashCode + ((element.value as Object?)?.hashCode ?? 0),
  );
}
