import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/usecases/command/add_category_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/add_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/complete_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/delete_category_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/delete_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/move_item_to_tier_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/update_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/providers.dart';
import 'package:wish_list_tier/domain/usecases/query/get_categories_usecase.dart';
import 'package:wish_list_tier/domain/usecases/query/get_items_usecase.dart';

part 'tier_list_viewmodel.g.dart';

@riverpod
class TierListViewModel extends _$TierListViewModel {
  late final GetItemsUseCase _getItemsUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final AddCategoryUseCase _addCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final AddItemUseCase _addItemUseCase;
  late final UpdateItemUseCase _updateItemUseCase;
  late final DeleteItemUseCase _deleteItemUseCase;
  late final MoveItemToTierUseCase _moveItemToTierUseCase;
  late final CompleteItemUseCase _completeItemUseCase;

  @override
  Future<List<WishItem>> build() async {
    _getItemsUseCase = ref.read(getItemsUseCaseProvider);
    _getCategoriesUseCase = ref.read(getCategoriesUseCaseProvider);
    _addCategoryUseCase = ref.read(addCategoryUseCaseProvider);
    _deleteCategoryUseCase = ref.read(deleteCategoryUseCaseProvider);
    _addItemUseCase = ref.read(addItemUseCaseProvider);
    _updateItemUseCase = ref.read(updateItemUseCaseProvider);
    _deleteItemUseCase = ref.read(deleteItemUseCaseProvider);
    _moveItemToTierUseCase = ref.read(moveItemToTierUseCaseProvider);
    _completeItemUseCase = ref.read(completeItemUseCaseProvider);

    // Ensure categories are loaded and migration happens if needed
    final categoriesResult = await _getCategoriesUseCase();
    final categories = categoriesResult.valueOrNull ?? [];
    if (categories.isEmpty) {
      // Migration: Create default category and assign existing items
      final defaultCategory = Category(
        id: const Uuid().v4(),
        name: 'メイン',
        createdAt: DateTime.now(),
      );
      await _addCategoryUseCase(defaultCategory);

      final itemsResult = await _getItemsUseCase();
      final items = itemsResult.valueOrNull ?? [];
      for (final item in items) {
        if (item.categoryId == null) {
          await _updateItemUseCase(item.copyWith(categoryId: defaultCategory.id));
        }
      }
    }

    final result = await _getItemsUseCase();
    return result.when(
      success: (items) => items,
      failure: (e) => throw e,
    );
  }

  Future<List<Category>> getCategories() async {
    final result = await _getCategoriesUseCase();
    return result.valueOrNull ?? [];
  }

  Future<void> addCategory(String name) async {
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    final result = await _addCategoryUseCase(category);
    if (result.isSuccess && ref.mounted) {
      ref.invalidateSelf();
    }
  }

  Future<void> deleteCategory(String id) async {
    final result = await _deleteCategoryUseCase(id);
    if (result.isSuccess && ref.mounted) {
      ref.invalidateSelf();
    }
  }

  Future<void> addItem(WishItem item) async {
    final result = await _addItemUseCase(item);
    if (result.isSuccess && ref.mounted) {
      ref.invalidateSelf();
    }
  }

  Future<void> updateItem(WishItem item) async {
    final result = await _updateItemUseCase(item);
    if (result.isSuccess && ref.mounted) {
      ref.invalidateSelf();
    }
  }

  Future<void> deleteItem(String id, {bool isDeleted = true}) async {
    final result = await _deleteItemUseCase(id, isDeleted: isDeleted);
    if (result.isSuccess && ref.mounted) {
      ref.invalidateSelf();
    }
  }

  Future<void> moveItemToTier(String id, TierType tier) async {
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
      final result = await _moveItemToTierUseCase(id, tier);
      if (result.isFailure && ref.mounted) {
        // If error, revert to previous state
        state = AsyncValue.data(currentItems);
        throw result.exceptionOrNull!;
      }
    }
  }

  Future<void> completeItem(String id) async {
    final result = await _completeItemUseCase(id);
    if (result.isSuccess && ref.mounted) {
      ref.invalidateSelf();
    }
  }
}
