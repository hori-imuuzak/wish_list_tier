abstract class InquiryRepository {
  Future<void> sendInquiry({
    required String title,
    required String body,
    String? email,
  });
}
