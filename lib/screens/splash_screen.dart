

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/helpers/methods.dart';
import 'package:qbsdonation/models/model.dart';
import 'package:qbsdonation/screens/menu_screen.dart';
import 'package:qbsdonation/screens/register_screen.dart';
import 'package:qbsdonation/screens/walkthrough_screen.dart';

class splash_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _splash_screen();
  }

}

class _splash_screen extends State<splash_screen>{
  late user_profil profil;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: Center(
       child: Image(
        image: AssetImage('assets/images/dafq.png'),
        height: 250,
          width: 250,))
   );
  }


  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      FirebaseAuth.instance
          .authStateChanges()
          .listen((user) {
        if (user == null) {

         goreplace(context, walkthrough_screen());
        } else {
          goreplace(context,menu_screen(
           profil: profil
          ));
        }
      });
    });

  }

  
}