import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fazal_test/user_flow_screens/edit_establishment_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/edit_profile_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/fazal_test_form.dart';
import 'package:flutter_fazal_test/user_flow_screens/home_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/inbox_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_for_job.dart';
import 'package:flutter_fazal_test/user_flow_screens/new_request_view.dart';
import 'package:flutter_fazal_test/user_flow_screens/push_notification_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/register_establishment_screen.dart';
import 'package:flutter_fazal_test/user_flow_screens/request_supplier.dart';
import 'package:flutter_fazal_test/user_flow_screens/write_review_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/input_otp_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/splash_screen.dart';
import 'package:flutter_fazal_test/user_login_screens_flow/verify_phone_no_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'const/ConstsVariable.dart';
import 'fazal_work/test_multipleImage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: MyAppSplash()),
    );
  }
}

//
// void main() {
//
//
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Scaffold(body: MyAppSplash()),
//   ));
// }


class MyAppSplash extends StatefulWidget {
  @override
  _MyAppSplashState createState() => new _MyAppSplashState();




  // Or do other work.
}

class _MyAppSplashState extends State<MyAppSplash> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    checkNotification();
    checkLogoutState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future onSelectNotification(var payload) async {
    return Navigator.push(context,
        MaterialPageRoute(builder: (context) => PushNotificationScreen()));
  }

  checkLogoutState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString('userid'));
    if (pref.getString('userid') != null) {
      ConstantsVariable.profileImage = pref.getString('thumbnailimage');
      ConstantsVariable.userName = pref.getString('name');
      ConstantsVariable.credits = pref.getString('credits');
      ConstantsVariable.isSupplier = pref.getString('isSupplier');
      ConstantsVariable.termsandcondition = pref.getString('terms');
      ConstantsVariable.aboutUs = pref.getString('about');
      ConstantsVariable.videourlWelcome = pref.getString('welcomevideo');
      ConstantsVariable.videourlAbout = pref.getString('aboutvideo');
      print('*welcomevideo' + ConstantsVariable.videourlWelcome);

      new Future.delayed(
          const Duration(seconds: 4),
              () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              ));
    } else {
      new Future.delayed(
          const Duration(seconds: 4),
              () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/images/ic_shout_out.png',
            fit: BoxFit.cover,
            width: 250.0,
            height: 250.0,
          ),
        ),
      ),
    );
  }

  Future showLocalNotification(String title, String desc) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'shoutOut', 'shoutOut', 'shoutOut',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    String trendingNewsId = '5';
    await flutterLocalNotificationsPlugin.show(
        0, title, desc, platformChannelSpecifics,
        payload: trendingNewsId);
  }

  void checkNotification() async {
    await Firebase.initializeApp();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showLocalNotification(message['notification']['title'],message['notification']['body']);
      },

      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        MyApp.navigatorKey.currentState
            .push(MaterialPageRoute(builder: (_) => PushNotificationScreen()));
      },
      onResume: (Map<String, dynamic> message) async {
        try {
          print(message.toString());
          print("onResume: $message");
          MyApp.navigatorKey.currentState
              .push(
              MaterialPageRoute(builder: (_) => PushNotificationScreen()));
        }
        catch (Exception) {

        }
      },
    );
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {

  }

}



//    return fcmMessageHandler();




//

