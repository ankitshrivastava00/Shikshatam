import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
   String  id,title,description,classno,institute,user,type;
   String datetime;

 /*  '': '${_selectClass.Name}',
   '': '${USER_INSTITUTE}',
   '': '${Constants.APPLICATION_NAME}',
   '': emailController.text,
   '': 'All',
   '': '${Constants.STUDENT_PORTAL}',
   // 'datetime':new DateTime.now(),
   //  'datetime': '${DateTime.now().toUtc().millisecondsSinceEpoch}',
   'datetime': '${DateTime.now()}',*/
   NotificationModel({this.title,this.description,this.classno,this.institute,this.user,this.type,this.datetime});
 // NotificationModel({this.title,this.description});


}