import 'package:mobile/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<void> logout();
  Future<bool> checkAuthStatus();
}
