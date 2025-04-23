import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';
import 'package:vff_group/gym_app/utils/common.dart';
import 'package:vff_group/pages/wallet_pages/widgets/round_gradient_button.dart';
import 'package:vff_group/united_armor_app/common/google_textformfield.dart';

class WalletSignUpPage extends StatefulWidget {
  const WalletSignUpPage({super.key});

  @override
  State<WalletSignUpPage> createState() => _WalletSignUpPageState();
}

class _WalletSignUpPageState extends State<WalletSignUpPage> {
  DateTime time =DateTime.now();
  TextEditingController instNameController = TextEditingController();
  TextEditingController instAddressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
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
              "assets/icons/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Wallet Approval Request",
          style: TextStyle(
              color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      
      ),
      backgroundColor: AppColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Image.asset(
                "assets/icons/date.png",
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                dateToString(time, formatStr: "E, dd MMMM yyyy"),
                style: TextStyle(color: AppColors.grayColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Time",
            style: TextStyle(
                color: AppColors.blackColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: media.width * 0.20,
            child: CupertinoDatePicker(
              onDateTimeChanged: (newDate) {},
              initialDateTime: DateTime.now(),
              use24hFormat: false,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.time,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Your Details",
            style: TextStyle(
                color: AppColors.blackColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 15,
          ),
         GoogleTextFormField(hintText: 'Enter Your Full Name', textInputType: TextInputType.text, labelText: 'Full Name as per Institution ID',textEditingController:fullNameController),
          
          
          const SizedBox(
            height: 20,
          ),
          Text(
            "Institution Details",
            style: TextStyle(
                color: AppColors.blackColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 15,
          ),
         GoogleTextFormField(hintText: 'Enter Your Institution Name', textInputType: TextInputType.text, labelText: 'Institution Name',textEditingController:instNameController),
          const SizedBox(
            height: 15,
          ),
          GoogleTextFormField(hintText: 'Enter Your Institution Address', textInputType: TextInputType.text, labelText: 'Address',textEditingController:instAddressController),
          const SizedBox(
            height: 15,
          ),
          
          Spacer(),
          RoundGradientButton(title: "Send Request", onPressed: () {}),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}

class IconTitleNextRow extends StatelessWidget {
  final String icon;
  final String title;
  final String time;
  final VoidCallback onPressed;
  final Color color;
  const IconTitleNextRow({Key? key, required this.icon, required this.title, required this.time, required this.onPressed, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: Image.asset(
                icon,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title ,
                style: TextStyle(color: AppColors.grayColor, fontSize: 12),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                time  ,
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.grayColor, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 25,
              height: 25,
              child:  Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/icons/p_next.png",
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
}
