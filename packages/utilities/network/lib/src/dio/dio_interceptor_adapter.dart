import 'package:dio/dio.dart';
import 'package:network/src/dio/dio_exception_mapper.dart';
import 'package:network/src/error/network_error.br.dart';
import 'package:network/src/interceptors/network_interceptor.dart';
import 'package:network/src/models/network_request.br.dart';
import 'package:network/src/models/network_response.br.dart';
import 'package:network/src/package_name.dart';
import 'package:timber/timber.dart';

/// Bridges Dio's own interceptor into the transport-agnostic
/// [NetworkInterceptor] chain across all three phases.
class DioToNetworkInterceptorAdapter extends Interceptor {
  final Dio dio;
  final DioExceptionMapper exceptionMapper;
  final List<NetworkInterceptor> interceptors;

  // Named rather than positional: three same-arity params where two could
  // silently swap at the call site.
  DioToNetworkInterceptorAdapter({
    required this.dio,
    required this.exceptionMapper,
    required this.interceptors,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (interceptors.isEmpty) {
      handler.next(options);
      return;
    }

    final pathQueryParameters = Uri.parse(options.path).queryParametersAll.map(
      (key, values) =>
          MapEntry(key, values.length == 1 ? values.single : values),
    );

    final networkRequest = NetworkRequest(
      // `Uri.replace(queryParameters: {})` leaves a trailing `?`, so Dio
      // re-appends the real query as `?&…`; strict gateways reject that empty
      // leading segment (400 `"value" is not allowed`). Strip it fully.
      url: options.uri.toString().split('?').first,
      method: options.method,
      headers: Map.from(
        options.headers.map((k, v) => MapEntry(k, v.toString())),
      ),
      extra: Map.from(options.extra),
      queryParameters: Map.from(options.queryParameters),
      data: options.data,
    );

    InterceptorChain(
      interceptors: interceptors,
      index: 0,
      onRequest: (req) {
        options
          ..path = req.url
          ..method = req.method;
        options.headers.addAll(req.headers);
        options.extra.addAll(req.extra);
        options.queryParameters.addAll({
          ...pathQueryParameters,
          ...?req.queryParameters,
        });
        options.data = req.data;
        handler.next(options);
      },
      onResolve: (res) {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: res.statusCode,
            data: res.data,
            statusMessage: res.statusMessage,
          ),
        );
      },
      onReject: (err) {
        final dioExceptionType = err is NetworkCancelledError
            ? DioExceptionType.cancel
            : DioExceptionType.unknown;

        handler.reject(
          DioException(
            requestOptions: options,
            error: err,
            type: dioExceptionType,
            message: err.message,
          ),
        );
      },
    ).proceedRequest(networkRequest);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (interceptors.isEmpty) {
      handler.next(response);
      return;
    }

    final networkResponse = NetworkResponse(
      statusCode: response.statusCode ?? 0,
      data: response.data,
      headers: response.headers.map.map((k, v) => MapEntry(k, v.join(','))),
      statusMessage: response.statusMessage,
    );

    InterceptorChain(
      interceptors: interceptors,
      index: 0,
      dio: dio,
      onResponse: (res) {
        response
          ..statusCode = res.statusCode
          ..data = res.data
          ..statusMessage = res.statusMessage;
        handler.next(response);
      },
      onReject: (err) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: err,
            type: DioExceptionType.unknown,
            message: err.message,
          ),
        );
      },
    ).proceedResponse(networkResponse);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (interceptors.isEmpty) {
      handler.next(err);
      return;
    }

    final originalRequest = NetworkRequest(
      url: err.requestOptions.uri.toString(),
      method: err.requestOptions.method,
      headers: err.requestOptions.headers.map(
        (k, v) => MapEntry(k, v.toString()),
      ),
      extra: Map.from(err.requestOptions.extra),
      queryParameters: err.requestOptions.queryParameters,
      data: err.requestOptions.data,
    );

    // Attach the request so error interceptors (e.g. AuthNetworkInterceptor)
    // can read the failing request's token. Without it, a 401 carries no
    // request, so the interceptor can't compare the failing token against the
    // latest one and mishandles the refresh-vs-logout decision — leaving the
    // app "logged in" after a server-side disconnect.
    final networkError = exceptionMapper(err).copyWithRequest(originalRequest);

    InterceptorChain(
      interceptors: interceptors,
      index: 0,
      dio: dio,
      originalRequestOptions: err.requestOptions,
      onError: (e) {
        // Forward what the chain produced, not what arrived. An interceptor may
        // have replaced the error — AuthNetworkInterceptor turns a 401 on a
        // non-refreshable session into a forbidden — and passing `err` here
        // would silently discard that substitution.
        handler.next(
          identical(e, networkError)
              ? err
              : DioException(
                  requestOptions: err.requestOptions,
                  error: e,
                  type: err.type,
                  response: err.response,
                  message: e.message,
                ),
        );
      },
      onResolve: (res) {
        handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            statusCode: res.statusCode,
            data: res.data,
            statusMessage: res.statusMessage,
          ),
        );
      },
      onRetry: (request) async {
        // `reuseOriginal` resends untouched: dio.fetch re-runs the request
        // phase, so the auth interceptor re-applies the freshly refreshed token.
        final retryOptions = request.url.isEmpty
            ? err.requestOptions.copyWith(
                headers: {...err.requestOptions.headers, ...request.headers},
              )
            : err.requestOptions.copyWith(
                path: request.url,
                method: request.method,
                headers: request.headers,
                queryParameters: request.queryParameters,
                data: request.data,
              );

        try {
          final response = await dio.fetch<dynamic>(retryOptions);
          handler.resolve(response);
        } on DioException catch (retryErr) {
          handler.next(retryErr);
        }
      },
    ).proceedError(networkError, originalRequest: originalRequest);
  }
}

