import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/bottom_page_main.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/current_delivery.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/delivery_boy_notification.dart';
import 'package:vff_group/delivery_boy_app/pages/main_pages/delivery_login.dart';
import 'package:vff_group/gym_app/views/dashboard/dashboard_gym.dart';
import 'package:vff_group/gym_app/views/login/login_screen.dart';
import 'package:vff_group/gym_app/views/notification/notification_screen.dart';
import 'package:vff_group/gym_app/views/profile/complete_profile.dart';
import 'package:vff_group/gym_app/views/signup/signup.dart';
import 'package:vff_group/gym_app/views/welcome/welcome_screen.dart';
import 'package:vff_group/gym_app/views/your_goals/your_goals.dart';
import 'package:vff_group/pages/booking_pages/booking_details_page.dart';
import 'package:vff_group/pages/cart/cart_items_page.dart';
import 'package:vff_group/pages/categories/dry_clean_home.dart';
import 'package:vff_group/pages/categories/wash_fold_home.dart';
import 'package:vff_group/pages/categories/wash_iron_home.dart';
import 'package:vff_group/pages/google_verification.dart';
import 'package:vff_group/pages/main_pages/bottom_bar.dart';
import 'package:vff_group/pages/login.dart';
import 'package:vff_group/pages/main_pages/detailed_pages/all_services_detail.dart';
import 'package:vff_group/pages/main_pages/detailed_pages/main_category_detailed.dart';
import 'package:vff_group/pages/main_pages/home.dart';
import 'package:vff_group/pages/main_pages/notification_customer.dart';
import 'package:vff_group/pages/main_pages/orders.dart';
import 'package:vff_group/pages/onboard_laundry.dart';
import 'package:vff_group/pages/orders_pages/all_branches_page.dart';
import 'package:vff_group/pages/orders_pages/cancel_order_page.dart';
import 'package:vff_group/pages/orders_pages/checkout_page.dart';
import 'package:vff_group/pages/orders_pages/delivery_address_page.dart';
import 'package:vff_group/pages/orders_pages/feed_back_page.dart';
import 'package:vff_group/pages/orders_pages/my_bag_page.dart';
import 'package:vff_group/pages/orders_pages/order_details.dart';
import 'package:vff_group/pages/orders_pages/payment_page.dart';
import 'package:vff_group/pages/orders_pages/place_new_order.dart';
import 'package:vff_group/pages/registration_login.dart';
import 'package:vff_group/pages/set_delivery_location.dart';
import 'package:vff_group/pages/splash_screen.dart';
import 'package:vff_group/pages/verification_code_page.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/united_armor_app/views/cart/cart_page.dart';
import 'package:vff_group/united_armor_app/views/checkout/delivery_address_page.dart';
import 'package:vff_group/united_armor_app/views/dashboard/cloth_dashboard.dart';
import 'package:vff_group/united_armor_app/views/login/login.dart';
import 'package:vff_group/united_armor_app/views/payment/payment_page.dart';
import 'package:vff_group/united_armor_app/views/payment/payment_success.dart';
import 'package:vff_group/united_armor_app/views/product_details/product_details.dart';
import 'package:vff_group/united_armor_app/views/signup/signup.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case LoginRoute:
      return _getPageRoute(const LoginScreen());
    case RegistationRoute:
      return _getPageRoute(const RegistrationLoginPage());
    case VerificationRoute:
      return _getPageRoute(const VerificationPage());
    case GoogleVerificationRoute:
      return _getPageRoute(const GoogleVerificationPage());
    case SetDeliveryLocationRoute:
      return _getPageRoute(const SetDeliveryLocationPage());
    case BookingDetailsRoute:
      return _getPageRoute(const BookingDetailsPage());
    case SplashRoute:
      return _getPageRoute(const SplashScreen());
    case OnBoardRoute:
      return _getPageRoute(const OnBoardingScreen());
    case MainRoute:
      return _getPageRoute(const BottomBarScreen(pageIndex: 0));
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
    case AllBranchesRoute:
      return _getPageRoute(const AllBranchesPage());
    case MyBagRoute:
      return _getPageRoute(const MyBagPage());
    case MyCartRoute:
      return _getPageRoute(const AddToCartItem());
    case CheckOutRoute:
      return _getPageRoute(const CheckOutScreen());

    case FeedbackRoute:
      return _getPageRoute(const FeedBackPage());
    case CancelOrderRoute:
      return _getPageRoute(const CancelOrderPage());
    case CustomerNotificationRoute:
      return _getPageRoute(const CustomerNotifications());
    case DMainRoute:
      return _getPageRoute(const BottomBarDeliveryBoy(
        pageDIndex: 0,
      ));

// Delivery Boy Routes
    case DeliveryLoginRoute:
      return _getPageRoute(const DeliveryLoginScreen());
    case DeliveryBoyNotificationRoute:
      return _getPageRoute(const DeliveryBoyNotificationsPage());
    case CurrentOrderDeliveryRoute:
      return _getPageRoute(const CurrentDeliveryPage());

//GYM Routes
    case GymLoginRoute:
      return _getPageRoute(const LoginScreenGym());
    case SignupScreenRoute:
      return _getPageRoute(const SignUpScreen());
    case CompleteProfileScreenRoute:
      return _getPageRoute(const CompleteGymProfile());
    case YourGoalScreenRoute:
      return _getPageRoute(const YourFitnessGoalsScreen());
    case WelcomeScreenGymRoute:
      return _getPageRoute(const WelcomeScreenGymScreen());
    case DashboardScreenGymRoute:
      return _getPageRoute(const DashboardGymScreen(pageIndex: 0));
    case NotificationScreenRoute:
      return _getPageRoute(const GymNotificationScreen());


//United Armor Clothing
    case ClothingLoginRoute:
      return _getPageRoute(const LoginClothingScreen());    
    case ClothingRegisterRoute:
      return _getPageRoute(const SignUpClothingScreen());    
    case ClothingDashboardRoute:
      return _getPageRoute(const ClothingDashboard());    
    case ProductDetailsRoute:
      return _getPageRoute(const ProductDetailsPage());    
    case CartItemsClothingRoute:
      return _getPageRoute(const CartItemsClothingPage());    
    case ClothingDeliveryAddressRoute:
      return _getPageRoute(const ClothingDeliveryAddressPage());    
    case PaymentClothingRoute:
      return _getPageRoute(const PaymentPageClothing());    
    case PaymentSuccessRoute:
      return _getPageRoute(const PaymentSuccessPage());    

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
