import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

class ArchiveScreen extends ConsumerWidget {
  final String? categoryId;
  final String? categoryName;

  const ArchiveScreen({super.key, this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(tierListViewModelProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName != null ? 'アーカイブ ($categoryName)' : 'アーカイブ'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '完了済み'),
              Tab(text: '削除済み'),
            ],
          ),
        ),
        body: SafeArea(
          child: itemsAsync.when(
            data: (items) {
              final filteredItems = categoryId != null
                  ? items.where((item) => item.categoryId == categoryId)
                  : items;

              final completedItems = filteredItems
                  .where((item) => item.isCompleted && !item.isDeleted)
                  .toList();
              final deletedItems = filteredItems
                  .where((item) => item.isDeleted)
                  .toList();

              return TabBarView(
                children: [
                  _ItemList(items: completedItems, isDeletedList: false),
                  _ItemList(items: deletedItems, isDeletedList: true),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('エラー: $error')),
          ),
        ),
      ),
    );
  }
}

class _ItemList extends ConsumerWidget {
  final List<WishItem> items;
  final bool isDeletedList;

  const _ItemList({required this.items, required this.isDeletedList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(child: Text('アイテムはありません'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(
            item.title,
            style: TextStyle(
              decoration: isDeletedList ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${item.tier.label} - ${DateFormat('yyyy/MM/dd').format(item.updatedAt)}',
          ),
          trailing: isDeletedList
              ? IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () async {
                    await ref
                        .read(tierListViewModelProvider.notifier)
                        .deleteItem(item.id, isDeleted: false);
                  },
                )
              : null,
        );
      },
    );
  }
}
