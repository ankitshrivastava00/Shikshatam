import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DashboardList extends StatefulWidget {
  @override
  DashboardListState createState() => DashboardListState();
}

class DashboardListState extends State<DashboardList> {
  FocusNode myFocusNode = FocusNode();


  final formate ={
    TextInputType.datetime : DateFormat
  };
  DateTime currentDateTime =DateTime.now();
  String reply = "", status = "",name="",token="",email="",USER_INSTITUTE="";
  String items = "true";
  List<NotificationModel> lis = List();
  var isLoading = false;
  ClassModel _selectClass;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsClass;
  TextEditingController emailController = new TextEditingController(text: '');
  HttpsCallable sendNotification,callable;
  List<Institute> list = List();
  List<DropdownMenuItem<Institute>> _dropDownMenuItems;

  Institute _selectedFruit;
  List classlist =  ClassModel.getCompanies();
  String _response = 'no response';
  int _responseCount = 0;
  int _current = 0;

  @override
  Future initState() {
    super.initState();
    getData();
    showdata();

    getInstitute();
    callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'addUser')
      ..timeout = const Duration(seconds: 30);

     sendNotification = CloudFunctions.instance
        .getHttpsCallable(functionName: 'sendNotification')
      ..timeout = const Duration(seconds: 30);



