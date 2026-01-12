import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class DeleteItemUseCase {
  final WishListRepository _repository;

  DeleteItemUseCase(this._repository);

  Future<UseCaseResult<void>> call(String id, {bool isDeleted = true}) async {
    try {
      await _repository.deleteItem(id, isDeleted);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
