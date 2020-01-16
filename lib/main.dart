import 'package:flutter/material.dart';
import 'package:data_application/service/auth.dart';
import 'package:data_application/service/notification_service.dart';
import 'package:data_application/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {

  runApp(new MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,

    theme: ThemeData(
      primaryColor: Colors.green,
      accentColor: Colors.green,
      primaryColorBrightness: Brightness.dark,
    ),
  ),
  );
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: NotificationService(),
      ),
    );
  }
}