import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class DeleteCategoryUseCase {
  final WishListRepository _repository;

  DeleteCategoryUseCase(this._repository);

  Future<UseCaseResult<void>> call(String id) async {
    try {
      await _repository.deleteCategory(id);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
