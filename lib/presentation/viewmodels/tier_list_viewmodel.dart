import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/data/providers.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';

part 'tier_list_viewmodel.g.dart';

@riverpod
class TierListViewModel extends _$TierListViewModel {
  @override
  Future<List<WishItem>> build() async {
    final repository = ref.watch(wishListRepositoryProvider);
    return repository.getItems();
  }

  Future<void> addItem(WishItem item) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.addItem(item);
    ref.invalidateSelf();
  }

  Future<void> updateItem(WishItem item) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.updateItem(item);
    ref.invalidateSelf();
  }

  Future<void> deleteItem(String id, {bool isDeleted = true}) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.deleteItem(id, isDeleted);
    ref.invalidateSelf();
  }

  Future<void> moveItemToTier(String id, TierType tier) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.moveItemToTier(id, tier);
    ref.invalidateSelf();
  }

  Future<void> completeItem(String id) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.completeItem(id, true);
    ref.invalidateSelf();
  }
}
