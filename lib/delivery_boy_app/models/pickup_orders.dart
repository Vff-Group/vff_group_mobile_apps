class PickupOrdersModel{
  final String bookingId;
  final String customerName;
  final String addressDetails;
  final String orderID;

  PickupOrdersModel({required this.bookingId, required this.customerName, required this.addressDetails, required this.orderID});
  
}

class DropOrdersModel{
  final String orderId;
  final String customerName;
  final String addressDetails;

  DropOrdersModel({required this.orderId, required this.customerName, required this.addressDetails});
  
}