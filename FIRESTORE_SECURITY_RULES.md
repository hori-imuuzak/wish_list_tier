# Firestore Security Rules

以下のセキュリティルールをFirebase Consoleで設定してください。

## セキュリティルール

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ユーザーごとのデータへのアクセス制御
    match /users/{userId}/{document=**} {
      // 認証済みユーザーのみが自分のuidのデータにアクセス可能
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 設定手順

1. [Firebase Console](https://console.firebase.google.com/) にアクセス
2. プロジェクトを選択
3. 左側メニューから「Firestore Database」を選択
4. 「ルール」タブをクリック
5. 上記のルールをコピー＆ペースト
6. 「公開」ボタンをクリック

## セキュリティルールの説明

- `request.auth != null`: ユーザーが認証済みであることを確認
- `request.auth.uid == userId`: リクエストしているユーザーのuidとドキュメントのuserIdが一致することを確認
- `{document=**}`: `users/{userId}` 配下のすべてのドキュメントとサブコレクションに適用

これにより、各ユーザーは自分のデータのみ読み書きでき、他のユーザーのデータにはアクセスできません。
