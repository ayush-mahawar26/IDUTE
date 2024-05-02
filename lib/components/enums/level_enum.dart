enum LevelEnum {
  concept('concept'),
  businessModel('businessModel'),
  revenueModel('revenueModel'),
  marketingStrategy('marketingStrategy'),
  launchStrategy('launchStrategy');

  final String level;
  const LevelEnum(this.level);
}

extension ConvertMessage on String {
  LevelEnum toLevelEnum() {
    switch (this) {
      case 'concept':
        return LevelEnum.concept;
      case 'businessModel':
        return LevelEnum.businessModel;
      case 'revenueModel':
        return LevelEnum.revenueModel;
      case 'marketingStrategy':
        return LevelEnum.marketingStrategy;
      case 'launchStrategy':
        return LevelEnum.launchStrategy;
      default:
        return LevelEnum.concept;
    }
  }
}
