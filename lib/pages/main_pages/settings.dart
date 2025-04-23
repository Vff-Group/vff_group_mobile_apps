import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
  var userName = "", profile_img = "",mobNO="";
  void checkWalletStatus() async {
    var pref = await SharedPreferences.getInstance();
    var isWalletActive = pref.getBool('isWalletActive');

    if(isWalletActive != null && isWalletActive == true){
      Navigator.pushNamed(context, WalletHomePageRoute);
    }else{
      // Navigator.pushNamed(context, WalletSignUpRoute);
      Navigator.pushNamed(context, WalletHomePageRoute);
    }
  }
  void getDefaults() async {
    glb.prefs = await SharedPreferences.getInstance();

    var profile = glb.prefs?.getString('profile_img');
    var usrname = glb.prefs?.getString('usrname');
    var mobno = glb.prefs?.getString('umobno');

    if (usrname != null && usrname.isNotEmpty) {
      var split = usrname.split(" ");

      setState(() {
        userName = usrname;
      });
    }

    if(mobno != null && mobno.isNotEmpty){
      setState(() {
        mobNO = "+91-$mobno";
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
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text('My Account',
            style: nunitoStyle.copyWith(
                fontSize: 25.0,
                color: AppColors.backColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          children: [
                            Text('${userName} 👋',
                                style: nunitoStyle.copyWith(
                                    color: AppColors.backColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(mobNO,
                              style: nunitoStyle.copyWith(
                                  color: AppColors.textColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height * 0.02,
                  color: AppColors.lightBlackColor,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  color: AppColors.whiteColor,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          glb.justSaveAddress=false;
                          Navigator.pushNamed(context, DeliveryAddressRoute);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/clothes/address.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(
                                width: height * 0.04,
                              ),
                              Text('Saved Address',
                                  style: nunitoStyle.copyWith(
                                      color: AppColors.backColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: InkWell(
                          onTap: () {
                            //WalletPage
                            checkWalletStatus();
                            //vff.laundry_wallettbl
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/clothes/wallet.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: height * 0.04,
                                ),
                                Text('Wallet',
                                    style: nunitoStyle.copyWith(
                                        color: AppColors.backColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                       InkWell(
                        onTap: (){
                          //glb.justSaveAddress=true;
                          var url = 'https://vff-group.com/privacy_policy/';
                          _OpenBrowser(url);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Row(
                            children: [
                              Image.asset('assets/clothes/terms_and_conditions.png',width: 30,height: 30,),
                              SizedBox(width: height * 0.04,),
                              Text('Terms and Conditions',
                                    style: nunitoStyle.copyWith(
                                        color: AppColors.backColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                             
                            ],
                          ),
                        ),
                      )
                    ,
                     InkWell(
                        onTap: (){
                          var url ='https://vff-group.com/contactus/';
                          _OpenBrowser(url);
                          
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Row(
                            children: [
                              Image.asset('assets/clothes/support.png',width: 30,height: 30,),
                              SizedBox(width: height * 0.04,),
                              Text('Support',
                                    style: nunitoStyle.copyWith(
                                        color: AppColors.backColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                             
                            ],
                          ),
                        ),
                      )
                    ,
                     Visibility(
                      visible: false,
                       child: InkWell(
                          onTap: (){
                            //send to profile settings page
                     
                            //Navigator.pushNamed(context, DeliveryAddressRoute);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Row(
                              children: [
                                Image.asset('assets/clothes/settings.png',width: 30,height: 30,),
                                SizedBox(width: height * 0.04,),
                                Text('Settings',
                                      style: nunitoStyle.copyWith(
                                          color: AppColors.backColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                               
                              ],
                            ),
                          ),
                        ),
                     )
                    ,
                     InkWell(
                        onTap: (){
                          _showDialogDeleteAccount(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Row(
                            children: [
                              Image.asset('assets/clothes/delete_account.png',width: 30,height: 30,),
                              SizedBox(width: height * 0.04,),
                              Text('Delete Account',
                                    style: nunitoStyle.copyWith(
                                        color: AppColors.backColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                             
                            ],
                          ),
                        ),
                      )
                    ,
                     InkWell(
                        onTap: (){
                          //glb.justSaveAddress=true;
                          _showDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Row(
                            children: [
                              Image.asset('assets/clothes/logout.png',width: 30,height: 30,),
                              SizedBox(width: height * 0.04,),
                              Text('Log Out',
                                    style: nunitoStyle.copyWith(
                                        color: AppColors.backColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                             
                            ],
                          ),
                        ),
                      )
                    ,
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<void> _OpenBrowser(String url) async {
    final Uri launchUri = Uri.parse(url);
    try {
      await launchUrl(launchUri);
    } catch (e) {
      glb.showSnackBar(context, 'Alert', 'Currently under maintenance');
      print(e);
    }
  }
}


  
_showDialogDeleteAccount(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Text("Delete Account"),
                Icon(
                  Icons.dangerous_rounded,
                  color: Colors.red,
                ),
              ],
            ),
            content: new Text("Alert!😕" + "All Data Related to your account will be deleted permanently. Please be sure before you proceed."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Delete",style: TextStyle(
                  color: Colors.red
                ),),
                onPressed: () {
                  SharedPreferenceUtils.save_val("usrid", "");
                  Navigator.popAndPushNamed(context, OnBoardRoute);
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

_showDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Text("Log Out"),
                
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
            style: nunitoStyle.copyWith(
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
            style: nunitoStyle.copyWith(
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
                                      color: AppColors.backColor,
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
