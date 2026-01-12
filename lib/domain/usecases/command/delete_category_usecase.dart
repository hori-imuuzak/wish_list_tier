import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class DeleteCategoryUseCase {
  final WishListRepository _repository;

  DeleteCategoryUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteCategory(id);
  }
}
