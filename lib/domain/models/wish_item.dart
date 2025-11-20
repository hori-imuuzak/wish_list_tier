import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wish_list_tier/domain/models/comment.dart';
import 'package:wish_list_tier/domain/models/tier_type.dart';

part 'wish_item.freezed.dart';
part 'wish_item.g.dart';

@freezed
abstract class WishItem with _$WishItem {
  const factory WishItem({
    required String id,
    required String title,
    @Default('') String description,
    String? imagePath,
    double? price,
    String? url,
    DateTime? deadline,
    @Default(TierType.c) TierType tier,
    @Default(false) bool isCompleted,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<Comment> comments,
  }) = _WishItem;

  factory WishItem.fromJson(Map<String, dynamic> json) =>
      _$WishItemFromJson(json);
}
