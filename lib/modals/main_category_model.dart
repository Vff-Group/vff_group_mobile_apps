class MainCategoryModel {
  final String categoryId;
  final String categoryName;
  final String categoryBGUrl;
  final String regularPrice;
  final String regularPriceType;
  final String expressPrice;
  final String expressPriceType;
  final String offerPrice;
  final String offerPriceType;
  final String description;
  final String minHours;

  MainCategoryModel(
      {required this.categoryId,
      required this.categoryName,
      required this.categoryBGUrl, 
      required this.regularPrice,
      required this.regularPriceType,
      required this.expressPrice,
      required this.expressPriceType,
      required this.offerPrice,
      required this.offerPriceType,
      required this.description,
      required this.minHours,});
}
