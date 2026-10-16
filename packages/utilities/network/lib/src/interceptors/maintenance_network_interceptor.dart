import 'package:network/src/error/network_error.br.dart';
import 'package:network/src/interceptors/network_interceptor.dart';
import 'package:network/src/models/network_request.br.dart';
import 'package:network/src/models/network_response.br.dart';

/// Told when the server says the Mobile API is in maintenance, with the plain
/// text it sent for the screen — null when it left the copy to the app.
typedef OnMaintenance = void Function(String? message);

/// Spots the API's maintenance answer — 503 `{"error": "maintenance"}` — on any
/// call, which is how a session already in progress learns the switch flipped.
///
/// It only tells; the error still travels on, so every caller fails the way it
/// already does and nothing has to learn a new outcome. Any other 503 is a plain
/// outage and is not maintenance.
final class MaintenanceNetworkInterceptor implements NetworkInterceptor {
  static const _maintenance = 'maintenance';

  final OnMaintenance _onMaintenance;

  static const _serviceUnavailable = 503;

  const MaintenanceNetworkInterceptor(this._onMaintenance);

  @override
  Future<void> onError(
    NetworkError error,
    NetworkErrorInterceptorHandler handler,
  ) async {
    if (error case NetworkServerError(
      statusCode: _serviceUnavailable,
      data: {'error': _maintenance} && final Map<dynamic, dynamic> body,
    )) {
      _onMaintenance(switch (body['message']) {
        final String message => message,
        _ => null,
      });
    }

    handler.next(error);
  }

  @override
  Future<void> onRequest(
    NetworkRequest request,
    NetworkRequestInterceptorHandler handler,
  ) async => handler.next(request);

  @override
  Future<void> onResponse(
    NetworkResponse<dynamic> response,
    NetworkResponseInterceptorHandler handler,
  ) async => handler.next(response);
}
