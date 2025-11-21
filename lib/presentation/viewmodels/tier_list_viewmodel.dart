import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/data/providers.dart';
import 'package:uuid/uuid.dart';
import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

part 'tier_list_viewmodel.g.dart';

@riverpod
class TierListViewModel extends _$TierListViewModel {
  @override
  Future<List<WishItem>> build() async {
    final repository = ref.watch(wishListRepositoryProvider);
    // Ensure categories are loaded and migration happens if needed
    await _ensureCategories(repository);
    return repository.getItems();
  }

  Future<void> _ensureCategories(WishListRepository repository) async {
    final categories = await repository.getCategories();
    if (categories.isEmpty) {
      // Migration: Create default category and assign existing items
      final defaultCategory = Category(
        id: const Uuid().v4(),
        name: 'メイン',
        createdAt: DateTime.now(),
      );
      await repository.addCategory(defaultCategory);

      final items = await repository.getItems();
      for (final item in items) {
        if (item.categoryId == null) {
          await repository.updateItem(
            item.copyWith(categoryId: defaultCategory.id),
          );
        }
      }
    }
  }

  Future<List<Category>> getCategories() async {
    final repository = ref.read(wishListRepositoryProvider);
    return repository.getCategories();
  }

  Future<void> addCategory(String name) async {
    final repository = ref.read(wishListRepositoryProvider);
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    await repository.addCategory(category);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(String id) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.deleteCategory(id);
    ref.invalidateSelf();
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
    // Optimistic update: update UI immediately
    final currentItems = state.value ?? [];
    final itemIndex = currentItems.indexWhere((item) => item.id == id);

    if (itemIndex != -1) {
      final updatedItem = currentItems[itemIndex].copyWith(
        tier: tier,
        updatedAt: DateTime.now(),
      );
      final newItems = List<WishItem>.from(currentItems);
      newItems[itemIndex] = updatedItem;
      state = AsyncValue.data(newItems);

      // Then update repository in background
      try {
        await repository.moveItemToTier(id, tier);
      } catch (e) {
        // If error, revert to previous state
        state = AsyncValue.data(currentItems);
        rethrow;
      }
    }
  }

  Future<void> completeItem(String id) async {
    final repository = ref.read(wishListRepositoryProvider);
    await repository.completeItem(id, true);
    ref.invalidateSelf();
  }
}
