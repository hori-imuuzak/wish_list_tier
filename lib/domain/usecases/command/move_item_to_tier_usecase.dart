import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class MoveItemToTierUseCase {
  final WishListRepository _repository;

  MoveItemToTierUseCase(this._repository);

  Future<UseCaseResult<void>> call(String id, TierType tier) async {
    try {
      await _repository.moveItemToTier(id, tier);
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
