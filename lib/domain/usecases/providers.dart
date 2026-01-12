import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/data/providers.dart';

// Query usecases
import 'package:wish_list_tier/domain/usecases/query/get_items_usecase.dart';
import 'package:wish_list_tier/domain/usecases/query/get_categories_usecase.dart';

// Command usecases
import 'package:wish_list_tier/domain/usecases/command/add_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/update_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/delete_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/move_item_to_tier_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/complete_item_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/add_category_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/delete_category_usecase.dart';
import 'package:wish_list_tier/domain/usecases/command/send_inquiry_usecase.dart';

part 'providers.g.dart';

// Query providers
@riverpod
GetItemsUseCase getItemsUseCase(Ref ref) {
  return GetItemsUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) {
  return GetCategoriesUseCase(ref.watch(wishListRepositoryProvider));
}

// Command providers
@riverpod
AddItemUseCase addItemUseCase(Ref ref) {
  return AddItemUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
UpdateItemUseCase updateItemUseCase(Ref ref) {
  return UpdateItemUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
DeleteItemUseCase deleteItemUseCase(Ref ref) {
  return DeleteItemUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
MoveItemToTierUseCase moveItemToTierUseCase(Ref ref) {
  return MoveItemToTierUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
CompleteItemUseCase completeItemUseCase(Ref ref) {
  return CompleteItemUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
AddCategoryUseCase addCategoryUseCase(Ref ref) {
  return AddCategoryUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
DeleteCategoryUseCase deleteCategoryUseCase(Ref ref) {
  return DeleteCategoryUseCase(ref.watch(wishListRepositoryProvider));
}

@riverpod
SendInquiryUseCase sendInquiryUseCase(Ref ref) {
  return SendInquiryUseCase(ref.watch(inquiryRepositoryProvider));
}
