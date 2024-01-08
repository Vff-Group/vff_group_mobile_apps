import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/views/notification/widgets/notification_row.dart';
import 'package:vff_group/global/vffglb.dart' as glb;
import 'package:http/http.dart' as http;

class GymNotificationScreen extends StatefulWidget {
  const GymNotificationScreen({super.key});

  @override
  State<GymNotificationScreen> createState() => _GymNotificationScreenState();
}

class _GymNotificationScreenState extends State<GymNotificationScreen> {
  // List notificationArr = [
  //   {
  //     "image": "assets/images/Workout1.png",
  //     "title": "Hey, it’s time for lunch",
  //     "time": "About 1 minutes ago"
  //   },
  //   {
  //     "image": "assets/images/Workout2.png",
  //     "title": "Don’t miss your lowerbody workout",
  //     "time": "About 3 hours ago"
  //   },
  //   {
  //     "image": "assets/images/Workout3.png",
  //     "title": "Hey, let’s add some meals for your b",
  //     "time": "About 3 hours ago"
  //   },
  //   {
  //     "image": "assets/images/Workout1.png",
  //     "title": "Congratulations, You have finished A..",
  //     "time": "29 May"
  //   },
  //   {
  //     "image": "assets/images/Workout2.png",
  //     "title": "Hey, it’s time for lunch",
  //     "time": "8 April"
  //   },
  //   {
  //     "image": "assets/images/Workout3.png",
  //     "title": "Ups, You have missed your Lowerbo...",
  //     "time": "8 April"
  //   },
  // ];
  List<Map<String, String>> notificationArr = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.lightGrayColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/icons/back_icon.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: const Text(
            "Notification",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: notificationArr.length != 0
            ? ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            itemBuilder: ((context, index) {
              var nObj = notificationArr[index] as Map? ?? {};
              return NotificationRow(nObj: nObj);
            }),
            separatorBuilder: (context, index) {
              return Divider(
                color: AppColors.grayColor.withOpacity(0.5),
                height: 1,
              );
            },
                itemCount: notificationArr.length)
            : Center(child: Text('No Notifications Found')));
  }

  bool showLoading = true;

  Future getDietPlansDetails() async {
    setState(() {
      showLoading = true;

      notificationArr = [];
    });
    final prefs = await SharedPreferences.getInstance();
    var member_id = prefs.getString("key");
    try {
      var url = glb.endPointGym;
      url += "get_notification/";
      final Map dictMap = {
        'memberid': member_id,
      };

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dictMap));

      if (response.statusCode == 200) {
        var res = response.body;
        if (res.contains("ErrorCode#2")) {
          setState(() {
            showLoading = false;
          });
          //glb.showSnackBar(context, 'Error', 'No Order Details Found');
          return;
        } else if (res.contains("ErrorCode#8")) {
          setState(() {
            showLoading = false;
          });
          glb.showSnackBar(context, 'Error', 'Something Went Wrong');
          return;
        } else {
          try {
            Map<String, dynamic> dietPlanDetailsMap =
                json.decode(response.body);
            if (kDebugMode) {
              print("dietPlanDetailsMap:$dietPlanDetailsMap");
            }
            // Accessing the list of fee details under the key 'query_result'
            List<dynamic> queryResult = dietPlanDetailsMap['query_result'];

            for (var notificationDetail in queryResult) {
              var notificationid =
                  notificationDetail['notificationid'].toString();
              var title = notificationDetail['title'].toString();
              var body = notificationDetail['body'].toString();
              var image = notificationDetail['image'].toString();
              var notify_date = notificationDetail['notify_date'].toString();
              var notify_time = notificationDetail['notify_time'].toString();

              var notification = {
                "id": notificationid, // Use your id variable here
                "image": image, // Use your image variable here
                "title": title, // Use your title variable here
                "time":
                    notify_date, // Concatenate date and time
              };

              notificationArr.add(notification);
            }

            setState(() {
              showLoading = false;
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            setState(() {
              showLoading = false;
            });
            return "Failed";
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        showLoading = false;
      });
      glb.handleErrors(e, context);
    }
  }


}