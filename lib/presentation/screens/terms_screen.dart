import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('利用規約')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: '第1条（適用）',
                content: '本規約は、本アプリの利用に関する条件を、本アプリを利用するすべてのユーザーと当社との間で定めるものです。',
              ),
              _buildSection(
                title: '第2条（利用登録）',
                content:
                    '本アプリでは、匿名での利用が可能です。ユーザーは、本アプリを起動することで、本規約に同意したものとみなされます。',
              ),
              _buildSection(
                title: '第3条（禁止事項）',
                content: '''
ユーザーは、本アプリの利用にあたり、以下の行為をしてはなりません。

1. 法令または公序良俗に違反する行為
2. 犯罪行為に関連する行為
3. 本アプリの内容等、本アプリに含まれる著作権、商標権ほか知的財産権を侵害する行為
4. 当社、ほかのユーザー、またはその他第三者のサーバーまたはネットワークの機能を破壊したり、妨害したりする行為
5. 本アプリによって得られた情報を商業的に利用する行為
6. 当社のサービスの運営を妨害するおそれのある行為
7. 不正アクセスをし、またはこれを試みる行為
8. 他のユーザーに関する個人情報等を収集または蓄積する行為
9. 不正な目的を持って本アプリを利用する行為
10. その他、当社が不適切と判断する行為''',
              ),
              _buildSection(
                title: '第4条（本アプリの提供の停止等）',
                content:
                    '当社は、以下のいずれかの事由があると判断した場合、ユーザーに事前に通知することなく本アプリの全部または一部の提供を停止または中断することができるものとします。',
              ),
              _buildSection(
                title: '第5条（免責事項）',
                content:
                    '当社は、本アプリに関して、ユーザーと他のユーザーまたは第三者との間において生じた取引、連絡または紛争等について一切責任を負いません。',
              ),
              _buildSection(
                title: '第6条（サービス内容の変更等）',
                content:
                    '当社は、ユーザーへの事前の告知をもって、本アプリの内容を変更、追加または廃止することがあり、ユーザーはこれを承諾するものとします。',
              ),
              _buildSection(
                title: '第7条（利用規約の変更）',
                content: '当社は以下の場合には、ユーザーの個別の同意を要せず、本規約を変更することができるものとします。',
              ),
              _buildSection(
                title: '第8条（個人情報の取扱い）',
                content:
                    '当社は、本アプリの利用によって取得する個人情報については、当社「プライバシーポリシー」に従い適切に取り扱うものとします。',
              ),
              _buildSection(
                title: '第9条（準拠法・裁判管轄）',
                content:
                    '本規約の解釈にあたっては、日本法を準拠法とします。本アプリに関して紛争が生じた場合には、当社の本店所在地を管轄する裁判所を専属的合意管轄とします。',
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '以上',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
