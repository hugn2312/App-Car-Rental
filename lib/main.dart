import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app_car_rental/api/firebase_api.dart';
import 'package:app_car_rental/screen/Calender.dart';
import 'package:app_car_rental/screen/ChangeTab.dart';
import 'package:app_car_rental/screen/PayPal.dart';
import 'package:app_car_rental/screen/checkout.dart';
import 'package:app_car_rental/screen/detail_product.dart';
import 'package:app_car_rental/screen/home_page.dart';
import 'package:app_car_rental/screen/login.dart';
import 'package:app_car_rental/screen/login_page.dart';
import 'package:app_car_rental/screen/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'const/UserProvider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(
    ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static MyApp of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<MyApp>()!;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: content(),
    );
  }
  Widget content() {
    return AnimatedSplashScreen(
        splash: Container(
          child: Center(
              child: Lottie.asset(
                'assets/animations/car2.json',
              )
          ),
        ),
        duration: 3000,
        nextScreen: MainPage());
  }
}



