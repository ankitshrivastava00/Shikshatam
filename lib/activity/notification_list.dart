import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/notification_model.dart';
import 'package:data_application/model/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  NotificationList({Key key,this.listForDetail}) : super(key: key);
  UserData listForDetail;

  @override
  NotificationListState createState() => NotificationListState();
}

class NotificationListState extends State<NotificationList> {

  String reply = "", status = "",id="";
  String items = "true";
  List<NotificationModel> lis = List();
  var isLoading = false;
  SharedPreferences prefs;
  String classNo,institute,name;
  String LastFeesYear="",LastFeesMonth="null",LastFeesPaid="",NextFeesYear="",NextFeesMonth="",NextFeesPaid="";

  @override
  Future initState() {
    super.initState();
    getData();
  }
  void getDataDetails(String DocumentId) {

    try{
      //   CustomProgressLoader.showLoader(Constants.applicationContext);

      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      
    }catch(e){
      // CustomProgressLoader.cancelLoader(Constants.applicationContext);

      print(e.toString());
    }
  }

  void getData() async {
    try{
        prefs = await SharedPreferences.getInstance();
      setState(() {
        isLoading=true;
        id = prefs.getString(UserPreferences.USER_ID);
        classNo = prefs.getString(UserPreferences.USER_CLASS);
        name = prefs.getString(UserPreferences.USER_NAME);
        institute= prefs.getString(UserPreferences.USER_INSTITUTE);
      }
      );
        Firestore.instance
            .collection('${Constants.USER_TABLE}/${id}${Constants.FEES_TABLE}')
            .orderBy('monthyear',descending: false)
            .getDocuments()
            .then((QuerySnapshot snapshot) {

          if(snapshot.documents.length==0){
            setState(() {
              LastFeesMonth='null';
              NextFeesMonth='null';
            });

          }else {

            snapshot.documents.forEach((f) {
              if(f.data['Status'].toString()=="1"){
                setState(() {
                  LastFeesYear=f.data['year'].toString();
                  LastFeesMonth=f.data['month'].toString();
                  LastFeesPaid=f.data['Fees'].toString();
                });
              }
              if(f.data['Status'].toString()=="0"){
                setState(() {
                  NextFeesYear=f.data['year'].toString();
                  NextFeesMonth=f.data['month'].toString();
                  NextFeesPaid=f.data['Fees'].toString();
                });
              }

            }
            );
          }
        }
        );

      
      Firestore.instance
          .collection('${Constants.NOTIFICATION_TABLE}')
       //   .where("type",isEqualTo:Constants.STUDENT_PORTAL )

       /* .where("type", isEqualTo: Constants.STUDENT_PORTAL )
        .where("class", isEqualTo: '${classNo}' )
        .where("institute", isEqualTo: '${institute}')*/
        .orderBy('datetime',descending: true)
//      .orderBy("datetime")
         // .limit(5)
          .getDocuments()
          .then((QuerySnapshot snapshot) {

        if(snapshot.documents.length==0){
          lis.add(
              NotificationModel(title: '${Constants.APPLICATION_NAME}',
                  description: 'Welcome ${name}'));
          setState(() {
            isLoading = false;
          });
        }else {

        snapshot.documents.forEach((f) {

          if( f.data['type'].toString()== Constants.STUDENT_PORTAL && f.data['class'].toString()== '${classNo}' && f.data['institute'].toString()== '${institute}'){

            if(lis.length!=5){
              lis.add(NotificationModel(title: f.data['title'].toString(),
                  description: f.data['description'].toString()));

            }

          }
          if(lis.length==0){
            lis.add(
                NotificationModel(title: '${Constants.APPLICATION_NAME}',
                    description: 'Welcome ${name}'));
          }
          setState(() {
            isLoading = false;
          });
          }
          );
      }
      }
        );
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
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            items:lis.map(
                                  (url) {
                                return Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: SingleChildScrollView(
                                        child: Column(
                                        children: <Widget>[
                                          new Text('${url.title}',style: TextStyle(color: Colors.white),),
                                          SizedBox(height: 15.0,),
                                          new Text('${url.description}',style: TextStyle(color: Colors.white),),

                                        ],
                                      )
                                  ),
                                  ),
                                );
                              },
                            ).toList() ,
                            height: 400.0,
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
                          child: new Text(LastFeesMonth==null||LastFeesMonth=='null'?'Last Fees Paid On: N/A':
                            'Last Fees Paid On: RS. ${LastFeesPaid}/- \n ${LastFeesMonth} - ${LastFeesYear}',
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
                          child: new Text(NextFeesMonth==null||NextFeesMonth=='null'?'Next Fees To Be Paid On: N/A'
                              :'Next Fees To Be Paid On: Rs ${NextFeesPaid}/-  \n ${NextFeesMonth} - ${NextFeesYear}',
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