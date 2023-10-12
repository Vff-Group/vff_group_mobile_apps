import 'dart:convert';

import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/animation/slide_left_animation.dart';
import 'package:vff_group/delivery_boy_app/models/new_orders.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<NewOrders> newOrdersModel = [];
  bool showLoading = true, noOrders = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewOrders();
  }

  Future loadNewOrders() async {
    //norder_id
    setState(() {
      showLoading = true;
      noOrders = false;
    });
    final prefs = await SharedPreferences.getInstance();
    var norderId = prefs.getString('norder_id');
    if (norderId != null && norderId.isNotEmpty) {
      print('Notification OrderID Dashboard::$norderId');
      try {
        var url = glb.endPoint;
        final Map dictMap = {};

        dictMap['order_id'] = norderId;
        dictMap['pktType'] = "7";
        dictMap['token'] = "vff";
        dictMap['uid'] = "-1";
        final response = await http.post(Uri.parse(url),
            headers: <String, String>{
              "Accept": "application/json",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(dictMap));

        if (response.statusCode == 200) {
          var res = response.body;
          if (res.contains("ErrorCode#2")) {
            glb.showSnackBar(context, 'Error', 'No New Orders Found');
            setState(() {
              showLoading = false;
              noOrders = true;
            });
            return;
          } else if (res.contains("ErrorCode#8")) {
            glb.showSnackBar(context, 'Error', 'Something Went Wrong');
            setState(() {
              showLoading = false;
              noOrders = true;
            });
            return;
          } else {
            try {
              Map<String, dynamic> orderMap = json.decode(response.body);

              var customerid = orderMap['customerid'];
              var epoch = orderMap['epoch'];
              var pickup_dt = orderMap['pickup_dt'];
              var clat = orderMap['clat'];
              var clng = orderMap['clng'];
              var customer_name = orderMap['customer_name'];
              var usrid = orderMap['usrid'];
              var houseno = orderMap['houseno'];
              var address = orderMap['address'];
              var landmark = orderMap['landmark'];
              var pincode = orderMap['pincode'];

              List<String> customerIDLst = glb.strToLst2(customerid);
              List<String> epochLst = glb.strToLst2(epoch);
              List<String> pickup_dtLst = glb.strToLst2(pickup_dt);
              List<String> clatLst = glb.strToLst2(clat);
              List<String> clngLst = glb.strToLst2(clng);
              List<String> customer_nameLst = glb.strToLst2(customer_name);
              List<String> usridLst = glb.strToLst2(usrid);
              List<String> housenoLst = glb.strToLst2(houseno);
              List<String> addressLst = glb.strToLst2(address);
              List<String> landmarkLst = glb.strToLst2(landmark);
              List<String> pincodeLst = glb.strToLst2(pincode);

              for (int i = 0; i < customerIDLst.length; i++) {
                var CustomerID = customerIDLst.elementAt(i).toString();
                var epoch = epochLst.elementAt(i).toString();
                var PickupDate = pickup_dtLst.elementAt(i).toString();
                var CLatitute = clatLst.elementAt(i).toString();
                var CLongitude = clngLst.elementAt(i).toString();
                var CustomerName = customer_nameLst.elementAt(i).toString();
                var CUsrid = usridLst.elementAt(i).toString();
                var Houseno = housenoLst.elementAt(i).toString();
                var Address = addressLst.elementAt(i).toString();
                var Landmark = landmarkLst.elementAt(i).toString();
                var Pincode = pincodeLst.elementAt(i).toString();

                DateTime formattedDateTime =
                    glb.epochToDateTime(double.parse(epoch));
                String formattedTime =
                    DateFormat.jm().format(formattedDateTime);

                print('TIme::$formattedTime');
                newOrdersModel.add(NewOrders(
                    CustomerID: CustomerID,
                    CustomerName: CustomerName,
                    CLatitute: CLatitute,
                    CLongitude: CLongitude,
                    Time: formattedTime,
                    PickupDate: PickupDate,
                    CUsrid: CUsrid,
                    HouseNo: Houseno,
                    Address: Address,
                    Landmark: Landmark,
                    Pincode: Pincode));
              }

              setState(() {
                showLoading = false;
                noOrders = false;
              });
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
              return "Failed";
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        glb.handleErrors(e, context);
        setState(() {
          showLoading = false;
          noOrders = true;
        });
      }
    }else{
      setState(() {
      showLoading = false;
      noOrders = true;
    });
    }
  }

  Future accept_or_rejectOrder(String orderStatus) async {
    //norder_id

    final prefs = await SharedPreferences.getInstance();
    var norderId = prefs.getString('norder_id');
    var deliveryBoyId = prefs.getString('delivery_boy_id');
    if (norderId != null) {
      print('Notification OrderID Dashboard::$norderId');
      try {
        var url = glb.endPoint;
        final Map dictMap = {};

        dictMap['order_id'] = norderId;
        dictMap['delivery_boy_id'] = deliveryBoyId;
        dictMap['status'] = orderStatus;
        dictMap['pktType'] = "8";
        dictMap['token'] = "vff";
        dictMap['uid'] = "-1";
        final response = await http.post(Uri.parse(url),
            headers: <String, String>{
              "Accept": "application/json",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(dictMap));

        if (response.statusCode == 200) {
          var res = response.body;
          if (res.contains("ErrorCode#2")) {
            glb.showSnackBar(context, 'Error', 'No New Orders Found');
            return;
          } else if (res.contains("ErrorCode#8")) {
            glb.showSnackBar(context, 'Error', 'Something Went Wrong');
            return;
          } else {
            SharedPreferenceUtils.save_val('norder_id', '');
            //Navigator.pop(context);
            Navigator.pushReplacementNamed(context, DMainRoute);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        glb.handleErrors(e, context);
      }
    }
  }

    /// when you want to close the menu you have to create
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

   Widget float1() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        heroTag: "btn1",
        tooltip: 'VFF Gym',
        child: const Icon(Icons.fitness_center),
      ),
    );
  }

  Widget float2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, MainRoute);
        },
        backgroundColor: Colors.blue,
        heroTag: "btn2",
        tooltip: 'Laundry',
        child: const Icon(Icons.local_laundry_service),
      ),
    );
  }

  Widget float3() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        heroTag: "btn3",
        tooltip: 'Coming Soon',
        child: const Icon(LineIcons.tShirt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.help_outline_sharp,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'DELIVERY BOY',
          style: nunitoStyle.copyWith(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.03),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.green[50]),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30.0, bottom: 10.0),
                                                child: Icon(
                                                  Icons.delivery_dining,
                                                  color: Colors.green,
                                                  size: 35.0,
                                                ),
                                              ),
                                              Text(
                                                'Completed Delivery',
                                                style: nunitoStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.0),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, bottom: 10.0),
                                                child: Text(
                                                  '0',
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.orange[50]),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30.0, bottom: 10.0),
                                                child: Icon(
                                                  LineIcons.truck,
                                                  color: Colors.deepOrange,
                                                  size: 35.0,
                                                ),
                                              ),
                                              Text(
                                                'Pending Delivery',
                                                style: nunitoStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.0),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, bottom: 10.0),
                                                child: Text(
                                                  '0',
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10.0, left: 8.0, right: 8.0, top: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.red[50]),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30.0, bottom: 10.0),
                                                child: Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.red,
                                                  size: 35.0,
                                                ),
                                              ),
                                              Text(
                                                'Cancelled Delivery',
                                                style: nunitoStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.0),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, bottom: 10.0),
                                                child: Text(
                                                  '0',
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: Colors.blue[50]),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30.0, bottom: 10.0),
                                                child: Icon(
                                                  Icons.report_rounded,
                                                  color: Colors.blue,
                                                  size: 35.0,
                                                ),
                                              ),
                                              Text(
                                                'Return Delivery',
                                                style: nunitoStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.0),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, bottom: 10.0),
                                                child: Text(
                                                  '0',
                                                  style: nunitoStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]),
                                      ),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('New Orders',
                            style: ralewayStyle.copyWith(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                        showLoading
                            ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: LinearProgressIndicator()),
                            )
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: noOrders ? Padding(
                                  padding: const EdgeInsets.all(26.0),
                                  child: Center(
                                    child: Text('No New Orders',style: ralewayStyle.copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleTxtColor
                                    ),),
                                  ),
                                ) :Container(
                                  height: 200,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: newOrdersModel.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            width: width - 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 100,
                                                        child: Image.asset(
                                                            'assets/images/delivery.gif'),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              'Pick Up Request',
                                                              style: ralewayStyle.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      16.0),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        5.0),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .location_history_rounded,
                                                                    color: Colors
                                                                        .orange,
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${newOrdersModel[index].Address}-${newOrdersModel[index].Pincode}\n${newOrdersModel[index].Landmark}",
                                                                  style: ralewayStyle.copyWith(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: AppColors
                                                                          .textColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .watch_later_outlined,
                                                                  color: Colors
                                                                      .orange,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                              Text(
                                                                newOrdersModel[index].Time,
                                                                style: nunitoStyle.copyWith(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: AppColors
                                                                        .textColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            onDoubleTap: () {
                                                              var orderStatus =
                                                                  "Accepted";
                                                              accept_or_rejectOrder(
                                                                  orderStatus);
                                                            },
                                                            child: Ink(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0)),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        26.0,
                                                                    vertical:
                                                                        12.0),
                                                                child: Text(
                                                                  'Accept',
                                                                  style: ralewayStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onDoubleTap: () {
                                                            var orderStatus =
                                                                "Rejected";
                                                            accept_or_rejectOrder(
                                                                orderStatus);
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          child: Ink(
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          26.0,
                                                                      vertical:
                                                                          12.0),
                                                              child: Text(
                                                                'Reject',
                                                                style: ralewayStyle.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
     floatingActionButton: SlideFromLeftAnimation(
            delay: 1.2,
            child: AnimatedFloatingActionButton(
                //Fab list
                fabButtons: <Widget>[float1(), float2(), float3()],
                key: key,
                colorStartAnimation: Colors.orange,
                colorEndAnimation: Colors.deepOrange,
                animatedIconData: AnimatedIcons.list_view //To principal button
                ),
          ),
       
    );
  }
}