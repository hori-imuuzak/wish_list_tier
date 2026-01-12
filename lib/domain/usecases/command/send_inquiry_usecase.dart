import 'package:wish_list_tier/domain/repositories/inquiry_repository.dart';

class SendInquiryUseCase {
  final InquiryRepository _repository;

  SendInquiryUseCase(this._repository);

  Future<void> call({
    required String title,
    required String body,
    String? email,
  }) {
    return _repository.sendInquiry(
      title: title,
      body: body,
      email: email,
    );
  }
}
