

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:qbsdonation/helpers/methods.dart';
import 'package:qbsdonation/helpers/widgets.dart';
import 'package:qbsdonation/models/colors.dart';
import 'package:qbsdonation/models/font_sizes.dart';
import 'package:qbsdonation/models/model.dart';
import 'package:http/http.dart' as http;
import 'package:qbsdonation/screens/menu_screen.dart';
import 'login_screen.dart';

class register_screen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _register_screen();
  }

}

class _register_screen extends State<register_screen>{
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode registerFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email= TextEditingController();
  bool _autoValidate = false;
  bool passwordVisible = true;
  user_profil profil = user_profil();
  // bool isLoading = false;
  bool isRemember = false;


  @override
  void initState() {
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 70.0;
  }

  @override
  Widget build(BuildContext context) {

    EasyLoadingIndicatorType indicatorType;
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
            color: Colors.lightBlue[50]),
        child:  SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: boxDecoration(
                        radius: 8,
                        showShadow: true,
                        bgColor: Colors.white),
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: themeLogo(),),
                        Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                  child: TextFormField(
                                      decoration: textDecoration(
                                        hint: 'Full Name',
                                        prefixIcon: Icons.person_outline,
                                        isPassword: false,
                                      ),
                                      style: textStyle(),
                                      focusNode: nameFocus,
                                      controller: name,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        return value!.isEmpty ? "Required" : null;
                                      }),),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                  child: TextFormField(
                                      decoration: textDecoration(
                                        hint: 'Email',
                                        prefixIcon: Icons.mail,
                                        isPassword: false,
                                      ),
                                      style: textStyle(),
                                      controller: email,
                                      focusNode: emailFocus,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        return value!.isEmpty ? "Required" : null;
                                      })),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                  child: TextFormField(
                                      decoration: textDecoration(
                                        hint: 'Mobile',
                                        prefixIcon: Icons.phone_iphone,
                                        isPassword: false,
                                      ),
                                      style: textStyle(),
                                      focusNode: phoneNumberFocus,
                                      controller: phone,
                                      maxLength: 12,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        return value!.isEmpty ? "Required" : null;
                                      })),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                    child: TextFormField(
                                      decoration: passDecoration(
                                        hint: 'Password',
                                        prefixIcon: Icons.lock_outline,
                                        isPassword: true,
                                        suffixIcon: passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        suffixIconSelector: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                      ),
                                      obscureText: passwordVisible,
                                      controller: password,
                                      validator: (value) {
                                        return value!.isEmpty ? "Required" : null;
                                      },
                                      focusNode: passwordFocus,
                                      textInputAction: TextInputAction.done,
                                    )),
                              ]))),
                        Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child:SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                              focusNode: registerFocus,
                              padding: EdgeInsets.only(
                                  top: 16,
                                  bottom: 16),
                              child: text("Register",
                                  textColor: Colors.white, fontFamily: fontMedium),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(8)),
                              color: p_12,
                              onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (_formKey.currentState!.validate()){
                              EasyLoading.show();
                              resgit(email.text).then((value) => {
                               if (value){
                                 if(EasyLoading.isShow) EasyLoading.dismiss(),
                                  Flushbar(
                                  title: "Error",
                                  message: "Email telah terdaftar",
                                  duration: Duration(seconds: 2),
                                  ).show(context)
                                }});
                                }
                              },),),),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.fromLTRB(spacing_control, 0, 0, 0),
                                  child: InkWell(
                                    child: text("Have an account?", fontSize: textSizeMedium),
                                    onTap: (){
                                        goreplace(context, login_screen());
                                    },
                                  ),)
                              ],))
                      ],
                    ),
                  ),
                ),
              ),
              /* Container(
                height: 50,
                child: appBar(context, "Register"),
              )*/
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> resgit(String mail) async {
    String url = "https://admin.daf-q.id/get-json-auth";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        if (data[i]['email'] == mail) {
          return Future.value(true);
        }else {
          FirebaseAuth.instance
           .createUserWithEmailAndPassword(
              email: email.text,
              password: password.text)
           .then((currentUser) => FirebaseFirestore.instance.collection("User").doc(currentUser.user!.uid)
           .set({
            "uid": currentUser.user!.uid,
            "full_name": name.text,
            "phone": phone.text,
            "email": email.text,
          }).then((result) => {
            profil.uid = currentUser.user!.uid,
            profil.name = name.text,
            profil.mobile = phone.text,
            profil.email = email.text,
            if(EasyLoading.isShow) EasyLoading.dismiss(),
            name.clear(), email.clear(), phone.clear(), password.clear(),
            goreplace(context, menu_screen(profil: profil)),
          }).catchError((err) => {
            if(EasyLoading.isShow) EasyLoading.dismiss(),
            Flushbar(
            title: "Error",
            message: "Koneksi bermasalah",
            duration: Duration(seconds: 2)).show(context)
          })).catchError((err) => {
            print(err.toString())
          });
        }
      }
    }
    return false;
  }
}