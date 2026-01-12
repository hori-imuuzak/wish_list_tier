import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class AddItemUseCase {
  final WishListRepository _repository;

  AddItemUseCase(this._repository);

  Future<UseCaseResult<void>> call(WishItem item) async {
    try {
      await _repository.addItem(item);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
