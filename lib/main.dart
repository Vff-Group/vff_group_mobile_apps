import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:vff_group/providers/tabchangeprovider.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/routings/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vff_group/services/location_service.dart';
import 'package:vff_group/services/models/user_location.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => TabProvider(),
      child: MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
  print(message.notification!.body.toString());
  print(message.data.toString());
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  /*StreamProvider<UserLocation>(
      builder: (context) => LocationService().locationStream, */
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VFF Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          })),
      initialRoute: SplashRoute,
      onGenerateRoute: generateRoute,
    );
  }
}

final MaterialColor whiteMaterialColor = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },

  /*
  <int, Color>{
    50: Color(0x1AFFFFFF),
    100: Color(0x33FFFFFF),
    200: Color(0x4DFFFFFF),
    300: Color(0x66FFFFFF),
    400: Color(0x80FFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xC2FFFFFF),
    700: Color(0x8CFFFFFF),
    800: Color(0x59FFFFFF),
    900: Color(0x26FFFFFF),
  },
   */
);
