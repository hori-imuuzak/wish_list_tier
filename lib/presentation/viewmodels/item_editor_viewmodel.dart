import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/usecases/command/add_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/update_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/providers.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

part 'item_editor_viewmodel.g.dart';

@riverpod
class ItemEditorViewModel extends _$ItemEditorViewModel {
  late final AddItemUseCase _addItemUseCase;
  late final UpdateItemUseCase _updateItemUseCase;

  @override
  void build() {
    _addItemUseCase = ref.read(addItemUseCaseProvider);
    _updateItemUseCase = ref.read(updateItemUseCaseProvider);
  }

  Future<void> createItem({
    required String title,
    required String description,
    required String? categoryId,
    required String? imagePath,
    required double? price,
    required String? url,
    required DateTime? deadline,
    required TierType tier,
  }) async {
    final newItem = WishItem(
      id: const Uuid().v4(),
      title: title,
      description: description,
      categoryId: categoryId,
      imagePath: imagePath,
      price: price,
      url: url,
      deadline: deadline,
      tier: tier,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _addItemUseCase(newItem);
    if (result.isSuccess && ref.mounted) {
      ref.invalidate(tierListViewModelProvider);
    }
  }

  Future<void> updateItem({
    required WishItem originalItem,
    required String title,
    required String description,
    required String? imagePath,
    required double? price,
    required String? url,
    required DateTime? deadline,
    required TierType tier,
  }) async {
    final updatedItem = originalItem.copyWith(
      title: title,
      description: description,
      imagePath: imagePath,
      price: price,
      url: url,
      deadline: deadline,
      tier: tier,
      updatedAt: DateTime.now(),
    );

    final result = await _updateItemUseCase(updatedItem);
    if (result.isSuccess && ref.mounted) {
      ref.invalidate(tierListViewModelProvider);
    }
  }
}
