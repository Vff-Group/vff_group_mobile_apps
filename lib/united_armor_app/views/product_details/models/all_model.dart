import 'package:flutter/material.dart';

class ProductColorModel {
  final String colorID;
  final String colorName;
  final Color colorCode;

  ProductColorModel(
      {required this.colorID,
      required this.colorName,
      required this.colorCode});
}

class ProductSizeModel {
  final String sizeIDs;
  final String sizeValues;

  ProductSizeModel({required this.sizeIDs, required this.sizeValues});
}
