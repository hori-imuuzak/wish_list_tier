# Wish List Tier

欲しいものをTierランク（SS〜G）で管理できるFlutterアプリケーション。

## 機能

### コア機能
- **Tierランク管理**: SS, S, A, B, C, D, E, F, G の9段階でアイテムを分類
- **ドラッグ&ドロップ**: アイテムをTier間で直感的に移動
- **カテゴリ管理**: 複数のTierシートをカテゴリ別に管理（タブ切り替え）
- **アイテム詳細**: タイトル、説明、価格、URL、期限、画像を登録可能
- **メモ機能**: アイテムにコメント/メモを追加

### その他の機能
- **アーカイブ**: 完了済み・削除済みアイテムの管理と復元
- **お問い合わせ**: アプリ内からフィードバック送信
- **アプリ内課金**: Tierシート追加、広告削除

## 技術スタック

### フレームワーク・言語
- Flutter 3.9+
- Dart

### 状態管理
- Riverpod 3.x（riverpod_annotation + riverpod_generator）

### データ永続化
- Firebase Auth（匿名認証）
- Cloud Firestore（クラウド同期）
- SharedPreferences（ローカルストレージ、フォールバック用）

### コード生成
- freezed（イミュータブルモデル）
- json_serializable（JSON シリアライズ）

### その他
- in_app_purchase（アプリ内課金）
- image_picker（画像選択）
- url_launcher（外部URL起動）

## アーキテクチャ

クリーンアーキテクチャをベースとした3層構造を採用。

```
lib/
├── data/                    # データ層
│   ├── datasources/         # データソース（未使用・将来拡張用）
│   ├── providers/           # Riverpod プロバイダー（IAP、Plan等）
│   └── repositories/        # リポジトリ実装
│
├── domain/                  # ドメイン層
│   ├── models/              # ドメインモデル（freezed）
│   ├── repositories/        # リポジトリインターフェース
│   └── usecases/            # ユースケース
│       ├── command/         # 副作用を伴う操作（CUD）
│       └── query/           # データ取得（R）
│
└── presentation/            # プレゼンテーション層
    ├── screens/             # 画面Widget
    ├── viewmodels/          # ViewModel（Riverpod Notifier）
    └── widgets/             # 共通Widget（未使用・将来拡張用）
```

### レイヤー間の依存関係

```
Presentation → Domain ← Data
     ↓            ↑        ↓
ViewModel → UseCase ← Repository
```

- **Presentation**: UIとユーザーインタラクション
- **Domain**: ビジネスロジック（UseCaseとモデル）
- **Data**: データアクセスと外部サービス連携

### UseCase パターン

UseCaseは `UseCaseResult<T>` を返却し、成功/失敗を型で判別。

```dart
sealed class UseCaseResult<T> {
  factory UseCaseResult.success(T value) = UseCaseResultSuccess<T>;
  factory UseCaseResult.failure(Exception e) = UseCaseResultFailure<T>;
}

// 使用例
final result = await getItemsUseCase();
result.when(
  success: (items) => /* 成功時の処理 */,
  failure: (e) => /* エラー処理 */,
);
```

## ドメインモデル

### WishItem
```dart
- id: String（UUID）
- title: String
- description: String
- categoryId: String?
- imagePath: String?
- price: double?
- url: String?
- deadline: DateTime?
- tier: TierType（SS〜G）
- comments: List<Comment>
- isCompleted: bool
- isDeleted: bool（ソフトデリート）
- createdAt: DateTime
- updatedAt: DateTime
```

### Category
```dart
- id: String（UUID）
- name: String
- createdAt: DateTime
```

### TierType
```dart
enum TierType { ss, s, a, b, c, d, e, f, g }
```

## 開発

### 必要要件
- Flutter SDK 3.9+
- FVM（推奨）

### セットアップ

```bash
# 依存関係インストール
flutter pub get

# コード生成
flutter pub run build_runner build --delete-conflicting-outputs

# 実行
flutter run
```

### コード生成

freezed/riverpod_generatorを使用しているため、モデルやプロバイダーを変更した場合は再生成が必要。

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 静的解析

```bash
flutter analyze
```
