import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/bottom_page_main.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/delivery_login.dart';
import 'package:vff_group/pages/categories/dry_clean_home.dart';
import 'package:vff_group/pages/categories/wash_fold_home.dart';
import 'package:vff_group/pages/categories/wash_iron_home.dart';
import 'package:vff_group/pages/main_pages/bottom_bar.dart';
import 'package:vff_group/pages/login.dart';
import 'package:vff_group/pages/main_pages/detailed_pages/all_services_detail.dart';
import 'package:vff_group/pages/main_pages/detailed_pages/main_category_detailed.dart';
import 'package:vff_group/pages/main_pages/home.dart';
import 'package:vff_group/pages/main_pages/orders.dart';
import 'package:vff_group/pages/onboard_laundry.dart';
import 'package:vff_group/pages/orders_pages/checkout_page.dart';
import 'package:vff_group/pages/orders_pages/delivery_address_page.dart';
import 'package:vff_group/pages/orders_pages/my_bag_page.dart';
import 'package:vff_group/pages/orders_pages/order_details.dart';
import 'package:vff_group/pages/orders_pages/place_new_order.dart';
import 'package:vff_group/pages/splash_screen.dart';
import 'package:vff_group/routings/route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case LoginRoute:
      return _getPageRoute(const LoginScreen());
    case SplashRoute:
      return _getPageRoute(const SplashScreen());
    case OnBoardRoute:
      return _getPageRoute(const OnBoardingScreen());
    case MainRoute:
      return _getPageRoute( const BottomBarScreen(pageIndex: 0));
    case MainCategoryDetailsRoute:
      return _getPageRoute(const MainCategoryDetailedScreen());
    case WashAndIronRoute:
      return _getPageRoute(const WashAndIronScreenMain());
    case DryCleanRoute:
      return _getPageRoute(const DryCleanScreenMain());
    case OrderTabRoute:
      return _getPageRoute(const OrdersPage());
    case OrderDetailsRoute:
      return _getPageRoute(const OrderDetailsPage());
    // case PlaceOrderRoute:
    //   return _getPageRoute(const PlaceOrderPage());
    case DeliveryAddressRoute:
      return _getPageRoute(const DeliveryAddressPage());
    case AllServicesRoute:
      return _getPageRoute(const AllServicesPage());
    case MyBagRoute:
      return _getPageRoute(const MyBagPage());
    case CheckOutRoute:
      return _getPageRoute(const CheckOutScreen());
    case DMainRoute:
      return _getPageRoute(const BottomBarDeliveryBoy(pageDIndex: 0,));

// Delivery Boy Routes
    case DeliveryLoginRoute:
      return _getPageRoute(const DeliveryLoginScreen());

    default:
      return _getPageRoute(const SplashScreen());
  }
}

PageRoute _getPageRoute(Widget child) {
  return CupertinoPageRoute(builder: (context) => child);
}
// PageRoute _getPageRoute(Widget child) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => child,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.easeInOut;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }