import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_tier/domain/models/category.dart';
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

  @override
  Future<List<Category>> getCategories() async {
    final jsonString = _prefs.getString('wish_list_categories');
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final jsonString = jsonEncode(categories.map((e) => e.toJson()).toList());
    await _prefs.setString('wish_list_categories', jsonString);
  }

  @override
  Future<void> addCategory(Category category) async {
    final categories = await getCategories();
    categories.add(category);
    await _saveCategories(categories);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final categories = await getCategories();
    categories.removeWhere((e) => e.id == id);
    await _saveCategories(categories);

    // Delete associated items
    final items = await getItems();
    items.removeWhere((e) => e.categoryId == id);
    await _saveItems(items);
  }
}
