import 'package:data_application/common/Constants.dart';
import 'package:data_application/common/UserPreferences.dart';
import 'package:data_application/teacher_screens/dashboard.dart';
import 'package:data_application/teacher_screens/logout.dart';
import 'package:data_application/teacher_screens/navdrawer.dart';
import 'package:data_application/teacher_screens/student_details.dart';
import 'package:data_application/teacher_screens/student_feedback.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TeacherHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,

        title: Text('${Constants.APPLICATION_NAME}'),
      ),
      body: DashboardList()

    );
  }
}



