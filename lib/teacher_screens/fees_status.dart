import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class FeesStatus extends StatefulWidget {
  FeesStatus({Key key, this.title,this.id,this.listForDetail}) : super(key: key);
  final String title,id;
 DetailsModel listForDetail;

  @override
  FeesStatusState createState() => new FeesStatusState();
}

class FeesStatusState extends State<FeesStatus> {
  FocusNode myFocusNode = FocusNode();
  String reply = "", status = "";
  List<String> _dropdownValues = List();
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsMonth;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsYear;

  List _dropdownmonth =  ClassModel.getMonth();
  List _dropdownYear =  ClassModel.getYears();

  ClassModel _currentlymonth,_currentlyYear;

   var isLoading = true,showData = true;
  final Firestore auth =Firestore.instance;
  String Status,FeesStatus,month,Fees;
  TextEditingController emailController = new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _dropDownMenuItemsMonth = buildAndGetDropDownMenuItemsMonth(_dropdownmonth);
    _currentlymonth = _dropDownMenuItemsMonth[0].value;

    _dropDownMenuItemsYear = buildAndGetDropDownMenuItemsYear(_dropdownYear);
    _currentlyYear = _dropDownMenuItemsYear[0].value;
  }

  List<DropdownMenuItem<ClassModel>> buildAndGetDropDownMenuItemsMonth(List month) {
    List<DropdownMenuItem<ClassModel>> items = new List();
    for (ClassModel i in month) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.Name),
        ),
      );
    }

    return items;
  }


  List<DropdownMenuItem<ClassModel>> buildAndGetDropDownMenuItemsYear(List month) {
    List<DropdownMenuItem<ClassModel>> items = new List();
    for (ClassModel i in month) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i.Name),
        ),
      );
    }

    return items;
  }


  void changedDropDownItemMonth(ClassModel selectedFruit) {
    setState(() {
      _currentlymonth = selectedFruit;
    });
  }
  void changedDropDownItemYear(ClassModel selectedFruit) {
    setState(() {
      _currentlyYear = selectedFruit;
    });
  }

  void insertFees(String DocumentId1 ,String Status1,String FeesStatus1,String month1,String Fees1,String monthyear,String year1) async {

    try{
    CustomProgressLoader.showLoader(Constants.applicationContext);
      auth
          .collection('${Constants.USER_TABLE}/${widget.id}${Constants.FEES_TABLE}').document('${DocumentId1}')
          .setData({
        'Status': Status1,
        'FeesStatus': FeesStatus1,
        'month': month1,
        'Fees': Fees1,
        'year': year1,
        'monthyear': monthyear,

      });
    CustomProgressLoader.cancelLoader(Constants.applicationContext);

    if (!mounted) return;
      setState(() {
        emailController.text='';

        isLoading = false;
        showData=true;
        Status=Status1;FeesStatus=FeesStatus1;month=month1;Fees=Fees1;
      });

    }catch(e){
      print(e.toString());
      CustomProgressLoader.cancelLoader(Constants.applicationContext);

    }
  }

  UpdateFees(String DocumentId1 ,String Status1,String FeesStatus1) async {

    try{
    CustomProgressLoader.showLoader(Constants.applicationContext);
      auth
          .collection('${Constants.USER_TABLE}/${widget.id}${Constants.FEES_TABLE}').document('${DocumentId1}')
          .updateData({
        'Status': Status1,
        'FeesStatus': FeesStatus1,


      });
    CustomProgressLoader.cancelLoader(Constants.applicationContext);

    if (!mounted) return;
      setState(() {
        emailController.text='';

        isLoading = false;
        showData=true;
        Status=Status1;FeesStatus=FeesStatus1;
      });

    }catch(e){
      print(e.toString());
      CustomProgressLoader.cancelLoader(Constants.applicationContext);

    }
  }


  void getDataDetails(String DocumentId) {

    try{
   //   CustomProgressLoader.showLoader(Constants.applicationContext);

      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      auth
          .collection('${Constants.USER_TABLE}/${widget.id}${Constants.FEES_TABLE}').document('${DocumentId}')
          .snapshots()
          .listen((data) {
        print('${data}');
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
            isLoading = true;
            showData = false;

          });
            }else {
               Status = data['Status'].toString();
               FeesStatus = data['FeesStatus'].toString();
               month = data['month'].toString();
               Fees = data['Fees'].toString();
              if (!mounted) return;
              setState(() {
                isLoading = false;
                showData = true;
              });
            }

      });

    }catch(e){
     // CustomProgressLoader.cancelLoader(Constants.applicationContext);

      print(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${widget.title}"),
        backgroundColor: Colors.green,
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new Container(
                  child:  new DropdownButton(

                    value: _currentlyYear,
                    items: _dropDownMenuItemsYear,
                    onChanged: changedDropDownItemYear,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child:  new DropdownButton(

                    value: _currentlymonth,
                    items: _dropDownMenuItemsMonth,
                    onChanged: changedDropDownItemMonth,
                  ),
                ),

              ],
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 0.0),
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  if ('Select Year'==_currentlyYear.Name){

                    Fluttertoast.showToast(
                        msg: 'Please Select Year',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);

                  }else if ('Select Month'==_currentlymonth.Name){

                    Fluttertoast.showToast(
                        msg: 'Please Select Month',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }else {
                    String document = '${_currentlyYear.Name}_${_currentlymonth.Name}';
                    getDataDetails(document);
                  }
                },
                child: Text(
                  "SEARCH",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            isLoading
                ? Center()
                :   Container(
                margin: EdgeInsets.all(2.0),
    child:
    Card(
    child: new Container(
    margin:
    EdgeInsets.fromLTRB(5.0, 7.0, 20.0, 0.0),
    child: new Column(
    children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  alignment: Alignment.topLeft,
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                    child: Text(
                      'Fees :',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                  child: Text(
                    'Rs ${Fees}/-',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ),

              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                  alignment: Alignment.topLeft,
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                    child: Text(
                      'Status : ',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                new GestureDetector(
                  child:
                new Container(
                  alignment: Alignment.topLeft,
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                    child: Text(
                      '${FeesStatus}',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.green),
                    ),
                  ),
                ),
                  onTap:
                  (){
                    if('${FeesStatus}'=='UnPaid'){
                      showDialog(
                        context: Constants.applicationContext,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text(
                              "Do you want to update this data?",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            // content: new Text("Alert Dialog body"),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text("Yes"),
                                onPressed: () {
                                  UpdateFees('${_currentlyYear.Name}_${_currentlymonth.Name}','1','Paid');
                                  Navigator.of(context).pop();

                                },
                              ),
                              new FlatButton(
                                child: new Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );

                    }else{
                      showDialog(
                        context: Constants.applicationContext,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text(
                              "Do you want to update this data?",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            // content: new Text("Alert Dialog body"),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text("Yes"),
                                onPressed: () {
                                  UpdateFees('${_currentlyYear.Name}_${_currentlymonth.Name}','0','UnPaid');
                                  Navigator.of(context).pop();

                                },
                              ),
                              new FlatButton(
                                child: new Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );

                    }

                  }
                ),
              ],
            ),


      ],
    ),
    ),
    ),
                ),
            showData
                ? Center()
                :   Container(
                margin: EdgeInsets.all(2.0),
    child: Card(
    child: new Container(
    margin:
    EdgeInsets.fromLTRB(5.0, 7.0, 20.0, 0.0),
    child: new Column(
    children: <Widget>[
      new Container(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: new TextField(
            controller: emailController,
            keyboardType: TextInputType.number,
            obscureText: false,
            textAlign: TextAlign.start,
            autocorrect: true,
            autofocus: false,
            enableSuggestions: false,
            focusNode: myFocusNode,
            decoration: new InputDecoration(labelText: "Enter Fees"),
          )),
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
           if (emailController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Enter Value",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else  {
             String docum= '${_currentlyYear.Name}_${_currentlymonth.Name}';
             String monthyear= '${_currentlyYear.Name}${_currentlymonth.i}';

insertFees('${docum}', '0', 'UnPaid', _currentlymonth.Name, emailController.text,monthyear,_currentlyYear.Name);


            }
          } catch (e) {

            CustomProgressLoader.cancelLoader(Constants.applicationContext);
          }
        },
        child: Text(
          "Add".toUpperCase(),
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    ],
    ),
    ),
    ), ),
      ],  ),
      ),
    );
  }
}