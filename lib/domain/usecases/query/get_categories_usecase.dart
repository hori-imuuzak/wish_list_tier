import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class GetCategoriesUseCase {
  final WishListRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<UseCaseResult<List<Category>>> call() async {
    try {
      final categories = await _repository.getCategories();
      return UseCaseResult.success(categories);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
