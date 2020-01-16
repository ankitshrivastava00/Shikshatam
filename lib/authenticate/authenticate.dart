import 'package:data_application/common/Constants.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget{
  String name;
  Authenticate(this.name);
  @override
  _AuthenticateState createState() => _AuthenticateState();

}
class _AuthenticateState extends  State<Authenticate>{
  @override
  Widget build(BuildContext context) {
    Constants.applicationContext=context;
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,

        title: Text('Notification'),
        backgroundColor: Colors.green,
      ),
      body:

      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('title : ${widget.name}'),

            ],
          )
      ),
    );
}
}