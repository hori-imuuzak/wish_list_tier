import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/data/providers.dart';
import 'package:wish_list_tier/data/repositories/iap_repository.dart';

part 'purchase_provider.g.dart';

@riverpod
class Purchases extends _$Purchases {
  static const String _maxSheetsField = 'maxSheets';
  static const String _adFreeField = 'adFree';

  // Product IDs
  static const String _kConsumableId5 = 'tier_sheet_5';
  static const String _kConsumableId10 = 'tier_sheet_10';
  static const String _kNonConsumableIdAdFree = 'ad_free';
  static const Set<String> _kProductIds = {
    _kConsumableId5,
    _kConsumableId10,
    _kNonConsumableIdAdFree,
  };

  late IAPRepository _iapRepository;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  DocumentReference get _userDoc {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';
    return ref.read(firebaseFirestoreProvider).collection('users').doc(userId);
  }

  @override
  PurchaseState build() {
    _iapRepository = ref.watch(iapRepositoryProvider);
    _initIAP();
    _loadPurchases();

    // Dispose subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const PurchaseState(
      maxSheets: 2,
      isAdFree: false,
      availableProducts: [],
      isStoreAvailable: false,
      isLoading: true,
    );
  }

  Future<void> _initIAP() async {
    await _iapRepository.initialize();
    final isAvailable = _iapRepository.isAvailable;

    if (isAvailable) {
      final products = await _iapRepository.fetchProducts(_kProductIds);
      if (products.isNotEmpty) {
        state = state.copyWith(
          isStoreAvailable: true,
          availableProducts: products,
          isLoading: false,
        );
      } else {
        // Fallback to mock products for testing if store returns nothing
        _setupMockProducts();
      }

      _subscription = _iapRepository.purchaseStream.listen(
        _onPurchaseUpdates,
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
          // Handle error
        },
      );
    } else {
      // Fallback to mock products if store is unavailable (e.g. Simulator)
      _setupMockProducts();
    }
  }

  void _setupMockProducts() {
    final mockProducts = [
      MockProductDetails(
        id: _kConsumableId5,
        title: 'Tierシート +5 (Test)',
        description: 'Testing +5 sheets',
        price: '¥120',
        rawPrice: 120,
        currencyCode: 'JPY',
      ),
      MockProductDetails(
        id: _kConsumableId10,
        title: 'Tierシート +10 (Test)',
        description: 'Testing +10 sheets',
        price: '¥240',
        rawPrice: 240,
        currencyCode: 'JPY',
      ),
      MockProductDetails(
        id: _kNonConsumableIdAdFree,
        title: '広告削除 (Test)',
        description: 'Testing Ad Free',
        price: '¥370',
        rawPrice: 370,
        currencyCode: 'JPY',
      ),
    ];
    state = state.copyWith(
      isStoreAvailable: true, // Pretend store is available
      availableProducts: mockProducts,
      isLoading: false,
    );
  }

  Future<void> _loadPurchases() async {
    try {
      final doc = await _userDoc.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final maxSheets = (data?[_maxSheetsField] as int?) ?? 2;
        final isAdFree = (data?[_adFreeField] as bool?) ?? false;
        state = state.copyWith(maxSheets: maxSheets, isAdFree: isAdFree);
      }
    } catch (e) {
      // If error, keep default values
    }
  }

  void _onPurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _deliverProduct(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _iapRepository.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == _kConsumableId5) {
      await purchaseAdditionalSheets(5);
    } else if (purchaseDetails.productID == _kConsumableId10) {
      await purchaseAdditionalSheets(10);
    } else if (purchaseDetails.productID == _kNonConsumableIdAdFree) {
      await purchaseAdFree();
    }
  }

  Future<void> purchaseAdditionalSheets(int count) async {
    final newMax = state.maxSheets + count;
    await _userDoc.set({_maxSheetsField: newMax}, SetOptions(merge: true));
    state = state.copyWith(maxSheets: newMax);
  }

  Future<void> purchaseAdFree() async {
    await _userDoc.set({_adFreeField: true}, SetOptions(merge: true));
    state = state.copyWith(isAdFree: true);
  }

  Future<void> buyProduct(ProductDetails product) async {
    if (product is MockProductDetails) {
      // Simulate purchase for mock products
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      final purchaseDetails = PurchaseDetails(
        purchaseID: 'mock_purchase_${DateTime.now().millisecondsSinceEpoch}',
        productID: product.id,
        verificationData: PurchaseVerificationData(
          localVerificationData: 'mock',
          serverVerificationData: 'mock',
          source: 'mock',
        ),
        transactionDate: DateTime.now().toString(),
        status: PurchaseStatus.purchased,
      );
      _deliverProduct(purchaseDetails);
      return;
    }

    if (product.id == _kNonConsumableIdAdFree) {
      await _iapRepository.buyNonConsumable(product);
    } else {
      await _iapRepository.buyConsumable(product);
    }
  }

  Future<void> restorePurchases() async {
    await _iapRepository.restorePurchases();
  }
}

class MockProductDetails implements ProductDetails {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String price;
  @override
  final double rawPrice;
  @override
  final String currencyCode;
  @override
  String get currencySymbol => '';

  MockProductDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
  });
}

class PurchaseState {
  final int maxSheets;
  final bool isAdFree;
  final List<ProductDetails> availableProducts;
  final bool isStoreAvailable;
  final bool isLoading;

  const PurchaseState({
    required this.maxSheets,
    required this.isAdFree,
    this.availableProducts = const [],
    this.isStoreAvailable = false,
    this.isLoading = true,
  });

  PurchaseState copyWith({
    int? maxSheets,
    bool? isAdFree,
    List<ProductDetails>? availableProducts,
    bool? isStoreAvailable,
    bool? isLoading,
  }) {
    return PurchaseState(
      maxSheets: maxSheets ?? this.maxSheets,
      isAdFree: isAdFree ?? this.isAdFree,
      availableProducts: availableProducts ?? this.availableProducts,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
