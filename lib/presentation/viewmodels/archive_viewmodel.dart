import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/usecases/command/delete_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/providers.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

part 'archive_viewmodel.g.dart';

@riverpod
class ArchiveViewModel extends _$ArchiveViewModel {
  late DeleteItemUseCase _deleteItemUseCase;

  @override
  Future<ArchiveState> build(String? categoryId) async {
    _deleteItemUseCase = ref.read(deleteItemUseCaseProvider);

    final itemsAsync = ref.watch(tierListViewModelProvider);
    final items = itemsAsync.value ?? [];

    final filteredItems = categoryId != null
        ? items.where((item) => item.categoryId == categoryId)
        : items;

    final completedItems = filteredItems
        .where((item) => item.isCompleted && !item.isDeleted)
        .toList();
    final deletedItems = filteredItems.where((item) => item.isDeleted).toList();

    return ArchiveState(
      completedItems: completedItems,
      deletedItems: deletedItems,
    );
  }

  Future<void> restoreItem(String id) async {
    final result = await _deleteItemUseCase(id, isDeleted: false);
    if (result.isSuccess && ref.mounted) {
      ref.invalidate(tierListViewModelProvider);
    }
  }
}

class ArchiveState {
  final List<WishItem> completedItems;
  final List<WishItem> deletedItems;

  ArchiveState({
    required this.completedItems,
    required this.deletedItems,
  });
}
