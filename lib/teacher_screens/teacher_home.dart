import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/teacher_screens/dashboard.dart';
import 'package:data_application/teacher_screens/logout.dart';
import 'package:data_application/teacher_screens/student_details.dart';
import 'package:data_application/teacher_screens/student_feedback.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;

  IconData icon;
  DrawerItem(this.title, this.icon);
}

class TeacherHomePage extends StatefulWidget {

  var valua;
  TeacherHomePage(this.valua);
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Details", Icons.insert_drive_file),
    new DrawerItem("Feedback", Icons.feedback),
    new DrawerItem("Logout", Icons.power_settings_new),
  ];

  @override
  State<StatefulWidget> createState() {
    return new TeacherHomePageState();
  }
}

class TeacherHomePageState extends State<TeacherHomePage> {
  String name = "", email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDrawerIndex=widget.valua;
    showdata();
     }



  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashboardList();
      case 1:
        return new StudentDetails();
      case 2:
        return new StudentFeedback();
      case 3:
        return new Logout();
      default:
        return new Text("Error");
    }
  }
  Future showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString(UserPreferences.USER_NAME).toString();
      email = prefs.getString(UserPreferences.USER_EMAIL).toString();
    });
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return
     new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: <Widget>[
         new Container(
          margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
          child: new GestureDetector(
            child: new Stack(
              children: <Widget>[
                new IconButton(icon: new Icon(Icons.settings,
                  color: Colors.white,),),
              ],
            ),
          )
      ),
        ],
      ),
      drawer: new Drawer(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
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
                accountName: new Container(
                    margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                accountEmail: new Container(
                    child: new Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                      child: Text(
                        email,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    //  )
    );
  }
}



