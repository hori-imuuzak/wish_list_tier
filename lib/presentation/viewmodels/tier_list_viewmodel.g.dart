// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TierListViewModel)
const tierListViewModelProvider = TierListViewModelProvider._();

final class TierListViewModelProvider
    extends $AsyncNotifierProvider<TierListViewModel, List<WishItem>> {
  const TierListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tierListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tierListViewModelHash();

  @$internal
  @override
  TierListViewModel create() => TierListViewModel();
}

String _$tierListViewModelHash() => r'2a172bcae0ce6c0f211d6eb2ebf0d458f898dc19';

abstract class _$TierListViewModel extends $AsyncNotifier<List<WishItem>> {
  FutureOr<List<WishItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<WishItem>>, List<WishItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WishItem>>, List<WishItem>>,
              AsyncValue<List<WishItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