class InterceptorChain {
  final Dio? dio;
  final int index;
  final List<NetworkInterceptor> interceptors;
  final void Function(NetworkError)? onError;
  final void Function(NetworkError)? onReject;
  final void Function(NetworkRequest)? onRequest;
  final void Function(NetworkResponse<dynamic>)? onResolve;
  final void Function(NetworkResponse<dynamic>)? onResponse;
  final Future<void> Function(NetworkRequest)? onRetry;
  final RequestOptions? originalRequestOptions;

  InterceptorChain({
    required this.index,
    required this.interceptors,
    this.dio,
    this.onError,
    this.onReject,
    this.onRequest,
    this.onResolve,
    this.onResponse,
    this.onRetry,
    this.originalRequestOptions,
  });

  Future<void> proceedRequest(NetworkRequest request) async {
    if (index >= interceptors.length) {
      onRequest?.call(request);
      return;
    }

    await interceptors[index].onRequest(
      request,
      DioRequestHandler(
        nextCallback: (req) {
          InterceptorChain(
            interceptors: interceptors,
            index: index + 1,
            onRequest: onRequest,
            onResolve: onResolve,
            onReject: onReject,
          ).proceedRequest(req);
        },
        resolveCallback: (res) => onResolve?.call(res),
        rejectCallback: (err) => onReject?.call(err),
      ),
    );
  }

  Future<void> proceedResponse(NetworkResponse<dynamic> response) async {
    if (index >= interceptors.length) {
      onResponse?.call(response);
      return;
    }

    await interceptors[index].onResponse(
      response,
      DioResponseHandler(
        nextCallback: (res) {
          InterceptorChain(
            interceptors: interceptors,
            index: index + 1,
            dio: dio,
            originalRequestOptions: originalRequestOptions,
            onResponse: onResponse,
            onReject: onReject,
          ).proceedResponse(res);
        },
        rejectCallback: (err) => onReject?.call(err),
      ),
    );
  }

  Future<void> proceedError(
    NetworkError error, {
    NetworkRequest? originalRequest,
  }) async {
    if (index >= interceptors.length) {
      onError?.call(error);
      return;
    }

    await interceptors[index].onError(
      error,
      DioErrorHandler(
        nextCallback: (err) {
          InterceptorChain(
            interceptors: interceptors,
            index: index + 1,
            dio: dio,
            originalRequestOptions: originalRequestOptions,
            onError: onError,
            onResolve: onResolve,
            onRetry: onRetry,
          ).proceedError(err, originalRequest: originalRequest);
        },
        resolveCallback: (res) => onResolve?.call(res),
        retryCallback: onRetry != null && originalRequest != null
            ? (request) => onRetry!(request)
            : null,
      ),
    );
  }
}

class DioRequestHandler implements NetworkRequestInterceptorHandler {
  final void Function(NetworkRequest) nextCallback;
  final void Function(NetworkError) rejectCallback;
  final void Function(NetworkResponse<dynamic>) resolveCallback;

  DioRequestHandler({
    required this.nextCallback,
    required this.rejectCallback,
    required this.resolveCallback,
  });

  @override
  void next(NetworkRequest request) => nextCallback(request);

  @override
  void reject(NetworkError error) => rejectCallback(error);

  @override
  void resolve(NetworkResponse<dynamic> response) => resolveCallback(response);
}

class DioResponseHandler implements NetworkResponseInterceptorHandler {
  final void Function(NetworkResponse<dynamic>) nextCallback;
  final void Function(NetworkError) rejectCallback;

  DioResponseHandler({
    required this.nextCallback,
    required this.rejectCallback,
  });

  @override
  void next(NetworkResponse<dynamic> response) => nextCallback(response);

  @override
  void reject(NetworkError error) => rejectCallback(error);
}

class DioErrorHandler implements NetworkErrorInterceptorHandler {
  final void Function(NetworkError) nextCallback;
  final void Function(NetworkResponse<dynamic>) resolveCallback;
  final Future<void> Function(NetworkRequest)? retryCallback;

  DioErrorHandler({
    required this.nextCallback,
    required this.resolveCallback,
    this.retryCallback,
  });

  @override
  void next(NetworkError error) => nextCallback(error);

  @override
  void resolve(NetworkResponse<dynamic> response) => resolveCallback(response);

  @override
  void retry(NetworkRequest request) {
    final callback = retryCallback;

    if (callback == null) {
      nextCallback(const NetworkConnectionError(reason: 'Retry not supported'));
      return;
    }

    // The callback resolves or rejects the Dio handler itself, so there is no
    // result to await — but a failure here would otherwise vanish.
    callback(
      request,
    ).unawait(tag: packageName, logMessage: 'Error-phase retry failed');
  }
}
