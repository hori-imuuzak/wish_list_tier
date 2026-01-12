import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class DeleteItemUseCase {
  final WishListRepository _repository;

  DeleteItemUseCase(this._repository);

  Future<void> call(String id, {bool isDeleted = true}) {
    return _repository.deleteItem(id, isDeleted);
  }
}
