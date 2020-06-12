import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/activity/home.dart';
import 'package:data_application/activity/register.dart';
import 'package:data_application/activity/student_nav.dart';
import 'package:data_application/common/Connectivity.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/user_data.dart';
import 'package:data_application/service/auth.dart';
import 'package:data_application/teacher_screens/navdrawer.dart';
import 'package:data_application/teacher_screens/teacher_home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _auth= AuthService();

  String reply;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  String  token;
  SharedPreferences prefs;
  String _mobile, _password;
  var map, ownerMap;
  bool passwordVisible = false;
  List<UserData> list = List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();
    passwordVisible = false;

  }
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        token = prefs.getString(UserPreferences.USER_FCM);
        userId = prefs.getString(UserPreferences.USER_ID);
    });
  }
  void _submitTask() async{
    try{


    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      CustomProgressLoader.showLoader(context);
   //   var isConnect = await ConectionDetecter.isConnected();

      dynamic result = await _auth.signInWithEmailAndPassword(_mobile, _password) ;
      if(result== null) {
        CustomProgressLoader.cancelLoader(context);

        Fluttertoast.showToast(
            msg:
            Constants.INCORRECT_PASSWORD,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);

      }else{
        CustomProgressLoader.cancelLoader(context);
        prefs = await SharedPreferences.getInstance();

        Firestore.instance
            .collection(Constants.USER_TABLE)
            .where("email", isEqualTo: _mobile )
            .snapshots()
            .listen((data) {
          data.documents.forEach((f) => //print('Usernamea ${f["name"]}')

          list.add(UserData(
              documentId: f.documentID,
              id: f.data['id'],
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
              classno: f.data['classno'],
              institute: f.data['institute'],
              status: f.data['status']))
          );
          try{
          Firestore.instance..collection(Constants.USER_TABLE)
              .document(list[0].documentId)
              .updateData({'fcm_token': '${token}'});
        } catch (e) {
          print(e.toString());
        }
          prefs.setString(UserPreferences.USER_ID, list[0].documentId);
          prefs.setString(UserPreferences.USER_EMAIL, list[0].email);
          prefs.setString(UserPreferences.USER_NAME, '${list[0].fname} ${list[0].lname}');
          prefs.setString(UserPreferences.USER_MOBILE, list[0].mobile);
          prefs.setString(UserPreferences.USER_INSTITUTE, list[0].institute);
          prefs.setString(UserPreferences.USER_CLASS, list[0].classno);

          if(list[0].type==Constants.STUDENT_PORTAL){
            prefs.setString(UserPreferences.LOGIN_STATUS, '${Constants.STUDENT_PORTAL}');

            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (BuildContext context) => StudentNavDrawer(0)));
          }else
            if(list[0].type==Constants.TEACHER_PORTAL){
              prefs.setString(UserPreferences.LOGIN_STATUS, '${Constants.TEACHER_PORTAL}');

              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (BuildContext context) => NavDrawer(0)));
            }

        /*  Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (BuildContext context) => TeacherHomePage(0)));*//*
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) => Home()));*/
        });


      }
    }
    } catch (e) {
      print(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
    final createLable = FlatButton(
      child: Text(
        'create account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
          Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) => Registration()));
      },
    );
    return /*new WillPopScope(
        onWillPop: _onWillPop,

        child:*/new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
      //  leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
        /*  Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new StartScreen(),
          ));*/
     //   }),
        automaticallyImplyLeading: false,

        title: Text(Constants.LOGIN_PAGE),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                   TextFormField(
                  decoration: InputDecoration(labelText: Constants.EMAIL_HINT),
                  validator: (valueMobile) =>
              //    valueMobile.length == 0 ? 'Please Enter Email' : null,
                     !valueMobile.contains('@') ? Constants.EMAIL_VALIDATION : null,
                  onSaved: (valueMobile) => _mobile = valueMobile,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(

                  decoration: InputDecoration(labelText: Constants.PASSWORD_HINT
                 , // Here is key idea
                   ),
                  validator: (valuePassword) =>
                  valuePassword.length < 6 ? Constants.PASSWORD_VALIDATION : null,
                  onSaved: (valuePassword) => _password = valuePassword,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                   new Container(
                       width: double.infinity,

                       child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: _submitTask,
                      textColor: Colors.white,
                      child: new Text(Constants.LOGIN_BUTTON),
                      color: Colors.green,
                      padding: new EdgeInsets.all(20.0),

                    ),
                    margin: new EdgeInsets.only(top: 25)
                ),
                SizedBox(height: 48.0),
                createLable
              ],
            ),
          ),
        ),
      ),
    //  ),
    );
  }
}