import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class GetCategoriesUseCase {
  final WishListRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<List<Category>> call() {
    return _repository.getCategories();
  }
}
