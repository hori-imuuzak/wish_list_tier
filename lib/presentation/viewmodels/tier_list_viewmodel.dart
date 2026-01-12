import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/usecases/providers.dart';

part 'tier_list_viewmodel.g.dart';

@riverpod
class TierListViewModel extends _$TierListViewModel {
  @override
  Future<List<WishItem>> build() async {
    final getItems = ref.watch(getItemsUseCaseProvider);
    final getCategories = ref.watch(getCategoriesUseCaseProvider);
    final addCategory = ref.read(addCategoryUseCaseProvider);
    final updateItem = ref.read(updateItemUseCaseProvider);

    // Ensure categories are loaded and migration happens if needed
    final categories = await getCategories();
    if (categories.isEmpty) {
      // Migration: Create default category and assign existing items
      final defaultCategory = Category(
        id: const Uuid().v4(),
        name: 'メイン',
        createdAt: DateTime.now(),
      );
      await addCategory(defaultCategory);

      final items = await getItems();
      for (final item in items) {
        if (item.categoryId == null) {
          await updateItem(item.copyWith(categoryId: defaultCategory.id));
        }
      }
    }

    return getItems();
  }

  Future<List<Category>> getCategories() async {
    final getCategories = ref.read(getCategoriesUseCaseProvider);
    return getCategories();
  }

  Future<void> addCategory(String name) async {
    final addCategory = ref.read(addCategoryUseCaseProvider);
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    await addCategory(category);
    ref.invalidateSelf();
  }

  Future<void> deleteCategory(String id) async {
    final deleteCategory = ref.read(deleteCategoryUseCaseProvider);
    await deleteCategory(id);
    ref.invalidateSelf();
  }

  Future<void> addItem(WishItem item) async {
    final addItem = ref.read(addItemUseCaseProvider);
    await addItem(item);
    ref.invalidateSelf();
  }

  Future<void> updateItem(WishItem item) async {
    final updateItem = ref.read(updateItemUseCaseProvider);
    await updateItem(item);
    ref.invalidateSelf();
  }

  Future<void> deleteItem(String id, {bool isDeleted = true}) async {
    final deleteItem = ref.read(deleteItemUseCaseProvider);
    await deleteItem(id, isDeleted: isDeleted);
    ref.invalidateSelf();
  }

  Future<void> moveItemToTier(String id, TierType tier) async {
    final moveItemToTier = ref.read(moveItemToTierUseCaseProvider);
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
        await moveItemToTier(id, tier);
      } catch (e) {
        // If error, revert to previous state
        state = AsyncValue.data(currentItems);
        rethrow;
      }
    }
  }

  Future<void> completeItem(String id) async {
    final completeItem = ref.read(completeItemUseCaseProvider);
    await completeItem(id);
    ref.invalidateSelf();
  }
}
