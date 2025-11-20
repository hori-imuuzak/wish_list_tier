import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class LocalWishListRepository implements WishListRepository {
  static const String _storageKey = 'wish_list_items';
  final SharedPreferences _prefs;

  LocalWishListRepository(this._prefs);

  @override
  Future<List<WishItem>> getItems() async {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => WishItem.fromJson(json)).toList();
  }

  Future<void> _saveItems(List<WishItem> items) async {
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, jsonString);
  }

  @override
  Future<void> addItem(WishItem item) async {
    final items = await getItems();
    items.add(item);
    await _saveItems(items);
  }

  @override
  Future<void> updateItem(WishItem item) async {
    final items = await getItems();
    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = item.copyWith(updatedAt: DateTime.now());
      await _saveItems(items);
    }
  }

  @override
  Future<void> deleteItem(String id, bool isDeleted) async {
    final items = await getItems();
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      items[index] = items[index].copyWith(
        isDeleted: isDeleted,
        updatedAt: DateTime.now(),
      );
      await _saveItems(items);
    }
  }

  @override
  Future<void> moveItemToTier(String id, TierType tier) async {
    final items = await getItems();
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      items[index] = items[index].copyWith(
        tier: tier,
        updatedAt: DateTime.now(),
      );
      await _saveItems(items);
    }
  }

  @override
  Future<void> completeItem(String id, bool isCompleted) async {
    final items = await getItems();
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      items[index] = items[index].copyWith(
        isCompleted: isCompleted,
        updatedAt: DateTime.now(),
      );
      await _saveItems(items);
    }
  }
}
