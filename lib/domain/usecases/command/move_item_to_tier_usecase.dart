import 'package:wish_list_tier/domain/models/tier_type.dart';
import 'package:wish_list_tier/domain/repositories/wish_list_repository.dart';

class MoveItemToTierUseCase {
  final WishListRepository _repository;

  MoveItemToTierUseCase(this._repository);

  Future<void> call(String id, TierType tier) {
    return _repository.moveItemToTier(id, tier);
  }
}
