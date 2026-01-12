import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class AddCategoryUseCase {
  final WishListRepository _repository;

  AddCategoryUseCase(this._repository);

  Future<void> call(Category category) {
    return _repository.addCategory(category);
  }
}
