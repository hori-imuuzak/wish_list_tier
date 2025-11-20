import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:wish_list_tier/domain/models/comment.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/presentation/screens/item_editor_screen.dart';
import 'package:wish_list_tier/presentation/viewmodels/tier_list_viewmodel.dart';

class ItemDetailScreen extends ConsumerWidget {
  final WishItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific item from the list to get updates
    final itemsAsync = ref.watch(tierListViewModelProvider);
    final currentItem =
        itemsAsync.value?.firstWhere(
          (element) => element.id == item.id,
          orElse: () => item,
        ) ??
        item;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentItem.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ItemEditorScreen(item: currentItem),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'complete') {
                await ref
                    .read(tierListViewModelProvider.notifier)
                    .completeItem(currentItem.id);
                if (context.mounted) Navigator.of(context).pop();
              } else if (value == 'delete') {
                await ref
                    .read(tierListViewModelProvider.notifier)
                    .deleteItem(currentItem.id);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'complete', child: Text('完了にする')),
              const PopupMenuItem(value: 'delete', child: Text('削除')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentItem.imagePath != null)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: FileImage(File(currentItem.imagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTierColor(currentItem.tier),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tier ${currentItem.tier.label}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (currentItem.price != null)
                    Text(
                      '¥${currentItem.price}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentItem.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (currentItem.description.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    currentItem.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (currentItem.deadline != null) ...[
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '期限: ${DateFormat('yyyy/MM/dd').format(currentItem.deadline!)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (currentItem.url != null && currentItem.url!.isNotEmpty)
                InkWell(
                  onTap: () async {
                    final uri = Uri.parse(currentItem.url!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.link, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentItem.url!,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              const Divider(),
              Text(
                'コメント',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...currentItem.comments.map(
                (comment) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(comment.content),
                    subtitle: Text(
                      DateFormat('yyyy/MM/dd HH:mm').format(comment.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _AddCommentWidget(itemId: currentItem.id),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
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

class _AddCommentWidget extends ConsumerStatefulWidget {
  final String itemId;

  const _AddCommentWidget({required this.itemId});

  @override
  ConsumerState<_AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends ConsumerState<_AddCommentWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_controller.text.isNotEmpty) {
      final comment = Comment(
        id: const Uuid().v4(),
        content: _controller.text,
        createdAt: DateTime.now(),
      );

      // Since we don't have a direct addComment method in ViewModel yet, we need to update the item.
      // But ViewModel only exposes updateItem.
      // Let's fetch the item, add comment, and update.
      // Or better, add addComment to ViewModel.
      // For now, I'll implement it here by reading the current item.

      final items = await ref.read(tierListViewModelProvider.future);
      final item = items.firstWhere((e) => e.id == widget.itemId);
      final updatedItem = item.copyWith(
        comments: [...item.comments, comment],
        updatedAt: DateTime.now(),
      );

      await ref
          .read(tierListViewModelProvider.notifier)
          .updateItem(updatedItem);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'コメントを追加...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.pinkAccent),
          onPressed: _addComment,
        ),
      ],
    );
  }
}
