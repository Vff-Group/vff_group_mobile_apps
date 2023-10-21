class CartItemModel {
  final String itemID;
  final String categoryID;
  final String subCategoryID;

  final String orderID;
  final String date;
  final String time;
  final String orderType;
  final String itemCost;
  final String itemQuantity;
  final String typeOf;

  final String categoryImage;
  final String categoryName;
  final String subCategoryName;
  final String subCategoryImage;
  final String actualCost;
  final String sectionType;

  CartItemModel(
      {required this.itemID,
      required this.categoryID,
      required this.subCategoryID,
      required this.itemCost,
      required this.itemQuantity,
      required this.typeOf,
      required this.orderID,
      required this.date,
      required this.time,
      required this.orderType,
      required this.categoryImage,
      required this.categoryName,
      required this.subCategoryName,
      required this.subCategoryImage,
      required this.actualCost,
      required this.sectionType});
}
