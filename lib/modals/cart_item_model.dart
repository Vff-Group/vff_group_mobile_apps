class CartItemModel {
  final String itemID;
  final String categoryID;
  final String subCategoryID;
  final String totalQuantity;
  final String totalPrice;
  final String orderID;
  final String date;
  final String time;
  final String orderType;
  final String totalAdultCost;
  final String totalKidsCost;
  final String categoryImage;
  final String categoryName;
  final String subCategoryName;
  final String subCategoryImage;
  final String actualCost;

  CartItemModel(
      {required this.itemID,
      required this.categoryID,
      required this.subCategoryID,
      required this.totalQuantity,
      required this.totalPrice,
      required this.orderID,
      required this.date,
      required this.time,
      required this.orderType,
      required this.totalAdultCost,
      required this.totalKidsCost,
      required this.categoryImage,
      required this.categoryName,
      required this.subCategoryName,
      required this.subCategoryImage,
      required this.actualCost});
}
