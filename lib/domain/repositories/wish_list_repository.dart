import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';

abstract class WishListRepository {
  Future<List<WishItem>> getItems();
  Future<void> addItem(WishItem item);
  Future<void> updateItem(WishItem item);

  Future<void> moveItemToTier(String id, TierType tier);
  Future<void> completeItem(String id, bool isCompleted);
  Future<void> deleteItem(String id, bool isDeleted); // Soft delete
  // Future<void> completeItem(String id); // updateItemでTierを変えるか、完了フラグを持つか。今回はTier表の外に移動なら別リスト管理かも。
  // 一旦完了リストへの移動は、TierTypeに完了を含めるか、別のステータスを持つか。
  // 要件: "購入完了したものは完了リストに移動できるようにする"
  // 完了リストはTierとは別概念っぽいので、WishItemにisCompletedフラグを持たせるか、完了用のTierを作るか。
  // ここではシンプルに isCompleted フラグを持たせ、Tier表からは除外する方針にするか、
  // あるいはRepositoryで getCompletedItems() を分けるか。

  // 修正: WishItemには isCompleted がないので、TierType以外で管理する必要があるか、
  // あるいは完了リストという特別な場所がある。
  // プロトタイプなので、完了済みアイテムを取得するメソッドを追加し、
  // データ上は同じリストで管理しつつフィルタリングする形にする。

  // しかしModelに isCompleted がない。
  // Modelを修正するか、TierTypeに completed を足すか。
  // TierTypeは SS-G なので completed は違和感あるが、管理上は楽。
  // いや、Modelに isCompleted を足そう。
}
