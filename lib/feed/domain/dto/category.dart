enum Category {
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
      case Category.business:
        return "Business";
      case Category.entertainment:
        return "Entertainment";
      case Category.general:
        return "General";
      case Category.health:
        return "Health";
      case Category.science:
        return "Science";
      case Category.sports:
        return "Sports";
      case Category.technology:
        return "Technology";
    }
  }
}
