import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:wish_list_tier/domain/models/comment.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/usecases/providers.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

part 'item_detail_viewmodel.g.dart';

@riverpod
class ItemDetailViewModel extends _$ItemDetailViewModel {
  @override
  WishItem? build(String itemId) {
    final itemsAsync = ref.watch(tierListViewModelProvider);
    return itemsAsync.value?.firstWhere(
      (element) => element.id == itemId,
      orElse: () => throw StateError('Item not found'),
    );
  }

  Future<void> addComment(String content) async {
    if (content.isEmpty) return;

    final currentItem = state;
    if (currentItem == null) return;

    final comment = Comment(
      id: const Uuid().v4(),
      content: content,
      createdAt: DateTime.now(),
    );

    final updatedItem = currentItem.copyWith(
      comments: [...currentItem.comments, comment],
      updatedAt: DateTime.now(),
    );

    final updateItem = ref.read(updateItemUseCaseProvider);
    await updateItem(updatedItem);
    ref.invalidate(tierListViewModelProvider);
  }

  Future<void> completeItem() async {
    final currentItem = state;
    if (currentItem == null) return;

    final completeItem = ref.read(completeItemUseCaseProvider);
    await completeItem(currentItem.id);
    ref.invalidate(tierListViewModelProvider);
  }

  Future<void> deleteItem() async {
    final currentItem = state;
    if (currentItem == null) return;

    final deleteItem = ref.read(deleteItemUseCaseProvider);
    await deleteItem(currentItem.id);
    ref.invalidate(tierListViewModelProvider);
  }

  Future<bool> launchItemUrl() async {
    final currentItem = state;
    if (currentItem == null) return false;

    final url = currentItem.url;
    if (url == null || url.isEmpty) return false;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }
}
