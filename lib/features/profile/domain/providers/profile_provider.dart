import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/profile/data/models/address_model.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository_impl.dart';

final profileProvider = FutureProvider<UserModel?>((ref) async {
  final repository = ref.read(profileRepositoryProvider);
  return repository.getProfile();
});

class AddressNotifier extends StateNotifier<AsyncValue<List<AddressModel>>> {
  AddressNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchAddresses();
  }

  final Ref ref;

  Future<void> fetchAddresses() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      final addresses = await repository.getAddresses();
      state = AsyncValue.data(addresses);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> addAddress(AddressModel newAddress) async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      final success = await repository.addAddress(newAddress);
      if (success) {
        await fetchAddresses();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

final addressNotifierProvider =
    StateNotifierProvider<AddressNotifier, AsyncValue<List<AddressModel>>>((
      ref,
    ) {
      return AddressNotifier(ref);
    });
