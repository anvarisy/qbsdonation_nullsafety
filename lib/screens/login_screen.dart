

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qbsdonation/helpers/methods.dart';
import 'package:qbsdonation/helpers/widgets.dart';
import 'package:qbsdonation/models/colors.dart';
import 'package:qbsdonation/models/font_sizes.dart';
import 'package:qbsdonation/models/model.dart';
import 'package:qbsdonation/screens/menu_screen.dart';
import 'package:qbsdonation/screens/register_screen.dart';

class login_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _login_screen();
  }

}

class _login_screen extends State<login_screen>{
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _autoValidate = false;
  bool passwordVisible = true;
  bool isLoading = false;
  bool isRemember = false;
  @override
  Widget build(BuildContext context) {
    user_profil profil = user_profil();
    // TODO: implement build
   return Scaffold(
     body: Center(
       child: Container(
         // width: MediaQuery.of(context).size.width,
         // height: MediaQuery.of(context).size.height,
         decoration: backgroundDecor(),
         child: SafeArea(
           child: Stack(
             children: <Widget>[
               Center(
                 child: SingleChildScrollView(
                   child: Container(
                     decoration: boxDecoration(
                         radius: spacing_standard,
                         showShadow: true,
                         bgColor: Colors.white),
                     margin: EdgeInsets.all(spacing_standard_new),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[

                         Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                           child: themeLogo(),),
                         Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                             child:  Form(
                               key: _formKey,
                               autovalidate: _autoValidate,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, spacing_standard_new),
                                    child:TextFormField(
                                      decoration: textDecoration(hint: 'Email', prefixIcon: Icons.email, isPassword: false),
                                      focusNode: emailFocus,
                                      controller: email,
                                      validator:  (value) {
                                        return value!.isEmpty
                                            ? "Email Required"
                                            : null;
                                      },
                                      textInputAction: TextInputAction.next,
                                    ),
                                   ),
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
                                 ],
                               ),
                             )),
                         Row(
                           mainAxisAlignment:
                           MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             Opacity(
                               opacity: 0.0,
                               child:
                                   Padding(padding: EdgeInsets.fromLTRB(18, 0, spacing_standard, 0),
                                    child: InkWell(
                                      onTap: ()=>{
                                      setState(() {
                                        isRemember = !isRemember;})
                                      },
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: boxDecoration(
                                        bgColor: isRemember ? t12_primary_color : Colors.transparent,
                                        color: isRemember ? t12_primary_color : t12_text_secondary),
                                        child: Visibility(
                                            child: Icon(
                                             Icons.done,
                                             color: Colors.white,
                                             size: 14),
                                            visible: isRemember),
                                      ),
                                    ))),
                             Opacity(
                                 opacity: 0.0,
                                 // child: Expanded(
                                 child:text("Remember",
                                     fontSize: textSizeMedium,
                                     maxLine: 2)),
                             Padding(padding: EdgeInsets.all(spacing_standard_new),
                                 child:InkWell(
                                   child: text("Forgot password", fontFamily: fontMedium, fontSize: textSizeMedium, textColor: p_12),
                                   onTap: ()=>{
                                   if (email.text.isEmpty) {
                                   Flushbar(
                                   title: 'Perhatian',
                                   message: 'Isi Form Email',
                                   duration: Duration(seconds: 3),).show(context)
                                   }else{
                                     FirebaseAuth.instance.sendPasswordResetEmail(
                                     email: email.text),
                                     Flushbar(
                                       title: 'Perhatian',
                                       message: 'Silakan periksa email anda',
                                       duration: Duration(seconds: 3),).show(context)}
                                   },
                                 )
                             )]
                             ),
                         Padding(padding: EdgeInsets.all(spacing_standard_new),
                              child: SizedBox(
                                width: double.infinity,
                                child: MaterialButton(
                                    padding: EdgeInsets.only(
                                        top: spacing_standard_new,
                                        bottom: spacing_standard_new),
                                    child: text("Login",
                                        textColor: Colors.white,
                                        fontFamily: fontMedium),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            spacing_standard)),
                                    color: p_12,
                                    onPressed: () => {
                                      FocusScope.of(context).requestFocus(FocusNode()),
                                      if (_formKey.currentState!.validate()){
                                          EasyLoading.show(),
                                          FirebaseAuth.instance.signInWithEmailAndPassword(
                                              email: email.text,
                                              password: password.text)
                                              .then((currentUser) => {
                                            FirebaseFirestore.instance.collection("User").doc(currentUser.user!.uid).get()
                                             .then((DocumentSnapshot result) => {
                                             profil.uid = currentUser.user!.uid,
                                             profil.name = result["full_name"],
                                             profil.mobile = result['phone'],
                                             profil.email = result['email'],
                                             EasyLoading.dismiss(),
                                             goreplace(context, menu_screen(profil: profil))
                                            }).catchError((err) => {
                                              if(EasyLoading.isShow){
                                                EasyLoading.dismiss()
                                              },
                                              EasyLoading.show(),
                                                })
                                          }).catchError((err) {
                                            if(EasyLoading.isShow){
                                              EasyLoading.dismiss();
                                            }
                                            Flushbar(
                                              title: 'Perhatian',
                                              message: 'Email & Password tidak sesuai !',
                                              duration: Duration(seconds: 3),).show(context);
                                          })
                                        },
                                    }),
                              ),),
                         Padding(padding: EdgeInsets.fromLTRB(spacing_control, 0, 0, 0),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    text("Do not have an account? ", fontSize: textSizeMedium),
                                    text("Register",
                                        fontSize: textSizeMedium,
                                        textColor: p_12,
                                        fontFamily: fontMedium),
                                  ],),
                                onTap: ()=>{
                                  gopush(context, register_screen())
                                },
                              ),)],),
                     ),
                   ),
                 ),]
               ),
           ),
         ),
       ),);
  }

}