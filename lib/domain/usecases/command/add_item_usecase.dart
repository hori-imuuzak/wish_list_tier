import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class AddItemUseCase {
  final WishListRepository _repository;

  AddItemUseCase(this._repository);

  Future<void> call(WishItem item) {
    return _repository.addItem(item);
  }
}
