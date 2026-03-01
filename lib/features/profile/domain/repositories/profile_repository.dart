import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/profile/data/models/address_model.dart';

abstract class ProfileRepository {
  Future<UserModel?> getProfile();
  Future<List<AddressModel>> getAddresses();
  Future<bool> addAddress(AddressModel address);
}
