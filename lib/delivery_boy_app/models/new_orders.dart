// ignore_for_file: non_constant_identifier_names

class NewOrders {
  final String CustomerID;
  final String CustomerName;
  // final String CLatitute;
  // final String CLongitude;
  final String Time;

  final String bookingID;
  final String Address;
  final String Landmark;
  final String Pincode;

  NewOrders(
      {required this.bookingID,
      required this.CustomerID,
      required this.CustomerName,
      // required this.CLatitute,
      // required this.CLongitude,
      required this.Time,
      required this.Address,
      required this.Landmark,
      required this.Pincode});
}
