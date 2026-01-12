import 'package:wish_list_tier/domain/repositories/inquiry_repository.dart';
import 'package:wish_list_tier/domain/usecases/usecase_result.dart';

class SendInquiryUseCase {
  final InquiryRepository _repository;

  SendInquiryUseCase(this._repository);

  Future<UseCaseResult<void>> call({
    required String title,
    required String body,
    String? email,
  }) async {
    try {
      await _repository.sendInquiry(
        title: title,
        body: body,
        email: email,
      );
      return UseCaseResult.success(null);
    } on Exception catch (e) {
      return UseCaseResult.failure(e);
    }
  }
}
