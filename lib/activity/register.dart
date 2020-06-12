import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/activity/login.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/CustomProgressDialog.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/model/class_model.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/service/auth.dart';
import 'package:data_application/service/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'home.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  AuthService _auth= AuthService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String userId;
  String reply;
  TextEditingController passwordMatch = new TextEditingController();
  List classlist =  ClassModel.getCompanies();
  List<Institute> citylist = List();
  List<Institute> statelist = List();
  List<Institute> countrylist = List();
  List<Institute> list = List();

  var isLoading = false;
  List<DropdownMenuItem<ClassModel>> _dropDownMenuItemsClass;
  List<DropdownMenuItem<Institute>> _dropDownMenuItemsCity;
  List<DropdownMenuItem<Institute>> _dropDownMenuItemsState;
  List<DropdownMenuItem<Institute>> _dropDownMenuItemsCountry;
  List<DropdownMenuItem<Institute>> _dropDownMenuItems;
  Institute _selectedFruit,_selectCountry,_selectState,_selectCity;
  ClassModel _selectClass;

  SharedPreferences prefs;

  String _first_name="",
      _last_name="",
      _mobile="",
      _email="",
      _password="",
      country="",
      _confirnm_password="",
      _city="",
      address1="",
      address2="",
      fcm_token="",
      pincode="";
  var map, ownerMap;
  bool _isLoading = false;

  void _submit()  {

    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      // fetchData();
      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      if(_selectCountry.name=="select Country"){

        Fluttertoast.showToast(
            msg:
            Constants.COUNTRY_VALIDATION,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }else  if(_selectState.name=="select State"){

        Fluttertoast.showToast(
            msg:
            Constants.STATE_VALIDATION,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }else  if(_selectCity.name=="select City"){

        Fluttertoast.showToast(
            msg:
            Constants.CITY_VALIDATION,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }else  if(_selectedFruit.name=="select Institute"){

        Fluttertoast.showToast(
            msg:
            Constants.INSTITUTE_VALIDATION,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }else  if(_selectClass.Name=="select Class"){

        Fluttertoast.showToast(
            msg:
            Constants.CLASS_VALIDATION,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }else {
        _performLogin();

      }
    }
  }
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fcm_token = prefs.getString(UserPreferences.USER_FCM);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getSharedPreferences();
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


  List<DropdownMenuItem<Institute>> buildAndGetDropDownMenuItemsCity(List institute) {
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


  List<DropdownMenuItem<Institute>> buildAndGetDropDownMenuItemsState(List institute) {
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


  List<DropdownMenuItem<Institute>> buildAndGetDropDownMenuItemsCountry(List institute) {
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

  void changedDropDownItem(Institute selectedFruit) {
    setState(() {
      _selectedFruit = selectedFruit;
    });
  }


  void changedDropDownItemClass(ClassModel selectedFruit) {
    setState(() {
      _selectClass = selectedFruit;
    });
  }


  void changedDropDownItemCity(Institute selectedFruit) {
    setState(() {
      _selectCity = selectedFruit;
    });
  }


  void changedDropDownItemState(Institute selectedFruit) {
    setState(() {
      _selectState = selectedFruit;
      if(_selectState.name=="select State"){
        citylist.clear();
        citylist.add( Institute(id: '1',name: 'select City',city: '',state:'',country:'',pincode:'' ,address:'' ));
        _dropDownMenuItemsCity = buildAndGetDropDownMenuItemsCity(citylist);
        _selectCity = _dropDownMenuItemsCity[0].value;
      }else {
        city(_selectState.documentId);
      }
    });

  }


  void changedDropDownItemCountry(Institute selectedFruit) {
    setState(() {
      _selectCountry = selectedFruit;
    });
  }


  void getData() {
    try{
    setState(() {
      isLoading = true;
    });

    list.add( Institute(id: '1',name: 'select Institute',city: '',state:'',country:'',pincode:'' ,address:'' ));
    countrylist.add( Institute(id: '1',name: 'select Country',city: '',state:'',country:'',pincode:'' ,address:'' ));
    countrylist.add( Institute(id: '2',name: 'India',city: '',state:'',country:'',pincode:'' ,address:'' ));
    statelist.add( Institute(id: '1',name: 'select State',city: '',state:'',country:'',pincode:'' ,address:'' ));
    citylist.add( Institute(id: '1',name: 'select City',city: '',state:'',country:'',pincode:'' ,address:'' ));

    Firestore.instance
          .collection(Constants.INSTITUTE_TABLE)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) =>
           list.add( Institute(id: f.data['id'].toString(),name: f.data['name'].toString(),city: f.data['city'].toString(),state:f.data['state'].toString(),country:f.data['country'].toString(),pincode:f.data['pincode'] .toString(),address:f.data['address'].toString() )));

            _dropDownMenuItems = buildAndGetDropDownMenuItems(list);
            _dropDownMenuItemsCountry  = buildAndGetDropDownMenuItemsCountry(countrylist);
            _dropDownMenuItemsCity = buildAndGetDropDownMenuItemsCity(citylist);
            _dropDownMenuItemsClass = buildAndGetDropDownMenuItemsClass(classlist);

            _selectedFruit = _dropDownMenuItems[0].value;
            _selectClass = _dropDownMenuItemsClass[0].value;
            _selectCity = _dropDownMenuItemsCity[0].value;
            _selectCountry = _dropDownMenuItemsCountry[0].value;
        Firestore.instance
            .collection(Constants.LOCATION_TABLE)
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((s) =>
              statelist.add( Institute(documentId: s.documentID.toString(),id: '2',name: s.data['state'].toString(),city: '',state:'',country:'',pincode:'' ,address:'' )));
          _dropDownMenuItemsState = buildAndGetDropDownMenuItemsState(statelist);
          _selectState = _dropDownMenuItemsState[0].value;

          setState(() {
            isLoading = false;

          });
        });

      });



    }catch(e){
      print(e.toString());
    }
  }
void city(String documnetId){
  setState(() {
    isLoading = true;
  });    citylist.clear();
      citylist.add( Institute(id: '1',name: 'select City',city: '',state:'',country:'',pincode:'' ,address:'' ));

    Firestore.instance
      .collection('/location/${documnetId}/city')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((c) =>
        citylist.add( Institute(documentId:c.documentID.toString(),id: '2',name: c.data['city'].toString(),city: '',state:'',country:'',pincode:'' ,address:'' )));
    _dropDownMenuItemsCity = buildAndGetDropDownMenuItemsCity(citylist);
    _selectCity = _dropDownMenuItemsCity[0].value;
    setState(() {
      isLoading = false;

    });

    });
}
  void _performLogin() async {
try{
    CustomProgressLoader.showLoader(context);

    dynamic result = await _auth.registerWithEmailAndPassword(_first_name , _last_name,_email, _password,_mobile,address1,address2,_selectCity.name,_selectState.name,_selectCountry.name,pincode,_selectedFruit.name,_selectClass.Name,fcm_token) ;
    if(result== null) {
      print("NOR DAATA ");
      CustomProgressLoader.cancelLoader(context);

      Fluttertoast.showToast(
          msg:
          Constants.USER_ALREADY,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{
      CustomProgressLoader.cancelLoader(context);

      Fluttertoast.showToast(
          msg:
          Constants.USER_REGISTER,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => Login()));

    }

}catch(e){
print(e.toString());
}
}

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    Constants.applicationContext =context;
    return  new WillPopScope(
        onWillPop: _onWillPop,
        child:new  Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new Login(),
          ));
        }),
        automaticallyImplyLeading: false,

        title: Text(Constants.REGISTRATION_PAGE),
        backgroundColor: Colors.green,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: new SingleChildScrollView(
               child: new Column(
            //padding: EdgeInsets.all(25.0),
            children: <Widget>[
              new Container(
                  //      child: new Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcxx9ypeeGCqaz5GJXY6gMoGIFlfeqKRQvXltqFA66_mSNPHBkPg'),
                  ),
              //   new Image.asset('images/logo.png'),
              new Row(children: <Widget>[
                new Expanded(
                  child:Container(
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: Constants.FIRST_NAME_HINT),
                    validator: (valueName) =>
                        valueName.length <= 0 ? Constants.FIRST_NAME_VALIDATION : null,
                    //   !val.contains('@') ? 'Not a valid email.' : null,
                    onSaved: (valueName) => _first_name = valueName,
                    keyboardType: TextInputType.text,
                    initialValue: _first_name,


                  ),
                    margin: EdgeInsets.only(right:8.0),
                ),
                ),
                new Expanded(

                  child:Container(
                    child: TextFormField(

                    decoration: InputDecoration(labelText: Constants.LAST_NAME_HINT),

                    validator: (valueName) =>
                        valueName.length <= 0 ? Constants.LAST_NAME_VALIDATION : null,
                    //   !val.contains('@') ? 'Not a valid email.' : null,
                    onSaved: (valueName) => _last_name = valueName,
                    keyboardType: TextInputType.text,
                  ),
                 //   margin: EdgeInsets.only(left:8.0),
                ),
                ),
              ]),

              TextFormField(
                decoration: InputDecoration(labelText: Constants.EMAIL_HINT),
                validator: (valueEmail) =>
                    //valueEmail.length <= 0 ? 'Enter Your Email' : null,
                    !valueEmail.contains('@') ? Constants.EMAIL_VALIDATION : null,
                onSaved: (valueEmail) => _email = valueEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: Constants.PASSWORD_HINT),
                validator: (valuePassword) =>
                    valuePassword.length < 6 ? Constants.PASSWORD_VALIDATION : null,
                onSaved: (valuePassword) => _password = valuePassword,
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passwordMatch,

              ),
              TextFormField(
                decoration: InputDecoration(labelText: Constants.CONFIRM_PASSWORD_HINT),
                validator: (valueConfirnmPassword) =>
                valueConfirnmPassword.trim() !=   passwordMatch.text.toString().trim()? Constants.CONFIRM_PASSWORD_VALIDATION :null,
                onSaved: (valueConfirnmPassword) => _confirnm_password = valueConfirnmPassword,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: Constants.MOBILE_HINT),
               // initialValue: "97131822",
                validator: (valueMobile) =>
                    valueMobile.length < 8 ? Constants.MOBILE_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueMobile) => _mobile = valueMobile,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
  TextFormField(
                decoration: InputDecoration(labelText: Constants.ADDRESS1_HINT),
                validator: (valueAddress) =>
                valueAddress.length <= 0 ? Constants.ADDRESS1_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress) => address1 = valueAddress,
                keyboardType: TextInputType.text,
              ),


  TextFormField(
                decoration: InputDecoration(labelText: Constants.ADDRESS2_HINT),
                validator: (valueAddress2) =>
                valueAddress2.length <= 0 ? Constants.ADDRESS2_VALIDATION : null,
                //   !val.contains('@') ? 'Not a valid email.' : null,
                onSaved: (valueAddress2) => address2 = valueAddress2,
                keyboardType: TextInputType.text,
              ),

              isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : new Container(
                child:   new Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,

               children: <Widget>[

                 new Expanded(child:   new Container(
                   padding:EdgeInsets.fromLTRB(0.0,5.0,5.0,5.0),
                   child: new SizedBox(
                       width: double.infinity,
                       //  child: new Center(
                       child:  new DropdownButton(
                         value: _selectCountry,
                         items: _dropDownMenuItemsCountry,
                         onChanged: changedDropDownItemCountry,
                       )
                     // ),
                   ),
                   // margin: EdgeInsets.only(left: 15.0),
                 ),
                 ),
                 new Expanded(child:   new Container(
                   padding:EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
                   child: new SizedBox(
                       width: double.infinity,
                       //  child: new Center(
                       child:  new DropdownButton(
                         value: _selectState,
                         items: _dropDownMenuItemsState,
                         onChanged: changedDropDownItemState,
                       )
                     // ),
                   ),
                   // margin: EdgeInsets.only(left: 15.0),
                 ),
                 ),
               ],
             ),
              ), isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : new Container(
                child:

                new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: <Widget>[

                  new Expanded(child:   new Container(
                    padding:EdgeInsets.fromLTRB(0.0,5.0,5.0,5.0),
                    child: new SizedBox(
                        width: double.infinity,
                        //  child: new Center(
                        child:  new DropdownButton(
                          value: _selectCity,
                          items: _dropDownMenuItemsCity,
                          onChanged: changedDropDownItemCity,
                        )
                      // ),
                    ),
                    // margin: EdgeInsets.only(left: 15.0),
                  ),
                  ),

                  new Expanded(child:   new Container(
                    padding:EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
                    child:
                    TextFormField(
                      decoration: InputDecoration(labelText: Constants.PINCODE_HINT),
                      validator: (valuePincode) =>
                      valuePincode.length < 5 ? Constants.PINCODE_VALIDATION : null,
                      //   !val.contains('@') ? 'Not a valid email.' : null,
                      onSaved: (valuePincode) => pincode = valuePincode,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    // margin: EdgeInsets.only(left: 15.0),
                  ),
                  ),
                ],
              ),
              ),
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
                //padding:EdgeInsets.all(12.0),
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

              // ),
              new Container(
                  child: new SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: _submit,
                      textColor: Colors.white,
                      child: new Text(Constants.REGISTER_BUTTON_HINT),
                      color: Colors.green,
                      padding: new EdgeInsets.all(15.0),
                    ),
                  ),
                  margin: new EdgeInsets.all(15.0)),
            ],
          ),
        ),
        // ),
      ),
      ),
      ),
    );
  }
}
