import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/model/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentFeedback extends StatefulWidget {
  @override
  StudentFeedbackState createState() => StudentFeedbackState();
}

class StudentFeedbackState extends State<StudentFeedback> {
  String reply = "", status = "",name="",email="";
  String items = "true";
  List<UserData> lis = List();
  var isLoading = false;
  ClassModel _selectClass;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsClass;
  List classlist = ClassModel.getCompanies();

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
    getDataFeedback();

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
  void initState() {
    super.initState();
    getInstitute();
    _dropDownMenuItemsClass = buildAndGetDropDownMenuItemsClass(classlist);
    _selectClass = _dropDownMenuItemsClass[0].value;
    getDataFeedback();

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

  void getDataFeedback() {
    try{
      if (!mounted) return;
        setState(() {
          isLoading = true;
          lis.clear();
        });

      Firestore.instance
          .collection(Constants.USER_TABLE)
          .where("type", isEqualTo: Constants.STUDENT_PORTAL )
          .snapshots()
          .listen((data) {
        data.documents.forEach((f) {
          if ((f.data['classno']==_selectClass.Name||'select Class'==_selectClass.Name) && (f.data['institute']==_selectedFruit.name||'select Institute'==_selectedFruit.name)){
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

        }  );
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
    if (!mounted) return;

      setState(() {
      _selectClass = selectedFruit;
      getDataFeedback();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lis;
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

        title: Text("Feedback"),
        backgroundColor: Colors.green,
      ),
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
                                                /*if(lis[index].feestatus=="1"){
                                                    Fluttertoast.showToast(
                                                        msg: "Already Exists",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIos: 1,
                                                        backgroundColor: Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }else{

                                                  }
*/
                                              },
                                              child: new Container(
                                                margin: EdgeInsets.all(
                                                    5.0),
                                                alignment: Alignment.topRight,
                                                child: Text('${lis[index].feedback}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.bold),),
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