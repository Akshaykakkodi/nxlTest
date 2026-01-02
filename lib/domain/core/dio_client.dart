import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';
import 'package:test/application/core/utils/logger.dart';
import 'package:test/application/core/utils/urls.dart';
import 'package:test/domain/core/failures.dart';

@lazySingleton
class DioClient {
  final Dio dio;
  String? token;
  late String fcmToken;

  DioClient(this.dio) {
    dio
      ..options.baseUrl = Urls.apiBaseUrl
      ..options.connectTimeout = const Duration(minutes: 6)
      ..options.receiveTimeout = const Duration(minutes: 6);

    dio.interceptors.add(InternetConnectionInterceptor());
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {}
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      Logger.logSuccess(response);

      return response;
    } on SocketException catch (e) {
      Logger.logError(e);

      throw MainFailure(message: e.toString());
    } on FormatException catch (_) {
      throw MainFailure(message: "Unable to process the data");
    } catch (e) {
      Logger.logError("Dio Get Error: $e");

      if (e is DioException) {
        throw MainFailure(message: e.errorMessage);
      }

      throw MainFailure(message: "Unknown error occurred");
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      // print("no network - 1");
      throw MainFailure(message: e.toString());
    } on FormatException catch (_) {
      throw MainFailure(message: "Unable to process the data");
    } on DioException catch (e) {
      // Logger.logError(e.errorMessage);
      if (e.message == "No internet connection") {
        throw MainFailure(message: e.message ?? '');
      }
      if (e.type == DioExceptionType.cancel) {
        throw MainFailure(message: 'Canceld By User');
      }

      throw MainFailure(message: e.errorMessage);
    } catch (_) {
      throw MainFailure(message: "Unknown error occurred");
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      // print("no network - 1");
      throw MainFailure(message: e.toString());
    } on FormatException catch (_) {
      throw MainFailure(message: "Unable to process the data");
    } on DioException catch (e) {
      // Logger.logError(e.errorMessage);
      if (e.message == "No internet connection") {
        throw MainFailure(message: e.message ?? '');
      }
      if (e.type == DioExceptionType.cancel) {
        throw MainFailure(message: 'Canceld By User');
      }

      throw MainFailure(message: e.errorMessage);
    } catch (_) {
      throw MainFailure(message: "Unknown error occurred");
    }
  }
}

class LoggingInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    DateTime now = DateTime.now().toUtc();
    // String? token = box.read(AppConstants.token);
    options.headers.addAll({
      'Timestamp': now.millisecondsSinceEpoch,
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ',
      'Access-Control-Allow-Origin': '*',
      'Accept': 'application/json',
      'Device-Type': Platform.isAndroid
          ? 1
          : Platform.isIOS
          ? 2
          : 0,
    });

    Logger.logWarning("Headers: ${options.headers.toString()}");
    Logger.logWarning("Parms: ${options.data.toString()}");
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      return response.statusCode == 200 || response.statusCode == 201
          ? super.onResponse(response, handler)
          : handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: response.data,
                response: response,
                type: DioExceptionType.unknown,
              ),
            );
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: "Something went wrong",
          response: response,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }
}

class InternetConnectionInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    Logger.logSuccess(connectivityResult);
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          message: 'No internet connection',
          type: DioExceptionType.connectionTimeout,
        ),
      );
    } else {
      return super.onRequest(options, handler);
    }
  }
}

extension DioExceptionExtension on DioException {
  String get errorMessage => _getErrorMsg(this);

  String _getErrorMsg(DioException e) {
    Logger.logError(e);
    switch (e.type) {
      case DioExceptionType.cancel:
        return "Request to server was cancelled";
      case DioExceptionType.connectionError:
        return "Connection timeout with server";

      case DioExceptionType.receiveTimeout:
        return "Receive timeout in connection with server";
      case DioExceptionType.badResponse:
        if (e.response!.statusCode! >= 500) {
          return "Internal server error";
        }

        if (e.response?.statusCode == 400) {
          return e.response?.data?['message'] ??
              e.response?.data?['error']['message'] ??
              'Somthing went wrong';
        }

        if (e.response?.statusCode == 422) {
          return e.response?.data?['message'] ??
              e.response?.data?['error']['message'] ??
              'Somthing went wrong';
        }

        if (e.response?.statusCode == 403) {
          return e.response?.data?['error']['message'] ?? 'Somthing went wrong';
        }

        if (e.response?.statusCode == 401) {
          return e.response?.data?['message'] ?? 'Somthing went wrong';
        }
        Logger.logSuccess(e.response?.data);

        return "Somthing went wrong";
      case DioExceptionType.sendTimeout:
        return "Send timeout with server";
      case DioExceptionType.unknown:
      default:
        return "Unexpected error occurred";
    }
  }
}
