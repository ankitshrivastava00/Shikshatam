import 'package:data_application/activity/home.dart';
import 'package:data_application/activity/login.dart';
import 'package:data_application/activity/student_nav.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/model/user.dart';
import 'package:data_application/teacher_screens/navdrawer.dart';
import 'package:data_application/teacher_screens/teacher_home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:data_application/common/UserPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

var flutterLocalNotificationsPlugin;

class NotificationService extends StatefulWidget {

  @override
  _NotificationServiceState createState() => new _NotificationServiceState();
}

class _NotificationServiceState extends State<NotificationService> {
  SharedPreferences prefs ;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  startTime() async {
    prefs = await SharedPreferences.getInstance();
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  Future navigationPage() async {
    String status = prefs.getString(UserPreferences.LOGIN_STATUS).toString();
    print(status);

    if(status == 'FALSE'){

      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => Login()));
    }else if(status == '${Constants.STUDENT_PORTAL}'){

      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => StudentNavDrawer(0)));
    }else if(status == '${Constants.TEACHER_PORTAL}'){

      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => NavDrawer(0)));
    }else{

      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    firebaseCloudMessaging_Listeners();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future _showNotification(String title,String message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '${title}', '${message}', platformChannelSpecifics,
        payload: message);
  }


  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    Navigator.push(
      Constants.applicationContext,
      new MaterialPageRoute(
        builder: (context) => new Home(),
      ),
    );
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            /*onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                Constants.applicationContext,
                new MaterialPageRoute(
                  builder: (context) => new NotificationService(),
                ),
              );

            },*/
          )
        ],
      ),
    );
  }

  void firebaseCloudMessaging_Listeners() {

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print('token_print '+token);
      prefs.setString(UserPreferences.USER_FCM, token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var notification = message['notification'];
        String title = notification['title'];
        String body = notification['body'];
        _showNotification(title,body);

      },
      onResume: (Map<String, dynamic> message) async {

      },
      onLaunch: (Map<String, dynamic> message) async {
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
    final user = Provider.of<User>(context);

    return new Scaffold(
      body: new Center(
        child: new Image.asset('images/splash.jpeg'),
      ),
    );
  }
  }