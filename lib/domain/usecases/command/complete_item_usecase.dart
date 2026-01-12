import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class CompleteItemUseCase {
  final WishListRepository _repository;

  CompleteItemUseCase(this._repository);

  Future<UseCaseResult<void>> call(String id, {bool isCompleted = true}) async {
    try {
      await _repository.completeItem(id, isCompleted);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
