import 'package:data_application/activity/home.dart';
import 'package:data_application/activity/profile_edit.dart';
import 'package:data_application/activity/view_feedback.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
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
class StudentNavDrawer extends StatefulWidget {

  int po;
  StudentNavDrawer(this.po);
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
  //  new DrawerItem("Details", Icons.assignment),
    new DrawerItem("Feedback", Icons.settings),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];

  @override
  State<StatefulWidget> createState() {
    return new _StudentNavDrawerState();
  }
}

class _StudentNavDrawerState extends State<StudentNavDrawer> {
  int _selectedDrawerIndex = 0;

  String userId,name,email,_mobile;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
  /*    case 1:
        return new StudentDetails();*/
      case 1:
        return new ViewFeedback();
      case 2:
        return new Logout();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showdata();
    _selectedDrawerIndex=widget.po;

  }


  Future showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted) {

      setState(() {
        name = prefs.getString(UserPreferences.USER_NAME).toString();
        email = prefs.getString(UserPreferences.USER_EMAIL).toString();
        userId = prefs.getString(UserPreferences.USER_ID).toString();
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
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(

        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can inste  ad choose to have a static title
        backgroundColor: Colors.green,
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),

      ),
      drawer:  new Drawer(
        child: new SingleChildScrollView(child:new Column(children: <Widget>[ new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(

                decoration: new BoxDecoration(color: Colors.green),
                currentAccountPicture:

                new Center(

                  child: new Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (BuildContext context) =>  ProfileEdit(id: userId,)));
                          },
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
                accountName: new Text('${name}'),
                accountEmail :new Text('${email}')
            ),
            new Column(children: drawerOptions)
          ],
        ),
        ],),),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

