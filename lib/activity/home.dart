import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/activity/login.dart';
import 'package:data_application/activity/notification_list.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/user_data.dart';
import 'package:data_application/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  var isLoading = true;
  String name,email,id,token,status="0";
  AuthService auth = AuthService();
  List<UserData> list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();

  }
  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading=true;
      email = prefs.getString(UserPreferences.USER_EMAIL);
      name = prefs.getString(UserPreferences.USER_NAME);
      id = prefs.getString(UserPreferences.USER_ID);
       token= prefs.getString(UserPreferences.USER_FCM);


    }
    );
    Firestore.instance
        .collection(Constants.USER_TABLE)

        .where("email", isEqualTo: email )
        .snapshots()
        .listen((data) {
      data.documents.forEach((f) => //print('Usernamea ${f["name"]}')

      //status=doc["status"]
      list.add(UserData(id: f.data['id'],
          fname: f.data['fname'],
          lname: f.data['lname'],
          email: f.data['email'],
          city: f.data['city'],
          state: f.data['state'],
          country: f.data['country'],
          pincode: f.data['pincode'],
          address1: f.data['address1'],
          address2: f.data['address2'],
          type: f.data['type'],
          status: f.data['status']))
      );
      setState(() {
        isLoading=false;

      });
    });

  }
  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
   /* return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              await auth.signOut();
              prefs = await SharedPreferences.getInstance();
              prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          )

        ],
        automaticallyImplyLeading: false,
        title: Text(Constants.APPLICATION_NAME),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body:
      NotificationList(),
    );*/
    if(isLoading==false) {
      if (list.length != 0) {
        if (list[0].status == "0") {
          return new Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () async {
                    await auth.signOut();
                    prefs = await SharedPreferences.getInstance();
                    prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => Login()));
                  },
                )

              ],
              automaticallyImplyLeading: false,
              title: Text(Constants.APPLICATION_NAME),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body:
            new Column(children: <Widget>[
              new Container(
                  padding: EdgeInsets.fromLTRB(5.0,20.0,5.0,20.0),
                  child: new Text(
                    'Hello ${name}',
                    textAlign: TextAlign.center,)),
              new Center(
                child:
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                    new Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      new Container(
                          padding: EdgeInsets.fromLTRB(5.0,20.0,5.0,20.0),
                          child: new Text(
                            'Your registration request has been sent for approval. Please Contact your institute if not approved in 2 days',
                            textAlign: TextAlign.center,)),
                    )

                ),
              ),

            ],)

          );
        } else {
          return new Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () async {
                    await auth.signOut();
                    prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => Login()));
                  },
                )

              ],
              automaticallyImplyLeading: false,
              title: Text(Constants.APPLICATION_NAME),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body:
            NotificationList(),
          );
        }
        }
      } else {
        return new Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () async {
                    await auth.signOut();
                    prefs = await SharedPreferences.getInstance();
                    prefs.setString(UserPreferences.LOGIN_STATUS, "FALSE");
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => Login()));
                  },
                )

              ],
              automaticallyImplyLeading: false,
              title: Text(Constants.APPLICATION_NAME),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: Center(
                child: new Container(
                  child:
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0,
                    semanticsLabel: 'is Loading',),
                )
            )
        );
      }
    }
}