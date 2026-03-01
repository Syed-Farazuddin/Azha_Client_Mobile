import 'package:mobile/core/storage/storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'themes.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  @override
  Future<String> build() async {
    return await ref.read(storageProvider).read(key: 'theme') ?? 'light';
  }

  Future<void> toggleTheme({required String theme}) async {
    await ref.read(storageProvider).addItem(key: 'theme', value: theme);
    ref.invalidate(themeControllerProvider);
  }
}
