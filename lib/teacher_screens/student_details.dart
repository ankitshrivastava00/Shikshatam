import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/details_model.dart';
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
  List<DetailsModel> listForDetail = List();
  var isLoading = false;
  ClassModel _selectClass;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsClass;
  List classlist =  ClassModel.getCompanies();
  final Firestore auth =Firestore.instance;

  List<Institute> list = List();
  List<DropdownMenuItem<Institute>> _dropDownMenuItems;
  Institute _selectedFruit;

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
          .snapshots()
          .listen((data) {
            listForDetail.clear();
        data.documents.forEach((f) {
          if ((f.data['classno']==_selectClass.Name||'select Class'==_selectClass.Name) && (f.data['institute']==_selectedFruit.name||'select Institute'==_selectedFruit.name)){
          if(f.data['feesStatus']=='1'){
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
                classno: f.data['classno'],
                feedback: f.data['feedback'],
                documentId: f.documentID,
                feeColor:  Color(0xFF00b300) as Color ,
                feeTest: 'Paid',
                feesStatus: f.data['feesStatus'],
                status: f.data['status']));
          }else{
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

  Future updateDataDetails(int index,String value) {

    try{
      auth.collection(Constants.USER_TABLE)
          .document(listForDetail[index].documentId)
          .updateData({'feesStatus': '${value}'});
      getDataDetails();

    } catch (e) {
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
      appBar: AppBar(
        //  leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
        /*  Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new StartScreen(),
          ));*/
        //   }),
        // automaticallyImplyLeading: false,

        title: Text("Details"),
        backgroundColor: Colors.green,
      ),
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
                  SizedBox(height: 20.0,),
                  new Container(
                    //padding:EdgeInsets.all(12.0),
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
                  ),
                  new Container(
                    child:
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
                                        'Name : ${listForDetail[index].fname} ${listForDetail[index].lname}',
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
                                          child: new Text('${listForDetail[index].classno} ',
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
                                              new InkWell(
                                                onTap: ()  {
                                                  if(listForDetail[index].feesStatus=="1"){
                                                    updateDataDetails(index,'0');
                                                    }else{
                                                    updateDataDetails(index,'1');
                                                }
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.all(
                                                      7.0),
                                                  alignment: Alignment.topRight,
                                                  child: Text('${listForDetail[index].feeTest}',
                                                    style: TextStyle(
                                                      backgroundColor: listForDetail[index].feeColor,
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
                    itemCount: listForDetail.length,
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