    _dropDownMenuItemsClass = buildAndGetDropDownMenuItemsClass(classlist);
    _selectClass = _dropDownMenuItemsClass[0].value;

  }


  void getInstitute() {
    try{
      setState(() {
        isLoading = true;
      });

      list.add( Institute(id: '1',name: 'select Institute',city: '',state:'',country:'',pincode:'' ,address:'' ));

      Firestore.instance
          .collection(Constants.INSTITUTE_TABLE)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) =>
            list.add( Institute(id: f.data['id'],name: f.data['name'],city: f.data['city'],state:f.data['state'],country:f.data['country'],pincode:f.data['pincode'] ,address:f.data['address'] )));

        _dropDownMenuItems = buildAndGetDropDownMenuItems(list);


        _selectedFruit = _dropDownMenuItems[0].value;

        if (!mounted) return;
        setState(() {
          isLoading = false;

        });
      });

    }catch(e){
      print(e.toString());
    }
  }

  Future showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      name = prefs.getString(UserPreferences.USER_NAME).toString();
      email = prefs.getString(UserPreferences.USER_EMAIL).toString();
      USER_INSTITUTE = prefs.getString(UserPreferences.USER_INSTITUTE).toString();
      token = prefs.getString(UserPreferences.USER_FCM).toString();
    });
  }
  void getData() {

    try{
      if (!mounted) return;

      setState(() {
        isLoading = true;
      });

      Firestore.instance
          .collection('${Constants.NOTIFICATION_TABLE}')
          .where("type", isEqualTo: Constants.TEACHER_PORTAL )
          //.orderBy('datetime', descending: false)
        //  .orderBy("datetime",descending: true)
          .limit(5)
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

                  lis.add(NotificationModel(title: f.data['title'].toString(),
                      description: f.data['description'].toString()));

                if (!mounted) return;

                setState(() {
                  isLoading = false;
                });
              }
              );
            }
      });

    }catch(e){
      print(e.toString());
    }
  }
  void changedDropDownItemClass(ClassModel selectedFruit) {
    if (!mounted) return;

    setState(() {
      _selectClass = selectedFruit;
    });
  }

  List<DropdownMenuItem<ClassModel>> buildAndGetDropDownMenuItemsClass(List institute) {
    List<DropdownMenuItem<ClassModel>> items = new List();
    for (ClassModel i in institute) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.Name),
        ),
      );
    }

    return items;
  }

  List<DropdownMenuItem<Institute>> buildAndGetDropDownMenuItems(List institute) {
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


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void changedDropDownItem(Institute selectedFruit) {
    if (!mounted) return;

    setState(() {
      _selectedFruit = selectedFruit;
    });
  }

  void getNotification_token(String ClassNo,String Institute){
    try{
      Firestore.instance
          .collection(Constants.USER_TABLE)
          .where("classno", isEqualTo: '${ClassNo}' )
          .where("institute", isEqualTo: '${USER_INSTITUTE}' )
          .where("type", isEqualTo: 'user' )
          .where("status", isEqualTo: '1' )
          .snapshots()
          .listen((data) {
        data.documents.forEach((f) async{
          if(f.data['fcm_token'].toString().trim()!='${token.toString().trim()}'){
            final HttpsCallableResult result1 = await sendNotification
                .call(
              <String, dynamic>{
                'fcm': '${f.data['fcm_token']}',
                'classno': '${_selectClass.Name}',
                'title': '${name}',
                'description': '${emailController.text}',
              },
            );
            print('wearwerwerwe ${result1.data}');
        }

        }
      //  }
        );
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
                      height: 140.0,
                      width: double.infinity,
                      child:
                      CarouselSlider(
                          autoPlay: false,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        enableInfiniteScroll: false,

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
                                        new Text('${url.description}',style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),

                                      ],
                                    ),
                                    )
                                ),
                              );
                            },
                          ).toList() ,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  new Container(
                    padding:EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
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

               /*   SizedBox(height: 10.0,),
                  new Container(
                    padding:EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                    child: new SizedBox(
                        width: double.infinity,
                        //  child: new Center(
                        child:  new DropdownButton(
                          value: _selectedFruit,
                          items: _dropDownMenuItems,
                          onChanged: changedDropDownItem,
                        )
                      // ),
                    ),
                    // margin: EdgeInsets.only(left: 15.0),
                  ),*/
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
                            controller: emailController,

                            obscureText: false,

                            decoration: InputDecoration(hintText: Constants.NOTIFICATION_HINT,
                              border: InputBorder.none,),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            autofocus: false,
                            enableSuggestions: false,
                            focusNode: myFocusNode,
                            maxLength: 100,

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
                    onPressed: () async {

                      try {
                        if ('select Class'==_selectClass.Name) {
                          Fluttertoast.showToast(
                              msg: "Select Class",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else /* if(_selectedFruit.name=="select Institute"){

                          Fluttertoast.showToast(
                              msg:
                              Constants.INSTITUTE_VALIDATION,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }else */ if (emailController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Field Empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else  {

                          CustomProgressLoader.showLoader(Constants.applicationContext);
                          getNotification_token('${_selectClass.Name}','${_selectedFruit.name}');
                          print('testingtegrrrr');

                          final HttpsCallableResult result = await callable
                              .call(
                            <String, dynamic>{
                              'classno': '${_selectClass.Name}',
                              'institute': '${USER_INSTITUTE}',
                              'title': '${Constants.APPLICATION_NAME}',
                              'description': emailController.text,
                              'user': 'All',
                              'type': '${Constants.STUDENT_PORTAL}',
                              // 'datetime':new DateTime.now(),
                            //  'datetime': '${DateTime.now().toUtc().millisecondsSinceEpoch}',
                             // 'datetime': '${DateTime.now().toUtc().millisecondsSinceEpoch}',

                            },

                          );
                          Fluttertoast.showToast(
                              msg:
                              Constants.NOTIFICATION_SEND,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          print(result.data);

                          if (!mounted) return;

                          setState(() {
                            _response = result.data['repeat_message'];
                            _responseCount = result.data['repeat_count'];
                            emailController.text='';

                          });
                          print('testingtegrr');


                          CustomProgressLoader.cancelLoader(context);

                        }
                      } on CloudFunctionsException catch (e) {
                        print('caught firebase functions exception');
                        print(e.code);
                        setState(() {
                          emailController.text='';
                        });
                        Fluttertoast.showToast(
                            msg:
                            Constants.NOTIFICATION_SEND,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print(e.message);
                        print(e.details);
                        CustomProgressLoader.cancelLoader(Constants.applicationContext);

                      } catch (e) {
                        print('caught generic exception');
                        setState(() {
                          emailController.text='';
                        });
                        Fluttertoast.showToast(
                            msg:
                            Constants.NOTIFICATION_SEND,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print(e);
                        setState(() {

                        });
                        CustomProgressLoader.cancelLoader(Constants.applicationContext);
                      }
                     /* CloudFunctions.instance.call(
                        functionName: "addUser",
                        parameters: {
                        "name": 'Testts',
                        "email": "sdhshfhsdf"
                          }
                      );*/
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