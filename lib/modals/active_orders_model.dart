class ActiveOrders {
  final String orderID;
  final String time;
  final String pickUpDate;
  // final String deliveryDate;
  final String deliveryBoyID;
  final String deliveryBoyName;
  final String orderStatus;

  ActiveOrders(
      {required this.orderID,
      required this.time,
      required this.pickUpDate,
      required this.deliveryBoyID,
      required this.deliveryBoyName,
      required this.orderStatus});
}
