import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late final Dio dio;

  DioClient._internal() {
    // Use different base URLs for web and mobile
    String baseUrl = kIsWeb 
        ? 'http://localhost:3000'  // For web - removed /api
        : 'http://10.0.2.2:3000/api';  // For Android emulator - removed /api

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 3200),
        receiveTimeout: const Duration(seconds: 3200),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add error handling
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        if (e.type == DioExceptionType.connectionError) {
          print('Connection error: Please check if the server is running at $baseUrl');
        }
        return handler.next(e);
      },
    ));
  }
} 