import 'package:flutter/material.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
class Footer_Part extends StatelessWidget {
  const Footer_Part({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyLightColor,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Accepted Payment Methods',
                  style: poppinsStyle.copyWith(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Image.asset('assets/icons/payment_modes.jpeg'),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Phone Support',
                  style: poppinsStyle.copyWith(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    '+91-06364912877',
                    style: poppinsStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    'Monday - Saturday from (9 AM - 6 PM)',
                    style: poppinsStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.whiteColor,
            ),
              
            Row(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Contact Us',
                  style: poppinsStyle.copyWith(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    'care@unitedarmor.in',
                    style: poppinsStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26.0, top: 5.0),
              child: Row(
                children: [
                  Text(
                    'Monday - Saturday from (9 AM - 6 PM)',
                    style: poppinsStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
