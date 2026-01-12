import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class UpdateItemUseCase {
  final WishListRepository _repository;

  UpdateItemUseCase(this._repository);

  Future<UseCaseResult<void>> call(WishItem item) async {
    try {
      await _repository.updateItem(item);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
