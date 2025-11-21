import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class FirebaseWishListRepository implements WishListRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseWishListRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('users').doc(_userId).collection('categories');

  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      _firestore.collection('users').doc(_userId).collection('items');

  /// Initialize: Sign in anonymously and migrate data if needed
  Future<void> initialize() async {
    // Sign in anonymously if not already signed in
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  @override
  Future<List<WishItem>> getItems() async {
    final snapshot = await _itemsCollection.get();
    return snapshot.docs.map((doc) => WishItem.fromJson(doc.data())).toList();
  }

  @override
  Future<void> addItem(WishItem item) async {
    await _itemsCollection.doc(item.id).set(item.toJson());
  }

  @override
  Future<void> updateItem(WishItem item) async {
    await _itemsCollection.doc(item.id).update(item.toJson());
  }

  @override
  Future<void> deleteItem(String id, bool isDeleted) async {
    final doc = await _itemsCollection.doc(id).get();
    if (doc.exists) {
      final item = WishItem.fromJson(doc.data()!);
      await _itemsCollection
          .doc(id)
          .update(
            item
                .copyWith(isDeleted: isDeleted, updatedAt: DateTime.now())
                .toJson(),
          );
    }
  }

  @override
  Future<void> moveItemToTier(String id, TierType tier) async {
    final doc = await _itemsCollection.doc(id).get();
    if (doc.exists) {
      final item = WishItem.fromJson(doc.data()!);
      await _itemsCollection
          .doc(id)
          .update(
            item.copyWith(tier: tier, updatedAt: DateTime.now()).toJson(),
          );
    }
  }

  @override
  Future<void> completeItem(String id, bool isCompleted) async {
    final doc = await _itemsCollection.doc(id).get();
    if (doc.exists) {
      final item = WishItem.fromJson(doc.data()!);
      await _itemsCollection
          .doc(id)
          .update(
            item
                .copyWith(isCompleted: isCompleted, updatedAt: DateTime.now())
                .toJson(),
          );
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final snapshot = await _categoriesCollection.get();
    return snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    await _categoriesCollection.doc(category.id).set(category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    // Delete category
    await _categoriesCollection.doc(id).delete();

    // Delete associated items
    final itemsSnapshot = await _itemsCollection
        .where('categoryId', isEqualTo: id)
        .get();

    for (final doc in itemsSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
