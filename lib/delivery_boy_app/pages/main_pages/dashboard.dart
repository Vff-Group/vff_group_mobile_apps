import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewOrders();
  }

  Future loadNewOrders() async {
    //norder_id
    final prefs = await SharedPreferences.getInstance();
    var norderId = prefs.getString('norder_id');
    if (norderId != null) {
      print('Notification OrderID Dashboard::$norderId');
    }
  }

  /*
  Future allUsersAddressAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var usrid = prefs.getString('usrid');
      var url = glb.endPoint;
      final Map dictMap = {};

      dictMap['usrid'] = usrid;
      dictMap['pktType'] = "3";
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
          glb.showSnackBar(context, 'Error', 'No Categories Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> catMap = json.decode(response.body);
            // if (kDebugMode) {
            //   print("categoryMap:$catMap");
            // }
            var buildingNo = catMap['buildingNo'];
            var streetAddress = catMap['streetAddress'];
            var cityName = catMap['cityName'];
            var zipCode = catMap['zipCode'];
            var landMark = catMap['landMark'];

            setState(() {
              if(buildingNo.toString() !='NA'){
                buildingNoController.text = buildingNo;
              }
              if(streetAddress.toString() !='NA'){
                streetAddressController.text = streetAddress;
              }
              if(cityName.toString() !='NA'){
                cityController.text = cityName;
              }
              if(zipCode.toString() !='-1'){
                zipCodeController.text = zipCode;
              }
              if(landMark.toString() !='NA'){
                landmarkController.text = landMark;
              }
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
    }
  }

   */
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 1,
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
                                        padding: const EdgeInsets.all(8.0),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: Text(
                                                        'Pick Up Request',
                                                        style: ralewayStyle
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 16.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5.0),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: Icon(
                                                              Icons
                                                                  .location_history_rounded,
                                                              color:
                                                                  Colors.orange,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            'New Vaibhav Nagar ',
                                                            style: ralewayStyle
                                                                .copyWith(
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
                                                                  right: 8.0),
                                                          child: Icon(
                                                            Icons
                                                                .watch_later_outlined,
                                                            color:
                                                                Colors.orange,
                                                            size: 18,
                                                          ),
                                                        ),
                                                        Text(
                                                          '12:30 AM',
                                                          style: nunitoStyle
                                                              .copyWith(
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
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      onDoubleTap: () {},
                                                      child: Ink(
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
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
                                                            'Accept',
                                                            style: ralewayStyle
                                                                .copyWith(
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
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onDoubleTap: () {
                                                      print('Hi');
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: Ink(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
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
                                                                vertical: 12.0),
                                                        child: Text(
                                                          'Cancel',
                                                          style: ralewayStyle
                                                              .copyWith(
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
    );
  }
}
