import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class CompleteItemUseCase {
  final WishListRepository _repository;

  CompleteItemUseCase(this._repository);

  Future<void> call(String id, {bool isCompleted = true}) {
    return _repository.completeItem(id, isCompleted);
  }
}
