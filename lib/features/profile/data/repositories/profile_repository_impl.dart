import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/profile/data/models/address_model.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return ProfileRepositoryImpl(apiClient: apiClient);
});

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClientService apiClient;

  ProfileRepositoryImpl({required this.apiClient});

  @override
  Future<UserModel?> getProfile() async {
    try {
      final response = await apiClient.get(NetworkUrls.getProfile());
      // API returns {name, email, phone} directly at root level
      if (response != null && response['name'] != null) {
        return UserModel.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await apiClient.get(NetworkUrls.getAddresses());
      if (response['success'] == true && response['addresses'] != null) {
        return (response['addresses'] as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> addAddress(AddressModel address) async {
    try {
      final response = await apiClient.post(
        NetworkUrls.addAddress(),
        body: address.toJson(),
      );
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
