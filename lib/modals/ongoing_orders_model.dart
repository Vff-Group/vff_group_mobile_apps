class OngoingOrdersModel {
  final String orderID;
  final String pickup_date;
  final String delivery_date;
  final String order_status;
  final String delivery_epoch;
  final String order_taken_epoch;
  final String cancel_reason;
  final String house_no;
  final String address;
  final String totalPrice;
  final String customerID;
  bool showCancelBtn;
  

  OngoingOrdersModel(
      {required this.orderID,
      required this.pickup_date,
      required this.delivery_date,
      required this.order_status,
      required this.delivery_epoch,
      required this.order_taken_epoch,
      required this.cancel_reason,
      required this.house_no,
      required this.address,
      required this.totalPrice,
      required this.showCancelBtn,
      required this.customerID,
      });
}
