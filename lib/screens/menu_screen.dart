import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/com.stfqmarket/main.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/screens/article_screen.dart';
//import 'package:qbsdonation/screens/join_screen.dart';
import 'package:qbsdonation/screens/login_screen.dart';
import 'package:qbsdonation/screens/profil_screen.dart';
//import 'package:qbsdonation/screens/profile_screen.dart';
//import 'package:qbsdonation/utils/bottom_menu.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:qbsdonation/com.stfqmarket/main.dart';

//import 'article_screen.dart';
import 'company_screen.dart';
import 'dashboard_screen.dart';
import 'search_screen.dart';

class menu_screen extends StatefulWidget {
  final user_profil profil;

  menu_screen({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return menu();
  }
}

class menu extends State<menu_screen> {
  var currentIndex = 0;
  var currentIndexPage = 0;
  var appbarTitle = 'Home';

  final _drawerCollection = [
    {'index': 0, 'title': 'Home', 'icon': Icons.home},
    {'index': 1, 'title': 'About', 'icon': Icons.business},
    /*{'index': 2, 'title': 'Ajukan Misi', 'icon': Icons.add},*/
    {'index': 2, 'title': 'Article', 'ico n': Icons.print},
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
    final drawerItems = ListView(
      children: [
        _drawerHeader,
        for (final item in _drawerCollection) ListTile(
          title: Text(item['title'] as String),
          leading: Icon(item['icon'] as IconData),
          onTap: () {
            changePage(item['index'] as int);
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        ListTile(
          title: Text('STFQ Market'),
          leading: Icon(Icons.shopping_cart),
          onTap: () {
            changePage(_drawerCollection.length);
            Navigator.pop(context);
          },
        ),
      ],
    );

    final list_screens = [
      dashboard_screen(profil: widget.profil,),
      company_screen(),
     /* join_screen(profil: widget.profil,),*/
      article_screen(),
      profil_screen(u_profil: widget.profil,),
      // stfq market
      STFQMarketMainPage(widget.profil),
    ];

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appbarTitle),
          actions: [
            if (currentIndex == 0) IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>search_screen(profil: widget.profil)));
              },
            ),
            if(currentIndex==3) IconButton(
              icon: Icon(Icons.logout),
              onPressed: (){
                _signOut();
              },
            )
          ],
        ),
        body: list_screens[currentIndex],
        drawer: Drawer(child: drawerItems),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) =>CustomDialogExit(),
    ) ?? false;
  }

  void changePage(int index) {
    String appbarTitle;
    if (index == _drawerCollection.length) appbarTitle = 'Market';
    else appbarTitle = _drawerCollection[index]['title'] as String;

    setState(() {
      currentIndex = index;
      this.appbarTitle = appbarTitle;
    });
  }

 /* _saveData(var u, var n, var e, var m) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    var name = prefs.getString('name');
    var email = prefs.getString('email');
    var mobile = prefs.getString('mobile');
   if(uid==null|| uid==""){
     prefs.setString('uid',u );
   }
    if(name==null|| name==""){
      await prefs.setString('name',n );
    }
    if(uid==null|| uid==""){
      await prefs.setString('uid',u );
    }
    if(email==null|| email==""){
      await prefs.setString('email',e);
    }
    if(mobile==null|| mobile==""){
      await prefs.setString('mobile',m);
    }

  }*/
  Future <login_screen> _signOut()  async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => login_screen()));
    return new login_screen();
  }


}

class CustomDialogExit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}


dialogContent(BuildContext context) {
  return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          text("Apakah anda yakin ingin keluar ?", fontSize: textSizeLargeMedium, maxLine: 2, isCentered: true, textColor: t4_textColorPrimary, fontFamily: fontSemibold),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              T4Button(textContent: 'Yes',onPressed: ()=>{exit(0)},),
              SizedBox(
                width: 24,
              ),
              T4Button(
                textContent: 'Cancel',
                onPressed: ()=>{
                  Navigator.of(context).pop(false)
                },
                isStroked: true,
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ));


}

