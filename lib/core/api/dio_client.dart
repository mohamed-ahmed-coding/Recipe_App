import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:recipe_app/core/api/api_constants.dart';
import 'package:recipe_app/core/api/api_exception.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _addInterceptors();
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  factory DioClient() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters.addAll({
          'apiKey': ApiConstants.apiKey,
        });
        log('➡️  Request: ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        log('✅ Response [${response.statusCode}]: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        final message = _handleError(error);
        log('❌ Error [${error.response?.statusCode}]: $message');

        final apiError = DioException(
          requestOptions: error.requestOptions,
          error: ApiException(message, statusCode: error.response?.statusCode),
          response: error.response,
          type: error.type,
        );

        handler.reject(apiError);
      },
    ));
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please check your internet and try again.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401) return 'Invalid API key. Check ApiConstants.apiKey.';
        if (code == 402) return 'Spoonacular daily quota exceeded.';
        if (code == 404) return 'Resource not found.';
        return 'Server error (status $code).';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.unknown:
      default:
        return 'An unexpected error occurred: ${error.message}';
    }
  }
}