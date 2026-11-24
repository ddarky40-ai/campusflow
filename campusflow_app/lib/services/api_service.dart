import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/auth_status.dart';

class ApiService {
  static const String tokenKey = 'auth_token';

  final Dio dio;
  final FlutterSecureStorage storage;
  final VoidCallback? onUnauthorized;

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  ApiService({
    FlutterSecureStorage? storage,
    this.onUnauthorized,
  })
      : storage = storage ?? const FlutterSecureStorage(),
        dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: Headers.jsonContentType,
          headers: {'Accept': 'application/json'},
        )) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await this.storage.read(key: tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await this.storage.delete(key: tokenKey);
            authStatus.value = false;
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<List<dynamic>> getTasks() async {
    final response = await dio.get('/tasks');
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getCourses() async {
    final response = await dio.get('/courses');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createTask(
      Map<String, dynamic> data) async {
    final response = await dio.post('/tasks', data: data);
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> updateTask(
      String id, Map<String, dynamic> data) async {
    final response = await dio.patch('/tasks/$id', data: data);
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> deleteTask(String id) async {
    await dio.delete('/tasks/$id');
  }
}
