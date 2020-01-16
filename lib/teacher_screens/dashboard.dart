import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardList extends StatefulWidget {
  @override
  DashboardListState createState() => DashboardListState();
}

class DashboardListState extends State<DashboardList> {
  String reply = "", status = "",name,email;
  String items = "true";
  List<NotificationModel> lis = List();
  var isLoading = false;
  Institute _selectClass;
  List<DropdownMenuItem<Institute>> _dropDownMenuItemsClass;
  List<Institute> classlist = List();

  @override
  Future initState() {
    super.initState();
    getData();
    showdata();
    classlist.add( Institute(id: '1',name: 'select Class',city: '',state:'',country:'',pincode:'' ,address:'' ));
    classlist.add( Institute(id: '2',name: '10',city: '',state:'',country:'',pincode:'' ,address:'' ));

    _dropDownMenuItemsClass = buildAndGetDropDownMenuItemsClass(classlist);
    _selectClass = _dropDownMenuItemsClass[0].value;

  }

  Future showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString(UserPreferences.USER_NAME).toString();
      email = prefs.getString(UserPreferences.USER_EMAIL).toString();
    });
  }


  List<DropdownMenuItem<Institute>> buildAndGetDropDownMenuItemsClass(List institute) {
    List<DropdownMenuItem<Institute>> items = new List();
    for (Institute i in institute) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.name),
        ),
      );
    }

    return items;
  }

  void getData() {

    try{
      setState(() {
        isLoading = true;
      });

      Firestore.instance
          .collection('notification')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) =>
            lis.add(NotificationModel(title: f.data['title'],description: f.data['description'] )));

        setState(() {
          isLoading = false;

        });
      });

    }catch(e){
      print(e.toString());
    }
  }


  void changedDropDownItemClass(Institute selectedFruit) {
    setState(() {
      _selectClass = selectedFruit;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      new Container(
        child:isLoading ? Center(
            child: new Container(
              child:
              CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                strokeWidth: 5.0,
                semanticsLabel: 'is Loading',),
            )
        ):
        new SingleChildScrollView(
          child:
          new Padding
            (padding: EdgeInsets.all(5.0),
              child:
              Column(
                children: <Widget>[
            new Card(
                    color: Colors.lightGreen,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: new SizedBox(
                      height: 140.0,
                      width: double.infinity,
                      child: CarouselSlider(
                          items:lis.map(
                                (url) {
                              return Container(
                                margin: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    child:SingleChildScrollView(
                                      child: Column(
                                      children: <Widget>[

                                        new Text('${url.title}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.center,),
                                        SizedBox(height: 15.0,),
                                        new Text('Description : ${url.description}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),

                                      ],
                                    ),
                                    )
                                ),
                              );
                            },
                          ).toList() ,
                          autoPlay: true
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  new Container(
                    padding:EdgeInsets.all(10.0),
                    child: new SizedBox(
                        width: double.infinity,
                        //  child: new Center(
                        child:  new DropdownButton(
                          value: _selectClass,
                          items: _dropDownMenuItemsClass,
                          onChanged: changedDropDownItemClass,
                        )
                      // ),
                    ),
                    // margin: EdgeInsets.only(left: 15.0),
                  ),

                  SizedBox(height: 20.0,),

                  SizedBox(
                    width:double.infinity ,
                    child: new Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:

                      new Container(
                          padding: EdgeInsets.all(40.0),
                          child: new TextField(
                            decoration: InputDecoration(hintText: Constants.NOTIFICATION_HINT,
                              border: InputBorder.none,),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            autofocus: false,
                          )),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {

                    },
                    child: Text(
                      "Send Notification".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              )

          ),
        ),
      ),
    );
  }
}