import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/presentation/screens/archive_screen.dart';
import 'package:wish_list_tier/presentation/screens/item_detail_screen.dart';
import 'package:wish_list_tier/presentation/screens/item_editor_screen.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

class TierListScreen extends ConsumerWidget {
  const TierListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tierListAsync = ref.watch(tierListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('欲しいものリストTier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ArchiveScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: tierListAsync.when(
          data: (items) {
            return SingleChildScrollView(
              child: Column(
                children: TierType.values.map((tier) {
                  final tierItems = items
                      .where(
                        (item) =>
                            item.tier == tier &&
                            !item.isCompleted &&
                            !item.isDeleted,
                      )
                      .toList();
                  return TierRow(tier: tier, items: tierItems);
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('エラー: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ItemEditorScreen()),
          );
        },
        child: const Icon(Icons.add),
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
