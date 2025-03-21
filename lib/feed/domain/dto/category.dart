enum ArticleCategory {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology;

  @override
  String toString() {
    switch (this) {
      case ArticleCategory.business:
        return "Business";
      case ArticleCategory.entertainment:
        return "Entertainment";
      case ArticleCategory.general:
        return "General";
      case ArticleCategory.health:
        return "Health";
      case ArticleCategory.science:
        return "Science";
      case ArticleCategory.sports:
        return "Sports";
      case ArticleCategory.technology:
        return "Technology";
    }
  }
}
