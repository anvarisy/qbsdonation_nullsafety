

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/models/dafq.dart';

class menu_screen extends StatefulWidget{

  user_profil profil;

  menu_screen({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _menu_screen();
  }

}

class _menu_screen extends State<menu_screen>{
  var currentIndex = 0;
  var currentIndexPage = 0;
  var appbarTitle = 'Home';

  final _drawerCollection = [
    {'index': 0, 'title': 'Home', 'icon': Icons.home},
    {'index': 1, 'title': 'About', 'icon': Icons.business},
    /*{'index': 2, 'title': 'Ajukan Misi', 'icon': Icons.add},*/
    {'index': 2, 'title': 'Article', 'icon': Icons.print},
    {'index': 3, 'title': 'Profile', 'icon': Icons.person_outline},
    //{'index': 5, 'title': 'STFQ Product', 'icon': Icons.print},
    //{'index': 6, 'title': 'Our STFQ', 'icon': Icons.person_outline},
  ];

  get _drawerHeader => UserAccountsDrawerHeader(
    accountName: Text(widget.profil.name),
    accountEmail: Text(widget.profil.email),
    currentAccountPicture: CircleAvatar(
      child: Image.asset(
        'assets/images/icon.png',
        fit: BoxFit.cover,
        height: 60.0,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:
        Center(
          child: Text(widget.profil.email),
        )
    );
  }

}