import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:mobile/core/storage/storage.dart';
import 'package:mobile/core/toasts/toaster.dart';

final dioProvider = Provider((ref) => Dio());

final apiClientServiceProvider = Provider<ApiClientService>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return ApiClientService(dio: dio, storage: storage);
});

class ApiClientService {
  ApiClientService({required this.dio, required this.storage}) {
    dio
      ..options.baseUrl = dotenv.env['BASE_URL']!
      ..options.connectTimeout = const Duration(minutes: 10)
      ..options.receiveTimeout = const Duration(minutes: 10)
      ..options.headers = {'Accept': 'application/json'}
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('🌐 Dio Log: $obj'),
        ),
      );
  }
  final Dio dio;
  final Storage storage;

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onRecieveProgress,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {"Authorization": await storage.read(key: 'token')},
            ),
        cancelToken: cancelToken,
        onReceiveProgress: onRecieveProgress,
      );
      return response.data;
    } catch (e) {
      debugPrint("get Method Error $e");
      final DioException exception = e as DioException;
      final response = exception.response?.data;
      Toaster.onError(
        message: response['message'],
        duration: const Duration(seconds: 3),
      );
      rethrow;
    }
  }

  Future<String?> uploadImage({
    required XFile image,
    required String folder,
    String? description,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      // Read file as bytes for better compatibility on real devices
      final bytes = await image.readAsBytes();
      final fileName = image.name.isNotEmpty
          ? image.name
          : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      debugPrint('📤 Uploading image:');
      debugPrint('   File name: $fileName');
      debugPrint('   File size: ${bytes.length} bytes');
      debugPrint('   Folder: $folder');

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: DioMediaType.parse(_getContentType(image)),
        ),
        'folder': folder,
        if (description != null) 'description': description,
      });

      // debugPrint('🚀 Sending request to: ${Network.uploadImage()}');

      final response = await dio.post<Map<String, dynamic>>(
        NetworkUrls.uploadImage(),
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.json,
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('📥 Response received:');
      debugPrint('   Status: ${response.statusCode}');
      debugPrint('   Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data?['url'];
      }

      debugPrint('❌ Unexpected status code: ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      debugPrint('❌ Dio error uploading image:');
      debugPrint('   Type: ${e.type}');
      debugPrint('   Message: ${e.message}');
      if (e.response != null) {
        debugPrint('   Response status: ${e.response?.statusCode}');
        debugPrint('   Response data: ${e.response?.data}');
        debugPrint('   Response headers: ${e.response?.headers}');
      }
      rethrow;
    } catch (e) {
      debugPrint('❌ General error uploading image: $e');
      rethrow;
    }
  }

  // Helper method to determine content type
  String _getContentType(XFile image) {
    final extension = image.name.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onRecieveProgress,
    dynamic body,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: body,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {"Authorization": await storage.read(key: 'token')},
            ),
        cancelToken: cancelToken,
        onReceiveProgress: onRecieveProgress,
      );
      debugPrint("Successfully fetched response");
      return response.data;
    } catch (e) {
      debugPrint("get Method Error $e");
      final DioException exception = e as DioException;
      final response = exception.response?.data;
      Toaster.onError(message: response['message']);
      rethrow;
    }
  }

  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_compressed.jpg',
      quality: 70,
    );
    return File(result!.path);
  }

  Future<dynamic> put(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onRecieveProgress,
    dynamic body,
  }) async {
    try {
      final response = await dio.put(
        url,
        data: body,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {"Authorization": await storage.read(key: 'token')},
            ),
        cancelToken: cancelToken,
        onReceiveProgress: onRecieveProgress,
      );
      return response.data;
    } catch (e) {
      debugPrint("get Method Error $e");
      final DioException exception = e as DioException;
      final response = exception.response?.data;
      Toaster.onError(message: response['message']);
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onRecieveProgress,
  }) async {
    try {
      final response = await dio.delete(
        url,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {"Authorization": await storage.read(key: 'token')},
            ),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      debugPrint("get Method Error $e");
      final DioException exception = e as DioException;
      final response = exception.response?.data;
      Toaster.onError(message: response['message']);
      rethrow;
    }
  }
}
