import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_tier/data/repositories/firebase_wish_list_repository.dart';
import 'package:wish_list_tier/data/repositories/iap_repository.dart';
import 'package:wish_list_tier/data/repositories/inquiry_repository_impl.dart';
import 'package:wish_list_tier/domain/repositories/inquiry_repository.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
WishListRepository wishListRepository(Ref ref) {
  return FirebaseWishListRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

@Riverpod(keepAlive: true)
IAPRepository iapRepository(Ref ref) {
  return IAPRepository();
}

const _slackWebhookUrl =
    'https://hooks.slack.com/services/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';

@Riverpod(keepAlive: true)
InquiryRepository inquiryRepository(Ref ref) {
  return InquiryRepositoryImpl(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    slackWebhookUrl: _slackWebhookUrl,
  );
}
