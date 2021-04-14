import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qbsdonation/screens/company_screen.dart';
import 'package:qbsdonation/screens/dashboard_screen.dart';
import 'package:qbsdonation/screens/login_screen.dart';
import 'package:qbsdonation/screens/menu_screen.dart';
import 'package:qbsdonation/screens/register_screen.dart';
import 'package:qbsdonation/screens/splash_screen.dart';
import 'package:qbsdonation/screens/walkthrough_screen.dart';

import 'helpers/widgets.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAFQ APP',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: company_screen(),
        builder: EasyLoading.init()
    );
  }

}

