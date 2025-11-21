import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/data/providers.dart';

part 'purchase_provider.g.dart';

@riverpod
class Purchases extends _$Purchases {
  static const String _maxSheetsField = 'maxSheets';
  static const String _adFreeField = 'adFree';

  DocumentReference get _userDoc {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';
    return ref.read(firebaseFirestoreProvider).collection('users').doc(userId);
  }

  @override
  PurchaseState build() {
    _loadPurchases();
    return const PurchaseState(maxSheets: 2, isAdFree: false);
  }

  Future<void> _loadPurchases() async {
    try {
      final doc = await _userDoc.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final maxSheets = (data?[_maxSheetsField] as int?) ?? 2;
        final isAdFree = (data?[_adFreeField] as bool?) ?? false;
        state = PurchaseState(maxSheets: maxSheets, isAdFree: isAdFree);
      }
    } catch (e) {
      // If error, keep default values
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
}

class PurchaseState {
  final int maxSheets;
  final bool isAdFree;

  const PurchaseState({required this.maxSheets, required this.isAdFree});

  PurchaseState copyWith({int? maxSheets, bool? isAdFree}) {
    return PurchaseState(
      maxSheets: maxSheets ?? this.maxSheets,
      isAdFree: isAdFree ?? this.isAdFree,
    );
  }
}
