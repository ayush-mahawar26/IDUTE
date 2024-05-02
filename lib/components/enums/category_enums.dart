enum CategoryEnum {
  technology('technology'),
  business('business'),
  fashion('fashion'),
  legal('legal'),
  science('science'),
  history('history'),
  arts('arts');

  final String category;

  const CategoryEnum(this.category);
}

extension ConvertMessage on String {
  CategoryEnum toCategoryEnum() {
    switch (this) {
      case 'technology':
        return CategoryEnum.technology;
      case 'business':
        return CategoryEnum.business;
      case 'fashion':
        return CategoryEnum.fashion;
      case 'legal':
        return CategoryEnum.legal;
      case 'science':
        return CategoryEnum.science;
      case 'arts':
        return CategoryEnum.arts;
      case 'history':
        return CategoryEnum.history;
      default:
        return CategoryEnum.technology;
    }
  }
}

extension ConvertEnum on CategoryEnum {
  String fromCategoryEnum() {
    switch (this) {
      case CategoryEnum.technology:
        return 'Technology';
      case CategoryEnum.business:
        return 'Business';
      case CategoryEnum.fashion:
        return 'Fashion';
      case CategoryEnum.legal:
        return 'Legal';
      case CategoryEnum.science:
        return 'Science';
      case CategoryEnum.arts:
        return 'Arts';
      case CategoryEnum.history:
        return 'History';
      default:
        return 'Technology';
    }
  }
}
