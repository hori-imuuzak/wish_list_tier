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
    final categoriesResult = await getCategories();
    final categories = categoriesResult.valueOrNull ?? [];
    if (categories.isEmpty) {
      // Migration: Create default category and assign existing items
      final defaultCategory = Category(
        id: const Uuid().v4(),
        name: 'メイン',
        createdAt: DateTime.now(),
      );
      await addCategory(defaultCategory);

      final itemsResult = await getItems();
      final items = itemsResult.valueOrNull ?? [];
      for (final item in items) {
        if (item.categoryId == null) {
          await updateItem(item.copyWith(categoryId: defaultCategory.id));
        }
      }
    }

    final result = await getItems();
    return result.when(
      success: (items) => items,
      failure: (e) => throw e,
    );
  }

  Future<List<Category>> getCategories() async {
    final getCategories = ref.read(getCategoriesUseCaseProvider);
    final result = await getCategories();
    return result.valueOrNull ?? [];
  }

  Future<void> addCategory(String name) async {
    final addCategory = ref.read(addCategoryUseCaseProvider);
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    final result = await addCategory(category);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
  }

  Future<void> deleteCategory(String id) async {
    final deleteCategory = ref.read(deleteCategoryUseCaseProvider);
    final result = await deleteCategory(id);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
  }

  Future<void> addItem(WishItem item) async {
    final addItem = ref.read(addItemUseCaseProvider);
    final result = await addItem(item);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
  }

  Future<void> updateItem(WishItem item) async {
    final updateItem = ref.read(updateItemUseCaseProvider);
    final result = await updateItem(item);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
  }

  Future<void> deleteItem(String id, {bool isDeleted = true}) async {
    final deleteItem = ref.read(deleteItemUseCaseProvider);
    final result = await deleteItem(id, isDeleted: isDeleted);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
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
      final result = await moveItemToTier(id, tier);
      if (result.isFailure) {
        // If error, revert to previous state
        state = AsyncValue.data(currentItems);
        throw result.exceptionOrNull!;
      }
    }
  }

  Future<void> completeItem(String id) async {
    final completeItem = ref.read(completeItemUseCaseProvider);
    final result = await completeItem(id);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
  }
}
