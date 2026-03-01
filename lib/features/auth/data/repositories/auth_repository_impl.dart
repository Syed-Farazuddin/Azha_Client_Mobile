import 'package:mobile/core/storage/storage.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  final storage = ref.read(storageProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    storage: storage,
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final Storage storage;

  AuthRepositoryImpl({required this.remoteDataSource, required this.storage});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      if (response['success'] == true && response['token'] != null) {
        await storage.addItem(key: 'token', value: response['token']);
        final userData = response['user'];
        return UserModel.fromJson(userData);
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      if (response['success'] == true) {
        // Register usually does not return token in this api based on docs
        // We will just return the user model.
        return UserModel.fromJson(response['user']);
      } else {
        throw Exception(response['message'] ?? 'Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    storage.deleteOne(key: 'token');
  }

  @override
  Future<bool> checkAuthStatus() async {
    return await storage.isLogin();
  }
}
