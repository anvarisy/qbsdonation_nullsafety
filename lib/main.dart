import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qbsdonation/screens/splash_screen.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _MyApp();
  }

}

class _MyApp extends State<MyApp>{

 
  
  @override
  Widget build(BuildContext context) {
 /*final router = Router(routerDelegate: routerDelegate)*/
    // TODO: implement build
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
        home: splash_screen(),
        builder: EasyLoading.init()
    );
  }

/*  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print("--------------------"+initialLink+"--------------------------------");
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }*/
}

