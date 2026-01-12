import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/models/wish_item.dart';

abstract class WishListRepository {
  Future<List<WishItem>> getItems();
  Future<void> addItem(WishItem item);
  Future<void> updateItem(WishItem item);
  Future<void> deleteItem(String id, bool isDeleted); // Soft delete
  Future<void> moveItemToTier(String id, TierType tier);
  Future<void> completeItem(String id, bool isCompleted);

  // Category methods
  Future<List<Category>> getCategories();
  Future<void> addCategory(Category category);
  Future<void> deleteCategory(String id);
}
