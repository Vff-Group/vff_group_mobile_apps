import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/dashboard/dashboard_gym.dart';
import 'package:vff_group/gym_app/views/home/calender_widget.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';

import '../../common_widgets/round_button.dart';
import '../../common_widgets/round_gradient_button.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> showingTooltipOnSpots = [21];
  bool showLoading = false, showFeesRemainder = false;
  String due_date = "", last_date_paid = "", gymFees = "";
  String userName = "",razor_pay_status="",razor_pay_id="";
  List<FlSpot> get allSpots => const [
        FlSpot(0, 20),
        FlSpot(1, 25),
        FlSpot(2, 40),
        FlSpot(3, 50),
        FlSpot(4, 35),
        FlSpot(5, 40),
        FlSpot(6, 30),
        FlSpot(7, 20),
        FlSpot(8, 25),
        FlSpot(9, 40),
        FlSpot(10, 50),
        FlSpot(11, 35),
        FlSpot(12, 50),
        FlSpot(13, 60),
        FlSpot(14, 40),
        FlSpot(15, 50),
        FlSpot(16, 20),
        FlSpot(17, 25),
        FlSpot(18, 40),
        FlSpot(19, 50),
        FlSpot(20, 35),
        FlSpot(21, 80),
        FlSpot(22, 30),
        FlSpot(23, 20),
        FlSpot(24, 25),
        FlSpot(25, 40),
        FlSpot(26, 50),
        FlSpot(27, 35),
        FlSpot(28, 50),
        FlSpot(29, 60),
        FlSpot(30, 40),
      ];
  var totalPrize = 0;
  var _razorpay = Razorpay();
  List waterArr = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"}
  ];

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          AppColors.primaryColor2.withOpacity(0.5),
          AppColors.primaryColor1.withOpacity(0.5),
        ]),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          AppColors.secondaryColor2.withOpacity(0.5),
          AppColors.secondaryColor1.withOpacity(0.5),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  List lastWorkoutArr = [
    {
      "name": "Full Body Workout",
      "image": "assets/images/Workout1.png",
      "kcal": "180",
      "time": "20",
      "progress": 0.3
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/images/Workout2.png",
      "kcal": "200",
      "time": "30",
      "progress": 0.4
    },
    {
      "name": "Ab Workout",
      "image": "assets/images/Workout3.png",
      "kcal": "300",
      "time": "40",
      "progress": 0.7
    },
  ];

  Future<String?> fetchCSRFToken() async {
    var url = glb.endPointGym;
    url += "get_csrf_token/"; // Route Name

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> csrfMap = json.decode(response.body);
        print("csrfMap:$csrfMap");
        var csrfToken = csrfMap['csrf_token'];
        print('csrfToken::$csrfToken');
        return csrfToken;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    
    getFeesDetailsAsync();
    // fetchCSRFToken();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            AppColors.primaryColor2.withOpacity(0.4),
            AppColors.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: AppColors.primaryG,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                            color: AppColors.midGrayColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          userName,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, NotificationScreenRoute);
                        },
                        icon: Image.asset(
                          "assets/icons/notification_icon.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                CalendarWidget(),
                SizedBox(height: media.width * 0.05),
                //Reminder Layout
                if (showFeesRemainder)
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color(0xffFFE5E5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(30)),
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/icons/date_notifi.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Reminder!",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Your Fees Got Due on Date ${due_date}",
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ]),
                        ),
                        Container(
                            height: 60,
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showFeesRemainder = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.grayColor,
                                  size: 15,
                                )))
                      ],
                    ),
                  ),
                SizedBox(height: media.width * 0.05),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: AppColors.primaryColor1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Gym Fees",
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4.0),
                                child: Text(
                                  "Last Paid:${last_date_paid}",
                                  style: TextStyle(
                                    color: AppColors.grayColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 75,
                        height: 30,
                        child: RoundButton(
                          title: gymFees,
                          type: gymFees == "Paid"
                              ? RoundButtonType.primaryBG
                              : RoundButtonType.secondaryBG,
                          onPressed: () {
                            if (gymFees == "UnPaid") {
                              Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardGymScreen(
                                                    pageIndex: 1)));
                            }
                            //Navigator.pushNamed(context, ActivityTrackerScreen.routeName);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                //SizedBox(height: media.width * 0.05),
                Visibility(
                  visible: false,
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                    height: media.width * 0.4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColors.primaryColor2.withOpacity(0.4),
                          AppColors.primaryColor1.withOpacity(0.4)
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Track Your Diet Plan Each\nMonth",
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 110,
                                height: 35,
                                child: RoundButton(
                                    title: "View Now", onPressed: () {}),
                              )
                            ]),
                        Image.asset(
                          "assets/images/progress_each_photo.png",
                          width: media.width * 0.35,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "Daily Routine",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: media.width * 0.95,
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ]),
                      child: Row(children: [
                        SimpleAnimationProgressBar(
                          height: media.width * 0.9,
                          width: media.width * 0.07,
                          backgroundColor: Colors.grey.shade100,
                          foregrondColor: Colors.purple,
                          ratio: 1,
                          direction: Axis.vertical,
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(seconds: 5),
                          borderRadius: BorderRadius.circular(30),
                          gradientColor: LinearGradient(
                              colors: AppColors.primaryG,
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Water Intake",
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: media.width * 0.01),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                        colors: AppColors.primaryG,
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)
                                    .createShader(Rect.fromLTRB(
                                        0, 0, bounds.width, bounds.height));
                              },
                              child: Text(
                                "4 Liters",
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: media.width * 0.03),
                            Text(
                              "Follow For Healthy Life",
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: media.width * 0.01),
                            Column(
                              children: waterArr.map((obj) {
                                var isLast = obj == waterArr.last;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: AppColors.secondaryColor1
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          if (!isLast)
                                            DottedDashedLine(
                                              width: 0,
                                              height: media.width * 0.078,
                                              axis: Axis.vertical,
                                              dashColor: AppColors
                                                  .secondaryColor1
                                                  .withOpacity(0.5),
                                            )
                                        ]),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: media.width * 0.01),
                                        Text(
                                          obj["title"].toString(),
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(height: 1),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                                    colors:
                                                        AppColors.secondaryG,
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight)
                                                .createShader(Rect.fromLTRB(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height));
                                          },
                                          child: Text(
                                            obj["subtitle"].toString(),
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ))
                      ]),
                    )),
                    SizedBox(width: media.width * 0.05),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: media.width * 0.45,
                          padding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Healthy Sleep",
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: media.width * 0.01),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                          colors: AppColors.primaryG,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "7h 20m",
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Image.asset(
                                "assets/images/sleep_graph.png",
                                width: double.maxFinite,
                                fit: BoxFit.fitWidth,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(height: media.width * 0.05),
                        Container(
                          width: double.maxFinite,
                          height: media.width * 0.45,
                          padding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Calories to Burn",
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: media.width * 0.01),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                          colors: AppColors.primaryG,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "On Daily Basis",
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: media.width * 0.2,
                                  height: media.width * 0.2,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: media.width * 0.16,
                                        height: media.width * 0.16,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: AppColors.primaryG),
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.075)),
                                        child: Text("230kCal\ntotal",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                      SimpleCircularProgressBar(
                                        startAngle: -180,
                                        progressStrokeWidth: 10,
                                        backStrokeWidth: 10,
                                        progressColors: AppColors.primaryG,
                                        backColor: Colors.grey.shade100,
                                        valueNotifier: ValueNotifier(60),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        const color0 = AppColors.secondaryColor2;
        const color1 = AppColors.whiteColor;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 33,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: Text(
                  "20.1",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ));
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 75,
              title: '',
              radius: 42,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: AppColors.grayColor,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: AppColors.grayColor,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Future getFeesDetailsAsync() async {
    setState(() {
      showLoading = true;
    });
    try {
      var url = glb.endPointGym;
      url += "get_fees_details/"; // Route Name
      final prefs = await SharedPreferences.getInstance();
      var memberid = prefs.getString('memberid');
      final Map dictMap = {
        'memberid': memberid,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dictMap),
      );

      if (response.statusCode == 200) {
        // Handle successful response here
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          glb.showSnackBar(context, 'Error', 'You are not registered');
          setState(() {
            showLoading = false;
          });
          return;
        } else if (res.contains("ErrorCode#8")) {
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          try {
            Map<String, dynamic> feesMap = json.decode(res);
            print("feesMap:$feesMap");
            var memberid = feesMap['memberid'].toString();
            var name = feesMap['name'].toString();
            var mobno = feesMap['mobno'].toString();
            var member_type = feesMap['member_type'].toString();
            var duration_in_months = feesMap['duration_in_months'].toString();
            var price = feesMap['price'].toString();
            var fees_date = feesMap['fees_date'].toString();
            var last_due_date = feesMap['last_due_date'].toString();
            var fees_id = feesMap['fees_id'].toString();
            String todaysDate = glb.getTodaysDate();
            // Convert strings to DateTime objects
            DateTime feesDateTime = DateTime.parse(fees_date);
            DateTime todayDateTime = DateTime.parse(todaysDate);
            var formatter = DateFormat('dd MMM yyyy');
            String formattedFeesDate =
                formatter.format(DateTime.parse(fees_date));
            String formattedLastFeesDate =
                formatter.format(DateTime.parse(last_due_date));
            setState(() {
              userName = name;
            });
            if (feesDateTime.isBefore(todayDateTime) ||
                feesDateTime.isAtSameMomentAs(todayDateTime)) {
              setState(() {
                showFeesRemainder = true;
                gymFees = "UnPaid";
                due_date = formattedFeesDate;
                last_date_paid = formattedLastFeesDate;
              });
            } else {
              showFeesRemainder = false;
              gymFees = "Paid";
              due_date = formattedFeesDate;
              last_date_paid = formattedLastFeesDate;
            }

            setState(() {
              showLoading = false;
            });
            return;
          } catch (e) {
            print(e);
            return "Failed";
          }
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        setState(() {
          showLoading = false;
        });
      }
    } catch (e) {
      print(e);
      glb.handleErrors(e, context);
      setState(() {
        showLoading = false;
      });
      return;
    }
  }


}
