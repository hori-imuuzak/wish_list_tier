enum PlanType {
  basic,
  pro;

  String get label {
    switch (this) {
      case PlanType.basic:
        return 'Basic';
      case PlanType.pro:
        return 'Pro';
    }
  }

  String get description {
    switch (this) {
      case PlanType.basic:
        return '無料プラン';
      case PlanType.pro:
        return 'プレミアムプラン';
    }
  }

  List<String> get features {
    switch (this) {
      case PlanType.basic:
        return ['カテゴリ2つまで作成可能', '基本的なTier管理機能', 'アーカイブ機能'];
      case PlanType.pro:
        return ['Tierシートが10個まで作成可能', '基本的なTier管理機能', 'アーカイブ機能', '広告の非表示'];
    }
  }
}
