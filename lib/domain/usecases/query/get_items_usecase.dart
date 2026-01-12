import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class GetItemsUseCase {
  final WishListRepository _repository;

  GetItemsUseCase(this._repository);

  Future<List<WishItem>> call() {
    return _repository.getItems();
  }
}
