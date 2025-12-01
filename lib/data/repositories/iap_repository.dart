import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class IAPRepository {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final StreamController<List<PurchaseDetails>> _purchaseController =
      StreamController.broadcast();

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _iap
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }
    }

    _subscription = _iap.purchaseStream.listen(
      (purchaseDetailsList) {
        _purchaseController.add(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error here.
      },
    );
  }

  Future<List<ProductDetails>> fetchProducts(Set<String> ids) async {
    if (!_isAvailable) return [];
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    if (response.error != null) {
      debugPrint('IAP Error: ${response.error!.message}');
      return [];
    }
    return response.productDetails;
  }

  Future<void> buyConsumable(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> buyNonConsumable(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  void dispose() {
    _subscription.cancel();
    _purchaseController.close();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
