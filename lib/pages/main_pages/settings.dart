import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/SharedPreferencesUtils.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/textwidget.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var userName = "", profile_img = "";
  void getDefaults() async {
    glb.prefs = await SharedPreferences.getInstance();

    var profile = glb.prefs?.getString('profile_img');
    var usrname = glb.prefs?.getString('usrname');

    if (usrname != null && usrname.isNotEmpty) {
      var split = usrname.split(" ");

      setState(() {
        userName = split[0];
      });
    }

    if (profile != null && profile.isNotEmpty) {
      setState(() {
        profile_img = profile;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDefaults();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          WidgetCircularAnimator(
                            size: 50,
                            innerIconsSize: 3,
                            outerIconsSize: 3,
                            innerAnimation: Curves.easeInOutBack,
                            outerAnimation: Curves.easeInOutBack,
                            innerColor: Colors.deepPurple,
                            outerColor: Colors.orangeAccent,
                            innerAnimationSeconds: 10,
                            outerAnimationSeconds: 10,
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200]),
                                child: profile_img.isEmpty == false
                                    ? CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage:
                                            NetworkImage(profile_img),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : const Icon(Icons.person)),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/logo/velvet_2.png',
                        width: 150,
                      ),
                      Stack(
                        children: [
                          Positioned(
                            left: 20,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.notifications_none_outlined,
                              color: AppColors.whiteColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('Settings',
                      style: ralewayStyle.copyWith(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('Hey, ',
                          style: ralewayStyle.copyWith(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal)),
                      Text('${userName} 👋',
                          style: ralewayStyle.copyWith(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  SizedBox(
                    height: height * 0.04,
                  ),
                  _LogOut()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_showDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Text("Log Out"),
                Icon(
                  Icons.dangerous_rounded,
                  color: Colors.red,
                ),
              ],
            ),
            content: new Text("Alert!😕" + "Are you sure you want to Log Out"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Yes"),
                onPressed: () {
                  SharedPreferenceUtils.save_val("usrid", "");
                  Navigator.popAndPushNamed(context, LoginRoute);
                },
              ),
              CupertinoDialogAction(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
}

_onBackPressed(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: TextWidget(
          title: 'Are you sure?', fontsize: 18, color: AppColors.blueDarkColor),
      content: new Text('Do you want to Log Out'),
      actions: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(false),
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextWidget(
                    title: 'No', fontsize: 12, color: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              SharedPreferenceUtils.save_val('userId', '');
              Navigator.pushReplacementNamed(context, LoginRoute);
            },
            borderRadius: BorderRadius.circular(12),
            child: Ink(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextWidget(
                      title: 'Yes', fontsize: 12, color: AppColors.whiteColor),
                )),
          ),
        ),
      ],
    ),
  );
}

class _MainHeaders extends StatelessWidget {
  const _MainHeaders({
    Key? key,
    required this.profile_img,
  }) : super(key: key);
  final String profile_img;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Settings',
            style: ralewayStyle.copyWith(
              fontSize: 25.0,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            )),
        WidgetCircularAnimator(
            size: 50,
            innerIconsSize: 3,
            outerIconsSize: 3,
            innerAnimation: Curves.easeInOutBack,
            outerAnimation: Curves.easeInOutBack,
            innerColor: Colors.deepPurple,
            outerColor: Colors.orangeAccent,
            innerAnimationSeconds: 10,
            outerAnimationSeconds: 10,
            child: profile_img != "NA"
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[200]),
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK_vjpKVAjkub5O0sFL7ij3mIzG-shVt-6KKLNdxq4&s'),
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : Icon(Icons.add))
      ],
    );
  }
}

class _HeadingSection extends StatelessWidget {
  const _HeadingSection({
    Key? key,
    required this.userName,
  }) : super(key: key);
  final String userName;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hello ${userName} 👋',
            style: ralewayStyle.copyWith(
                fontSize: 16.0,
                color: AppColors.mainBlueColor,
                fontWeight: FontWeight.w900)),
        Row(
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 15.0,
              color: Colors.green,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text('Other Settings Related to User',
                style: nunitoStyle.copyWith(
                    fontSize: 10.0,
                    color: AppColors.blueDarkColor,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }
}

class _LogOut extends StatelessWidget {
  const _LogOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          /* SharedPreferenceUtils.save_val('userId', '');
          Navigator.pushNamed(context, LoginRoute); */
          _showDialog(context);
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: AppColors.lightBlackColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(18),
                                  bottomLeft: Radius.circular(18))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Log Out',
                                    style: nunitoStyle.copyWith(
                                      fontSize: 18.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.logout_outlined,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
