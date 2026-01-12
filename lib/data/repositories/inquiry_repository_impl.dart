import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:wish_list_tier/domain/repositories/inquiry_repository.dart';

class InquiryRepositoryImpl implements InquiryRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String _slackWebhookUrl;

  InquiryRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required String slackWebhookUrl,
  })  : _auth = auth,
        _firestore = firestore,
        _slackWebhookUrl = slackWebhookUrl;

  @override
  Future<void> sendInquiry({
    required String title,
    required String body,
    String? email,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Save to Firestore
    await _firestore.collection('inquiries').add({
      'uid': user.uid,
      'title': title,
      'body': body,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Post to Slack webhook
    final emailInfo = email != null && email.isNotEmpty ? '*連絡先*: $email\n' : '';
    final payload = {
      'text': '*新しいお問い合わせがありました*\n'
          '*uid*: ${user.uid}\n'
          '$emailInfo'
          '*件名*: $title\n'
          '*内容*: $body',
    };
    await http.post(
      Uri.parse(_slackWebhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
  }
}
