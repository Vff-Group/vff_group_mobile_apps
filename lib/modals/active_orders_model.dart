class ActiveOrders {
  final String orderID;
  final String time;
  
  // final String deliveryDate;
  
  final String deliveryBoyName;
  final String orderStatus;
  final String branchID;

  ActiveOrders(
      {required this.orderID,
      required this.time,
      
      
      required this.deliveryBoyName,
      required this.orderStatus,
      required this.branchID});
}

class ActiveBookings{
  final String bookingID;
  final String deliveryBoyID;
  final String bookingStatus;
  final String bookingTime;
  final String branchID;

  ActiveBookings({required this.bookingID, required this.deliveryBoyID, required this.bookingStatus, required this.bookingTime,required this.branchID});
}
