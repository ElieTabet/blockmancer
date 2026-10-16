import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_response.br.freezed.dart';

@freezed
abstract class NetworkResponse<T> with _$NetworkResponse<T> {
  const factory NetworkResponse({
    T? data,
    @Default({}) Map<String, String> headers,
    int? statusCode,
    String? statusMessage,
  }) = _NetworkResponse<T>;
}
