

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/models/dafq.dart';

class detail_screen extends StatefulWidget{
  mission m;
  user_profil profil;

  detail_screen({required this.m, required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _detail_screen();
  }

}

class _detail_screen extends State<detail_screen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:
      Center(),
    );
  }

}