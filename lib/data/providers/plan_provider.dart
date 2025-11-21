import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/data/providers.dart';
import 'package:wish_list_tier/domain/models/plan_type.dart';

part 'plan_provider.g.dart';

@riverpod
class Plan extends _$Plan {
  static const String _planField = 'plan';

  DocumentReference get _userDoc {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';
    return ref.read(firebaseFirestoreProvider).collection('users').doc(userId);
  }

  @override
  PlanType build() {
    // Default to basic, will be updated from Firestore
    _loadPlan();
    return PlanType.basic;
  }

  Future<void> _loadPlan() async {
    try {
      final doc = await _userDoc.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final planString = data?[_planField] as String?;
        if (planString == 'pro') {
          state = PlanType.pro;
        }
      }
    } catch (e) {
      // If error, keep default basic plan
    }
  }

  Future<void> upgradeToPro() async {
    await _userDoc.set({_planField: 'pro'}, SetOptions(merge: true));
    state = PlanType.pro;
  }

  Future<void> downgradeToBasic() async {
    await _userDoc.set({_planField: 'basic'}, SetOptions(merge: true));
    state = PlanType.basic;
  }
}
