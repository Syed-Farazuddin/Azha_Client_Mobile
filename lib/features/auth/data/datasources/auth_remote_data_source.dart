import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return AuthRemoteDataSourceImpl(apiClient: apiClient);
});

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClientService apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiClient.post(
      NetworkUrls.login(),
      body: {'email': email, 'password': password},
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await apiClient.post(
      NetworkUrls.register(),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
    return response;
  }
}
