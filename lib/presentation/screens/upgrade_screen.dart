import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:wish_list_tier/data/providers/purchase_provider.dart';

class PurchaseScreen extends ConsumerWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('購入')),
      body: SafeArea(
        child: purchases.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Status
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFB7B2),
                            const Color(0xFFFFB7B2).withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '現在の状態',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.folder_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tierシート: ${purchases.maxSheets}個まで',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                purchases.isAdFree
                                    ? Icons.check_circle
                                    : Icons.ads_click,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                purchases.isAdFree ? '広告なし' : '広告あり',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (!purchases.isStoreAvailable)
                      const Center(
                        child: Text(
                          'ストアに接続できません',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    else ...[
                      const Text(
                        '購入可能なアイテム',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Additional Sheets Purchase
                      _buildPurchaseCard(
                        context: context,
                        icon: Icons.add_circle_outline,
                        title: 'Tierシート追加',
                        description: 'Tierシートを追加で作成できます',
                        options: [
                          _buildOption(ref, purchases, 'tier_sheet_5', '+5シート'),
                          _buildOption(
                            ref,
                            purchases,
                            'tier_sheet_10',
                            '+10シート',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Ad-Free Purchase
                      _buildPurchaseCard(
                        context: context,
                        icon: Icons.block,
                        title: '広告削除',
                        description: 'すべての広告を非表示にします',
                        options: [
                          _buildOption(
                            ref,
                            purchases,
                            'ad_free',
                            purchases.isAdFree ? '購入済み' : '広告を削除',
                            isPurchased: purchases.isAdFree,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  _PurchaseOption _buildOption(
    WidgetRef ref,
    PurchaseState purchases,
    String productId,
    String label, {
    bool isPurchased = false,
  }) {
    final product = purchases.availableProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => MockProductDetails(
        id: productId,
        title: 'Unknown',
        description: '',
        price: '',
        rawPrice: 0,
        currencyCode: '',
      ),
    );

    // If product is not found (mock), disable it or show placeholder
    // But now we support mock products in provider, so we can enable it if it's a MockProductDetails
    // The only case to disable is if it's truly unknown/empty
    final isUnknown = product.title == 'Unknown';

    return _PurchaseOption(
      label: label,
      price: isPurchased ? '' : (isUnknown ? '---' : product.price),
      onTap: (isPurchased || isUnknown)
          ? null
          : () => _showPurchaseDialog(ref.context, ref, product),
    );
  }

  Widget _buildPurchaseCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required List<_PurchaseOption> options,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFFB7B2), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: option.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: option.onTap == null
                        ? Colors.grey[300]
                        : const Color(0xFFFFB7B2),
                    foregroundColor: option.onTap == null
                        ? Colors.grey[600]
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (option.price.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          option.price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    WidgetRef ref,
    ProductDetails product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('購入確認'),
        content: Text('「${product.title}」を購入しますか？\n価格: ${product.price}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(purchasesProvider.notifier).buyProduct(product);
            },
            child: const Text('購入'),
          ),
        ],
      ),
    );
  }
}

class _PurchaseOption {
  final String label;
  final String price;
  final VoidCallback? onTap;

  _PurchaseOption({required this.label, required this.price, this.onTap});
}
