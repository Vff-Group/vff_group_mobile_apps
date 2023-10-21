class OrderItemsModel {
  final String categoryID;
  final String subCategoryID;
  final String totalQuantity;
  final String totalPrice;
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
  final String sectionType;

  OrderItemsModel({
    required this.categoryID,
    required this.subCategoryID,
    required this.totalQuantity,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.orderType,
    required this.itemCost,
    required this.itemQuantity,
    required this.typeOf,
    required this.categoryImage,
    required this.categoryName,
    required this.subCategoryName,
    required this.subCategoryImage,
    required this.sectionType
  });
}
