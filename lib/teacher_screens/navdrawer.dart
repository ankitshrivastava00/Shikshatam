import 'package:data_application/activity/home.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/teacher_screens/logout.dart';
import 'package:data_application/teacher_screens/student_details.dart';
import 'package:data_application/teacher_screens/student_feedback.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String name = "", email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showdata();
  }


  Future showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted) {

      setState(() {
      name = prefs.getString(UserPreferences.USER_NAME).toString();
      email = prefs.getString(UserPreferences.USER_EMAIL).toString();
    });
  }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          UserAccountsDrawerHeader(
            accountName: new Container(
                margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),


            accountEmail:    new Container(
              margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
              child: Text(
                email,
                style: TextStyle(color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(color: Colors.green),
            margin: EdgeInsets.only(bottom: 10.0),
            currentAccountPicture:
            new Center(

              child: new Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child:new Container(
                        width: 60.0,
                        height: 60.0,

                        decoration: new BoxDecoration(

                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,

                              image: new AssetImage('images/man.png'),

                            )
                        ),

                      ),

                    ),
                  ] ),
            ),
          ),


       /*   ListTile(
            leading: Icon(Icons.input),
            title: Text('Home'),
            onTap: () =>
            {Navigator.of(context).pop(),
                Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (BuildContext context) => Home()))},
          ),*/
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Details'),
            onTap: () => {Navigator.of(context).pop(),
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) => StudentDetails()))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop(),
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) => StudentFeedback()))
            },
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop(),
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (BuildContext context) => Logout()))},
          ),
        ],
      ),
    );
  }
}