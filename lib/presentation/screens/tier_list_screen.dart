import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/presentation/screens/archive_screen.dart';
import 'package:wish_list_tier/presentation/screens/item_detail_screen.dart';
import 'package:wish_list_tier/presentation/screens/item_editor_screen.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

class TierListScreen extends ConsumerStatefulWidget {
  const TierListScreen({super.key});

  @override
  ConsumerState<TierListScreen> createState() => _TierListScreenState();
}

class _TierListScreenState extends ConsumerState<TierListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Category> _categories = [];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tierListAsync = ref.watch(tierListViewModelProvider);

    return tierListAsync.when(
      data: (items) {
        return FutureBuilder<List<Category>>(
          future: ref.read(tierListViewModelProvider.notifier).getCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final categories = snapshot.data!;
            // Update controller if categories changed
            if (_categories.length != categories.length ||
                !_categories.every(
                  (c) => categories.any((n) => n.id == c.id),
                )) {
              _categories = categories;
              _tabController = TabController(
                length: categories.length,
                vsync: this,
              );
            }

            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text('Tierリスト'),
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: categories.map((c) => Tab(text: c.name)).toList(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () =>
                        _showAddCategoryDialog(context, categories),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        _showDeleteCategoryDialog(context, categories),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () {
                      final currentCategory = categories[_tabController.index];
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ArchiveScreen(
                            categoryId: currentCategory.id,
                            categoryName: currentCategory.name,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: TabBarView(
                  controller: _tabController,
                  children: categories.map((category) {
                    return SingleChildScrollView(
                      child: Column(
                        children: TierType.values.map((tier) {
                          final tierItems = items
                              .where(
                                (item) =>
                                    item.categoryId == category.id &&
                                    item.tier == tier &&
                                    !item.isCompleted &&
                                    !item.isDeleted,
                              )
                              .toList();
                          return TierRow(tier: tier, items: tierItems);
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  final currentCategoryId = categories[_tabController.index].id;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ItemEditorScreen(
                        initialCategoryId: currentCategoryId,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          },
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('エラー: $error'))),
    );
  }

  void _showAddCategoryDialog(BuildContext context, List<Category> categories) {
    if (categories.length >= 2) {
      // Show purchase mock
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('制限に達しました'),
          content: const Text('カテゴリをさらに作成するには、プレミアムプランへのアップグレードが必要です。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('購入画面（モック）')));
              },
              child: const Text('購入する'),
            ),
          ],
        ),
      );
      return;
    }

    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('カテゴリを追加'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'カテゴリ名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref
                    .read(tierListViewModelProvider.notifier)
                    .addCategory(controller.text);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    List<Category> categories,
  ) {
    if (categories.isEmpty) return;

    // Can't delete the last category? Or maybe just ensure at least one exists?
    // Requirement: "Delete category (confirm with user)"
    // If only 1 category, maybe prevent deletion or recreate default?
    // Let's assume we can delete any, but if 0 left, migration logic might kick in on next reload.
    // But better to prevent deleting the last one or currently selected one easily.

    final currentCategory = categories[_tabController.index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${currentCategory.name}を削除しますか？'),
        content: const Text('このカテゴリに含まれるすべてのアイテムも削除されます。この操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref
                  .read(tierListViewModelProvider.notifier)
                  .deleteCategory(currentCategory.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('削除', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class TierRow extends ConsumerWidget {
  final TierType tier;
  final List<WishItem> items;
  const TierRow({super.key, required this.tier, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<WishItem>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        ref
            .read(tierListViewModelProvider.notifier)
            .moveItemToTier(details.data.id, tier);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: candidateData.isNotEmpty
                ? Border.all(color: _getTierColor(tier), width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: _getTierColor(tier).withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tier.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _getTierColor(tier),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    constraints: const BoxConstraints(minHeight: 100),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: items.map((item) {
                        return Draggable<WishItem>(
                          data: item,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.7,
                              child: _ItemCard(item: item, isDragging: true),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _ItemCard(item: item),
                          ),
                          child: _ItemCard(item: item),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTierColor(TierType tier) {
    switch (tier) {
      case TierType.ss:
        return Colors.redAccent;
      case TierType.s:
        return Colors.orangeAccent;
      case TierType.a:
        return Colors.amber;
      case TierType.b:
        return Colors.yellow[700]!;
      case TierType.c:
        return Colors.green;
      case TierType.d:
        return Colors.blueAccent;
      case TierType.e:
        return Colors.indigoAccent;
      case TierType.f:
        return Colors.purpleAccent;
      case TierType.g:
        return Colors.grey;
    }
  }
}

class _ItemCard extends StatelessWidget {
  final WishItem item;
  final bool isDragging;

  const _ItemCard({required this.item, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isDragging
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.imagePath != null)
                Image.file(File(item.imagePath!), fit: BoxFit.cover)
              else
                Container(
                  color: Colors.grey[100],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
