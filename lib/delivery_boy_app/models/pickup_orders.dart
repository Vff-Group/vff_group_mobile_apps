class PickupOrdersModel{
  final String bookingId;
  final String customerName;
  final String addressDetails;
  final String orderID;
  final String branchName;
  final String branchAddress;

  PickupOrdersModel({required this.bookingId, required this.customerName, required this.addressDetails, required this.orderID,required this.branchName,required  this.branchAddress });
  
}

class DropOrdersModel{
  final String orderId;
  final String customerName;
  final String addressDetails;
  final String branchName;
  final String branchAddress;

  DropOrdersModel({required this.orderId, required this.customerName, required this.addressDetails,required this.branchName,required  this.branchAddress });
  
}