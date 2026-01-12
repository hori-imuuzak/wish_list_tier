import 'package:wish_list_tier/domain/models/category.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class AddCategoryUseCase {
  final WishListRepository _repository;

  AddCategoryUseCase(this._repository);

  Future<UseCaseResult<void>> call(Category category) async {
    try {
      await _repository.addCategory(category);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
