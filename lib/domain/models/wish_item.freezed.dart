// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishItem {

 String get id; String get title; String get description; String? get categoryId; String? get imagePath; double? get price; String? get url; DateTime? get deadline; TierType get tier; bool get isCompleted; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt; List<Comment> get comments;
/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishItemCopyWith<WishItem> get copyWith => _$WishItemCopyWithImpl<WishItem>(this as WishItem, _$identity);

  /// Serializes this WishItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.price, price) || other.price == price)&&(identical(other.url, url) || other.url == url)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.comments, comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,categoryId,imagePath,price,url,deadline,tier,isCompleted,isDeleted,createdAt,updatedAt,const DeepCollectionEquality().hash(comments));

@override
String toString() {
  return 'WishItem(id: $id, title: $title, description: $description, categoryId: $categoryId, imagePath: $imagePath, price: $price, url: $url, deadline: $deadline, tier: $tier, isCompleted: $isCompleted, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $WishItemCopyWith<$Res>  {
  factory $WishItemCopyWith(WishItem value, $Res Function(WishItem) _then) = _$WishItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String? categoryId, String? imagePath, double? price, String? url, DateTime? deadline, TierType tier, bool isCompleted, bool isDeleted, DateTime createdAt, DateTime updatedAt, List<Comment> comments
});




}
/// @nodoc
class _$WishItemCopyWithImpl<$Res>
    implements $WishItemCopyWith<$Res> {
  _$WishItemCopyWithImpl(this._self, this._then);

  final WishItem _self;
  final $Res Function(WishItem) _then;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? categoryId = freezed,Object? imagePath = freezed,Object? price = freezed,Object? url = freezed,Object? deadline = freezed,Object? tier = null,Object? isCompleted = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? comments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as TierType,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,
  ));
}

}


/// Adds pattern-matching-related methods to [WishItem].
extension WishItemPatterns on WishItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishItem value)  $default,){
final _that = this;
switch (_that) {
case _WishItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishItem value)?  $default,){
final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String? categoryId,  String? imagePath,  double? price,  String? url,  DateTime? deadline,  TierType tier,  bool isCompleted,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  List<Comment> comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.categoryId,_that.imagePath,_that.price,_that.url,_that.deadline,_that.tier,_that.isCompleted,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.comments);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String? categoryId,  String? imagePath,  double? price,  String? url,  DateTime? deadline,  TierType tier,  bool isCompleted,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  List<Comment> comments)  $default,) {final _that = this;
switch (_that) {
case _WishItem():
return $default(_that.id,_that.title,_that.description,_that.categoryId,_that.imagePath,_that.price,_that.url,_that.deadline,_that.tier,_that.isCompleted,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.comments);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String? categoryId,  String? imagePath,  double? price,  String? url,  DateTime? deadline,  TierType tier,  bool isCompleted,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  List<Comment> comments)?  $default,) {final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.categoryId,_that.imagePath,_that.price,_that.url,_that.deadline,_that.tier,_that.isCompleted,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishItem implements WishItem {
  const _WishItem({required this.id, required this.title, this.description = '', this.categoryId, this.imagePath, this.price, this.url, this.deadline, this.tier = TierType.c, this.isCompleted = false, this.isDeleted = false, required this.createdAt, required this.updatedAt, final  List<Comment> comments = const []}): _comments = comments;
  factory _WishItem.fromJson(Map<String, dynamic> json) => _$WishItemFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override final  String? categoryId;
@override final  String? imagePath;
@override final  double? price;
@override final  String? url;
@override final  DateTime? deadline;
@override@JsonKey() final  TierType tier;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<Comment> _comments;
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}


/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishItemCopyWith<_WishItem> get copyWith => __$WishItemCopyWithImpl<_WishItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.price, price) || other.price == price)&&(identical(other.url, url) || other.url == url)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,categoryId,imagePath,price,url,deadline,tier,isCompleted,isDeleted,createdAt,updatedAt,const DeepCollectionEquality().hash(_comments));

@override
String toString() {
  return 'WishItem(id: $id, title: $title, description: $description, categoryId: $categoryId, imagePath: $imagePath, price: $price, url: $url, deadline: $deadline, tier: $tier, isCompleted: $isCompleted, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$WishItemCopyWith<$Res> implements $WishItemCopyWith<$Res> {
  factory _$WishItemCopyWith(_WishItem value, $Res Function(_WishItem) _then) = __$WishItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String? categoryId, String? imagePath, double? price, String? url, DateTime? deadline, TierType tier, bool isCompleted, bool isDeleted, DateTime createdAt, DateTime updatedAt, List<Comment> comments
});




}
/// @nodoc
class __$WishItemCopyWithImpl<$Res>
    implements _$WishItemCopyWith<$Res> {
  __$WishItemCopyWithImpl(this._self, this._then);

  final _WishItem _self;
  final $Res Function(_WishItem) _then;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? categoryId = freezed,Object? imagePath = freezed,Object? price = freezed,Object? url = freezed,Object? deadline = freezed,Object? tier = null,Object? isCompleted = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? comments = null,}) {
  return _then(_WishItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as TierType,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,
  ));
}


}

// dart format on
