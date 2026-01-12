import 'package:wish_list_tier/domain/models/wish_item.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class GetItemsUseCase {
  final WishListRepository _repository;

  GetItemsUseCase(this._repository);

  Future<UseCaseResult<List<WishItem>>> call() async {
    try {
      final items = await _repository.getItems();
      return UseCaseResult.success(items);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
