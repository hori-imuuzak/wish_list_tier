import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/presentation/viewmodels/archive_viewmodel.dart';

class ArchiveScreen extends ConsumerWidget {
  final String? categoryId;
  final String? categoryName;

  const ArchiveScreen({super.key, this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveAsync = ref.watch(archiveViewModelProvider(categoryId));

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
          child: archiveAsync.when(
            data: (archiveState) {
              return TabBarView(
                children: [
                  _ItemList(
                    items: archiveState.completedItems,
                    isDeletedList: false,
                    categoryId: categoryId,
                  ),
                  _ItemList(
                    items: archiveState.deletedItems,
                    isDeletedList: true,
                    categoryId: categoryId,
                  ),
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
  final String? categoryId;

  const _ItemList({
    required this.items,
    required this.isDeletedList,
    required this.categoryId,
  });

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
                        .read(archiveViewModelProvider(categoryId).notifier)
                        .restoreItem(item.id);
                  },
                )
              : null,
        );
      },
    );
  }
}
