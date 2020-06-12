import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/feedback_model.dart';
import 'package:data_application/teacher_screens/feedback_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewFeedback extends StatefulWidget {
  @override
  ViewFeedbackState createState() => ViewFeedbackState();
}

class ViewFeedbackState extends State<ViewFeedback> {
  String reply = "", status = "",name="",institute="",classNo="",email="",user_id="";
  String items = "true";
  List<FeedbackModel> listForDetail = List();
  var isLoading = false;
  final Firestore auth =Firestore.instance;
  SharedPreferences prefs;


  void getInstitute() async {
    try{
      prefs = await SharedPreferences.getInstance();

      setState(() {
        classNo = prefs.getString(UserPreferences.USER_CLASS);
        name = prefs.getString(UserPreferences.USER_NAME);
        email= prefs.getString(UserPreferences.USER_EMAIL);
        user_id= prefs.getString(UserPreferences.USER_ID);
        institute= prefs.getString(UserPreferences.USER_INSTITUTE);
        isLoading = true;
      });
      getDataDetails();

    }catch(e){
      print(e.toString());
    }
  }


  @override
  void initState()  {
    super.initState();
    getInstitute();

  }


  void getDataDetails() {

    try{
      if (!mounted) return;
      setState(() {
        listForDetail.clear();

        isLoading = true;
      });

      auth
          .collection('${Constants.USER_TABLE}/${user_id}${Constants.FEEDBACK_TABLE}')
          .snapshots()
          .listen((data) {
        listForDetail.clear();
        data.documents.forEach((f) {
//          if ((f.data['classno']==_selectClass.Name||'select Class'==_selectClass.Name)){
            listForDetail.add(FeedbackModel(
                feedback: f.data['Feedback'].toString(),
                month: f.data['month'].toString(),
                teacher: f.data['teacher'].toString()
            )
            );

        //  }
        }
        );
        //foo();
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      });

    }catch(e){
      print(e.toString());
    }
  }

  @override
  void dispose() {
    //foo();
    listForDetail;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;

    return new Scaffold(
     /* appBar: AppBar(
        //  leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
        *//*  Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new StartScreen(),
          ));*//*
        //   }),
        // automaticallyImplyLeading: false,

        title: Text("Feedback"),
        backgroundColor: Colors.green,
      ),*/
      body:
      new SingleChildScrollView(
        child:
        new Padding
          (padding: EdgeInsets.all(5.0),
          child:
          Column(
            children: <Widget>[

              isLoading
                  ? Center(
                  child: new Container(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 5.0,
                      semanticsLabel: 'is Loading',
                    ),
                  ))
                  : ListView.builder(
                  shrinkWrap: true,
                  itemCount: listForDetail.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Container(
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          child: Card(
                            child: new Container(
                              margin:
                              EdgeInsets.fromLTRB(5.0, 7.0, 20.0, 0.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 0.0, 0.0, 0.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text('Teacher : ',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                              new Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 0.0, 0.0, 0.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  listForDetail[index].teacher,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),

                                          new Row(
                                            children: <Widget>[
                                              new Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10.0, 5.0, 0.0, 0.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text('Month : ',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.green,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              new Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 0.0, 0.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  listForDetail[index].month,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
new Row(
  children: <Widget>[
    new Container(
      margin: EdgeInsets.fromLTRB(
          10.0, 5.0, 0.0, 5.0),
      alignment: Alignment.topLeft,
      child: new Text('Feedback : ',
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.green,
            fontWeight:
            FontWeight.bold),
      ),
    ),
    new Container(
      margin: EdgeInsets.fromLTRB(
          10.0, 5.0, 0.0, 5.0),
      alignment: Alignment.topLeft,
      child: new Text(
        listForDetail[index].feedback,
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
            fontWeight:
            FontWeight.normal),
      ),
    ),
  ],
)

                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}