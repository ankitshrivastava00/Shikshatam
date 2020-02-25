import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/model/notification_model.dart';
import 'package:data_application/model/user_data.dart';
import 'package:data_application/teacher_screens/teacher_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDetails extends StatefulWidget {
  @override
  StudentDetailsState createState() => StudentDetailsState();
}

class StudentDetailsState extends State<StudentDetails> {
  String reply = "", status = "",name,email;
  String items = "true";
  List<UserData> lis = List();
  var isLoading = false;
  ClassModel _selectClass;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsClass;
  List classlist =  ClassModel.getCompanies();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Future initState() {
    super.initState();
    getData();
    showdata();


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


  void getData() {
    try{
      setState(() {
        lis.clear();

        isLoading = true;

      });
     // lis.clear();

      Firestore.instance
          .collection(Constants.USER_TABLE)
          .where("type", isEqualTo: Constants.STUDENT_PORTAL )
          .snapshots()
          .listen((data) {
        data.documents.forEach((f) {
          if (f.data['classno']==_selectClass.Name||'select Class'==_selectClass.Name){
          if(f.data['feesStatus']=='1'){
            lis.add(UserData(id: f.data['id'],
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
                feedback: f.data['feedback'],
                documentId: f.documentID,
                feeColor:  Color(0xFF00b300) as Color ,
                feeTest: 'Paid',
                feesStatus: f.data['feesStatus'],
                status: f.data['status']));
          }else{
            lis.add(UserData(id: f.data['id'],
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
                feedback: f.data['feedback'],
                documentId: f.documentID,
                feeColor:  Color(0xFFFF0000) as Color ,
                feeTest: 'Unpaid',
                feesStatus: f.data['feesStatus'],
                status: f.data['status']));
          }
          }
        }
        );
        foo();
      });

    }catch(e){
      print(e.toString());
    }
  }


  void changedDropDownItemClass(ClassModel selectedFruit) {
    setState(() {
      _selectClass = selectedFruit;
    });
    getData();

  }
  void foo() {
    if (this.mounted)  setState(() {
      isLoading = false;

    });
  }

  @override
  void dispose() {
    super.dispose();
    foo();
  }
  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;

    return new Scaffold(
      body:
      new Container(
        child:
        new SingleChildScrollView(
          child:
          new Padding
            (padding: EdgeInsets.all(5.0),
              child:
              Column(
                children: <Widget>[
                  new Container(
                    padding:EdgeInsets.all(5.0),
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
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.none),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                  isLoading ? Center(
                      child: new Container(
                        child:
                        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                          strokeWidth: 5.0,
                          semanticsLabel: 'is Loading',),
                      )
                  ):
                  ListView.builder(
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {

                      return Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Container(
                            child: Container(
                              margin: EdgeInsets.all(2.0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[



                                    new Container(
                                      margin: EdgeInsets.all(5.0),
                                      alignment: Alignment.topLeft,
                                      child: new Text(
                                        'Name : ${lis[index].fname} ${lis[index].lname}',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),


                                    new Row(
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 0.0, 0.0, 0.0),
                                          alignment: Alignment.topLeft,
                                          child: new Text(
                                            'Class No : ',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        new Container(
                                          margin: EdgeInsets.all(5.0),
                                          alignment: Alignment.topLeft,
                                          child: new Text('${lis[index].classno} ',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Container(
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Container(
                                                margin: EdgeInsets.all(
                                                    5.0),
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  'Fees Status :',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              new GestureDetector(
                                                onTap: ()  {
                                                  if(lis[index].feesStatus=="1"){
                                                    try{
                                                      Firestore.instance..collection(Constants.USER_TABLE)
                                                          .document(lis[index].documentId)
                                                          .updateData({'feesStatus': '0'});

                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                    Navigator.pushReplacement(context,
                                                        new MaterialPageRoute(builder: (BuildContext context) => TeacherHomePage(1)));
                                                  }else{
                                                    try{
                                                      Firestore.instance..collection(Constants.USER_TABLE)
                                                          .document(lis[index].documentId)
                                                          .updateData({'feesStatus': '1'});

                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                    Navigator.pushReplacement(context,
                                                        new MaterialPageRoute(builder: (BuildContext context) => TeacherHomePage(1)));
                                                  }
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.all(
                                                      7.0),
                                                  alignment: Alignment.topRight,
                                                  child: Text('${lis[index].feeTest}',
                                                    style: TextStyle(
                                                      backgroundColor: lis[index].feeColor,
                                                        fontSize: 15.0,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                     //   ),
                      );
                    },
                    itemCount: lis.length,
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}