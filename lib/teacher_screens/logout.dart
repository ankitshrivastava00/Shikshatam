import 'package:data_application/activity/login.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  AuthService auth = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logout();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
    prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
    Navigator.pushReplacement(context,
        new MaterialPageRoute(
            builder: (BuildContext context) => Login()));

  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body:
        new Text("Logout"),

    );
  }
}
