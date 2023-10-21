class DryCleanItemModel {
  final String subCategoryID;
  final String subCategoryName;
  final String subCategoryImage;
  final String cost;
  final String typeOf;
  final String sectionType;
  int itemCount;

  DryCleanItemModel({
    required this.subCategoryID,
    required this.subCategoryName,
    required this.subCategoryImage,
    required this.cost,
    required this.typeOf,
    required this.itemCount,
    required this.sectionType
  });
}
