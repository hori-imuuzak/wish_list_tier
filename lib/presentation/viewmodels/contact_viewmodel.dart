import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wish_list_tier/domain/usecases/command/send_inquiry_usecase.dart';
import 'package:wish_list_tier/domain/usecases/providers.dart';

part 'contact_viewmodel.g.dart';

@riverpod
class ContactViewModel extends _$ContactViewModel {
  late SendInquiryUseCase _sendInquiryUseCase;

  @override
  ContactState build() {
    _sendInquiryUseCase = ref.read(sendInquiryUseCaseProvider);
    return const ContactState();
  }

  Future<bool> sendInquiry({
    required String title,
    required String body,
    String? email,
  }) async {
    if (!ref.mounted) return false;
    state = state.copyWith(isLoading: true, error: null);

    final result = await _sendInquiryUseCase(
      title: title,
      body: body,
      email: email,
    );

    if (!ref.mounted) return false;

    return result.when(
      success: (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
      failure: (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
        return false;
      },
    );
  }
}

class ContactState {
  final bool isLoading;
  final String? error;

  const ContactState({
    this.isLoading = false,
    this.error,
  });

  ContactState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ContactState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
