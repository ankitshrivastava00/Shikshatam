import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NotificationList extends StatefulWidget {
  @override
  NotificationListState createState() => NotificationListState();
}

class NotificationListState extends State<NotificationList> {
  String reply = "", status = "";
  String items = "true";
  List<NotificationModel> lis = List();
  var isLoading = false;

  @override
  Future initState() {
    super.initState();
    getData();
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
            lis.add(NotificationModel(title: f.data['title'].toString(),description: f.data['description'].toString() )));

        setState(() {
          isLoading = false;

        });
      });

    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;

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
                        height: 170.0,
                        width: double.infinity,
                        child: CarouselSlider(
                            items:lis.map(
                                  (url) {
                                return Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: SingleChildScrollView(
                                        child: Column(
                                        children: <Widget>[
                                          new Text('Title : ${url.title}',style: TextStyle(color: Colors.white),),
                                          SizedBox(height: 15.0,),
                                          new Text('Description : ${url.description}',style: TextStyle(color: Colors.white),),

                                        ],
                                      )
                                  ),
                                  ),
                                );
                              },
                            ).toList() ,
                            height: 400.0,
                            autoPlay: true
                        ),
                      ),
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
                          child: new Text(
                            'Last Fees Paid On : ',
                            textAlign: TextAlign.center,)),
                    ),
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width:double.infinity ,
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
                          padding: EdgeInsets.all(40.0),
                          child: new Text(
                            'Next Fees Paid On : ',
                            textAlign: TextAlign.center,)),
                    )
                    )

                  ],
                )

              ),
              ),
              ),
            );
  }
}