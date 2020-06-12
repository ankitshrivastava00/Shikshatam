import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/details_model.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/model/user_data.dart';
import 'package:data_application/teacher_screens/feedback_status.dart';
import 'package:data_application/teacher_screens/fees_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentFeedback extends StatefulWidget {
  @override
  StudentFeedbackState createState() => StudentFeedbackState();
}

class StudentFeedbackState extends State<StudentFeedback> {
  String reply = "", status = "",name="",institute="",classNo="",email="";
  String items = "true";
  List<DetailsModel> listForDetail = List();
  var isLoading = false;
  ClassModel _selectClass;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsClass;
  List classlist =  ClassModel.getCompanies();
  final Firestore auth =Firestore.instance;
  SharedPreferences prefs;

  List<Institute> list = List();
  List<DropdownMenuItem<Institute>> _dropDownMenuItems;
  Institute _selectedFruit;

  void getInstitute() async {
    try{
      prefs = await SharedPreferences.getInstance();

      setState(() {
        classNo = prefs.getString(UserPreferences.USER_CLASS);
        name = prefs.getString(UserPreferences.USER_NAME);
        institute= prefs.getString(UserPreferences.USER_INSTITUTE);
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

  void changedDropDownItem(Institute selectedFruit) {
    if (!mounted) return;

    setState(() {
      _selectedFruit = selectedFruit;
    });
    getDataDetails();

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
  void initState()  {
    super.initState();

    //foo();
    _dropDownMenuItemsClass = buildAndGetDropDownMenuItemsClass(classlist);
    _selectClass = _dropDownMenuItemsClass[0].value;
    getInstitute();
    getDataDetails();

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

  void getDataDetails() {

    try{
      if (!mounted) return;
      setState(() {
        listForDetail.clear();

        isLoading = true;
      });

      auth
          .collection(Constants.USER_TABLE)
          .where("type", isEqualTo: Constants.STUDENT_PORTAL )
          .where("institute", isEqualTo: '${institute}' )
          .where("status", isEqualTo: '1' )

          .snapshots()
          .listen((data) {
        listForDetail.clear();
        data.documents.forEach((f) {
          if ((f.data['classno']==_selectClass.Name||'select Class'==_selectClass.Name)){
            listForDetail.add(DetailsModel(id: f.data['id'],
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
                mobile: f.data['mobile'],
                institute: f.data['institute'],
                classno: f.data['classno'],
                feedback: f.data['feedback'],
                documentId: f.documentID,
                feeColor:  Color(0xFF00b300) as Color ,
                feeTest: 'Paid',
                feesStatus: f.data['feesStatus'],
                status: f.data['status']));

          }
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


  void changedDropDownItemClass(ClassModel selectedFruit) {
    setState(() {
      _selectClass = selectedFruit;
    });

    getDataDetails();

  }
/*
  void foo() {
    if (!mounted) return;
    setState(() {
        isLoading = false;
      });
  }
*/

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
              //  new Text('Class',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0),textAlign: TextAlign.start,),
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
                    return new GestureDetector(
                      child: Container(
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
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 0.0, 0.0, 0.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              listForDetail[index].fname,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 2.0, 0.0, 7.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              listForDetail[index].mobile,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black87,
                                                  fontWeight:
                                                  FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FeedbackStatus(name : name,title : '${listForDetail[index].fname}',id :'${listForDetail[index].documentId }')));
                      },
                    );
                  }),

            ],
          ),
        ),
      ),
    );
  }
}