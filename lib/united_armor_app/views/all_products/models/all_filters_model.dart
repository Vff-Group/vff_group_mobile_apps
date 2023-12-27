class ProductCategoryFilterModel {
  final String productCatID;
  final String productCatName;

  ProductCategoryFilterModel({required this.productCatID, required this.productCatName});
}

class ProductTypeFilterModel{
  final String productTypeID;
  final String productTypeName;

  ProductTypeFilterModel({required this.productTypeID, required this.productTypeName});
}

class ProductColorFilterModel{
  final String colorID;
  final String colorName;

  ProductColorFilterModel({required this.colorID, required this.colorName});
}

class ProductSizeFilterModel{
  final String sizeID;
  final String sizeValue;

  ProductSizeFilterModel({required this.sizeID, required this.sizeValue});
}

class ProductFittingFilterModel{
  final String fittingID;
  final String fittingType;

  ProductFittingFilterModel({required this.fittingID, required this.fittingType});
}