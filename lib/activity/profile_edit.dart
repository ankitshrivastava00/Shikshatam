import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class ProfileEdit extends StatefulWidget {

  ProfileEdit({Key key,this.id}) : super(key: key);
final String id;
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  var isLoading = false;



  String _first_name,
      _last_name,
      _mobile,
      _email,
      _city,
      _address1,
      _address2,
      _state,
      _class,
      _institute,
      _country,
      _pincode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataDetails(widget.id);

  }



    void getDataDetails(String DocumentId) {

    try{
      //   CustomProgressLoader.showLoader(Constants.applicationContext);

      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      Firestore.instance
          .collection('${Constants.USER_TABLE}').document('${DocumentId}')
          .snapshots()
          .listen((data) {
        //  CustomProgressLoader.cancelLoader(Constants.applicationContext);

        if(data.data == null){

          Fluttertoast.showToast(
              msg: 'No Data Found',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          if (!mounted) return;
          setState(() {
            isLoading = false;

          });
        }else {


          if (!mounted) return;
          setState(() {

            _first_name=data['fname'].toString();
            _last_name=data['lname'].toString();
            _mobile=data['mobile'].toString();
            _email=data['email'].toString();
            _city=data['city'].toString();
            _state=data['state'].toString();
            _country=data['country'].toString();
            _pincode=data['pincode'].toString();
            _address1=data['address1'].toString();
            _address2=data['address2'].toString();
            _institute=data['institute'].toString();
            _class=data['classno'].toString();

            isLoading = false;

          });
        }

      });

    }catch(e){
      //   CustomProgressLoader.cancelLoader(Constants.applicationContext);

      print(e.toString());
    }
  }

  Future<bool> _onWillPop() {


  }

  @override
  Widget build(BuildContext context) {
    return  new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: formKey,
          child: isLoading
              ? Center(
            child: CircularProgressIndicator(),
          ):
          new SingleChildScrollView(
            //   child: new Column(
            //padding: EdgeInsets.all(25.0),

            child: new Column(children: <Widget>[

              new  Padding(
                padding: EdgeInsets.all(0.0),
                child: new Stack(fit: StackFit.loose, children: <Widget>[
                  new Container(
                    constraints: new BoxConstraints.expand(
                      height: 150.0,
                    ),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('images/profilebackground.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child:new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image:new AssetImage('images/man.png'),
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
                )
                ,),
              new Row(children: <Widget>[
                new Expanded(
                  child:Container(
                    child: new TextFormField(
                      initialValue: '${_first_name}',

                      decoration: InputDecoration(labelText: Constants.FIRST_NAME_HINT),
                      readOnly: true,
                      enabled: false,
                    ),
                    margin: EdgeInsets.all(10.0),
                  ),
                ),
                new Expanded(

                  child:Container(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: Constants.LAST_NAME_HINT),

                      initialValue: '${_last_name}',
                      readOnly: true,
                      enabled: false,
                    ),
                    margin: EdgeInsets.all(10.0),
                  ),
                ),
              ]
              ),

          Container(
            margin: EdgeInsets.all(10.0),

            child: TextFormField(
                decoration: InputDecoration(labelText: Constants.EMAIL_HINT),
                readOnly: true,
                enabled: false,
              initialValue: _email,

            ),
          ),

          Container(
            margin: EdgeInsets.all(10.0),

            child:

              TextFormField(
                decoration: InputDecoration(labelText: Constants.MOBILE_HINT),
                 initialValue: _mobile,
                readOnly: true,
                enabled: false,
              ),),

          Container(
            margin: EdgeInsets.all(10.0),

            child:
              TextFormField(
                decoration: InputDecoration(labelText: Constants.ADDRESS1_HINT),
                readOnly: true,
                enabled: false,
                initialValue: _address1,

              ),

          ),

          Container(
            margin: EdgeInsets.all(10.0),

            child:
              TextFormField(
                decoration: InputDecoration(labelText: Constants.ADDRESS2_HINT),
                readOnly: true,
                enabled: false,
                initialValue: _address2,

              ),),

          Container(
            margin: EdgeInsets.all(10.0),

            child:
 TextFormField(
                decoration: InputDecoration(labelText: Constants.COUNTRY_HINT),
   readOnly: true,
   enabled: false,
   initialValue: _country,

 ),),

          Container(
            margin: EdgeInsets.all(10.0),

            child:
 TextFormField(
                decoration: InputDecoration(labelText: Constants.STATE_HINT),
   readOnly: true,
   enabled: false,
   initialValue: _state,

 ),),

          Container(
            margin: EdgeInsets.all(10.0),

            child:
TextFormField(
                decoration: InputDecoration(labelText: Constants.CITY_HINT),
  readOnly: true,
  enabled: false,
  initialValue: _city,

),),

              Container(
                margin: EdgeInsets.all(10.0),

                child:
                TextFormField(
                  decoration: InputDecoration(labelText: Constants.PINCODE_HINT),
                  readOnly: true,
                  enabled: false,
                  initialValue: _pincode,

                ),
                // margin: EdgeInsets.only(left: 15.0),
              ),
            new Container(
              margin: EdgeInsets.all(10.0),
                child:
                TextFormField(
                  decoration: InputDecoration(labelText: Constants.CLASS_HINT),
                  readOnly: true,
                  enabled: false,
                  initialValue: _class,

                ),
                // margin: EdgeInsets.only(left: 15.0),
              ),
            new Container(
              margin: EdgeInsets.fromLTRB(10.0,10.0,10.0,25.0),
                child:
                TextFormField(
                  decoration: InputDecoration(labelText: Constants.INSTITUTE_HINT),
                  readOnly: true,
                  enabled: false,
                  initialValue: _institute,

                ),
                // margin: EdgeInsets.only(left: 15.0),
              ),
            ],
            ),
          ),
          // ),

        ),

      ),


    );
  }
}
