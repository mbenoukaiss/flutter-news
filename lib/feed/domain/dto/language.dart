enum Language {
  ar,
  de,
  en,
  es,
  fr,
  hi,
  it,
  nl,
  no,
  pt,
  ru,
  sv,
  ud,
  zh;

  String formatted() {
    switch (this) {
      case Language.ar:
        return "Arabic";
      case Language.de:
        return "German";
      case Language.en:
        return "English";
      case Language.es:
        return "Spanish";
      case Language.fr:
        return "French";
      case Language.hi:
        return "Hindi";
      case Language.it:
        return "Italian";
      case Language.nl:
        return "Dutch";
      case Language.no:
        return "Norwegian";
      case Language.pt:
        return "Portuguese";
      case Language.ru:
        return "Russian";
      case Language.sv:
        return "Swedish";
      case Language.ud:
        return "Urdu";
      case Language.zh:
        return "Chinese";
    }
  }
}
