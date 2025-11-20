import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_tier/data/repositories/local_wish_list_repository.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final wishListRepositoryProvider = Provider<WishListRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalWishListRepository(prefs);
});
