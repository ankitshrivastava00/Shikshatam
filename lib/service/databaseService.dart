import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_application/common/Constants.dart';
import 'package:data_application/model/institute.dart';
import 'package:data_application/model/user_data.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid});

//collection reference

  final CollectionReference userCollection = Firestore.instance.collection(Constants.USER_TABLE);
  final CollectionReference instituteCollection = Firestore.instance.collection(Constants.INSTITUTE_TABLE);
  final CollectionReference instituteNotification = Firestore.instance.collection(Constants.NOTIFICATION_TABLE);

  Future updateUserData(String fname ,String lname,String email,String mobile,String password,String city,
      String address1, String address2 ,String state,String country,
      String pincode,String institute,String classno,String fcm_token) async {
    return  await userCollection.document(uid).setData({
      'fname': fname,
      'lname': lname,
      'email': email,
      'mobile': mobile,
      'password': password,
      'city': city,
      'address1': address1,
      'address2': address2,
      'state': state,
      'pincode': pincode,
      'institute': institute,
      'classno': classno,
      'fcm_token': fcm_token,
      'type': Constants.STUDENT_PORTAL,
      'status': '0',
      'feesStatus': '0',
      'feedback': '',
    });
  }

  // add institue for admin
  Future insertInstitute(String name,String city,String state,String country,String pincode,String address) async {
    return  await instituteCollection.document().setData({
      'name': name,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'address': address,
    });
  }

// user list from snapshot

  List<UserData> userList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return UserData(
        fname: doc.data['fname'] ?? '',
        lname: doc.data['lname'] ?? '',
        email: doc.data['email'] ?? '',
        password: doc.data['password'] ?? '',
        city: doc.data['city'] ?? '',
        address1: doc.data['address1'] ?? '',
        address2: doc.data['address2'] ?? '',
        type: doc.data['type'] ?? '',
        state: doc.data['state'] ?? '',
        country: doc.data['country'] ?? '',
        pincode: doc.data['pincode'] ?? '',
        institute: doc.data['institute'] ?? '',
      );
    }).toList();
  }

// get institutes stream
  Stream<List<UserData>> get getUser{
    return instituteCollection.snapshots()
        .map(userList);
  }

// institute list from snapshot

  List<Institute> instituteList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Institute(
        name: doc.data['name'] ?? '',
        city: doc.data['city'] ?? '',
        address: doc.data['address'] ?? '',
        state: doc.data['state'] ?? '',
        country: doc.data['country'] ?? '',
        pincode: doc.data['pincode'] ?? '',
      );
    }).toList();
  }

// get institutes stream
  Stream<List<Institute>> get institutes{
    return instituteCollection.snapshots()
        .map(instituteList);
  }
}