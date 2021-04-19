import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/models/dafq.dart';

import 'menu_screen.dart';

class success_payout_screen extends StatefulWidget{
  @required final user_profil profil;

  success_payout_screen({ required this.profil});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _success_payout_screen();
  }

}

class _success_payout_screen extends State<success_payout_screen>{
Future<bool> Finish() {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>menu_screen(profil: widget.profil,)));
  return Future.value(true);
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return WillPopScope(
      onWillPop: Finish,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(height: 70),
              Center(
                child: Image.asset(
                  'assets/images/icon.png',
                  width: size.width * .30,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text("Success!",
                      style: TextStyle(
                          color: Color(0xff063057),
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(85, 20, 85, 20),
                  child: Text(
                      "Terima Kasih atas donasinya",
                      style: TextStyle(color: Color(0xff063057), fontSize: 14),
                      textAlign: TextAlign.center),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: SizedBox(
                      width: double.infinity,
                      child: blueButton("Go Home", () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>menu_screen(profil: widget.profil,)))
                      }))),
            ],
          ),
        ),
      ),
    );
  }
  MaterialButton blueButton(String label, Function() fun) {
    return MaterialButton(
      onPressed: fun,
      textColor: Colors.white,
      color: Color(0xfff063057),
      padding: const EdgeInsets.all(15.0),
      child: Text(label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}