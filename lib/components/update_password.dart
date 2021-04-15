import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class update_password extends StatefulWidget {
  user_profil profil;

  update_password({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _update_password();
  }
}

class _update_password extends State<update_password> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool passwordVisibleold = false;
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  bool _autoValidate = false;
  FocusNode passwordFocusold = FocusNode();
  FocusNode passwordFocus1 = FocusNode();
  FocusNode passwordFocus2 = FocusNode();
  TextEditingController passwordold= new TextEditingController();
  TextEditingController password1= new TextEditingController();
  TextEditingController password2= new TextEditingController();

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                p_11.withOpacity(0.87),
                t11_GradientColor1.withOpacity(0.4),
              ],
            ),
          ),
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
                          Padding(padding: EdgeInsets.all(spacing_standard_new),child:  themeLogo(),),
                          Padding(padding: EdgeInsets.fromLTRB(spacing_standard_new, spacing_standard_new, spacing_standard_new, 0),
                            child:  Form(
                              key: _formKey,
                              autovalidate: _autoValidate,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, spacing_standard_new),
                                    child: formField(context, "Old Password",
                                      prefixIcon: Icons.lock_outline,
                                      isPassword: true,
                                      controller: passwordold,
                                      isPasswordVisible: passwordVisibleold,
                                      validator: (value) {
                                        return value!.isEmpty ? "Required" : null;},
                                      focusNode: passwordFocusold,
                                      onSaved: (String value) {},
                                      textInputAction: TextInputAction.done,
                                      suffixIconSelector: () {
                                        setState(() {
                                          passwordVisibleold = !passwordVisibleold;
                                        });
                                      },
                                      suffixIcon: passwordVisibleold
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                                //new password
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, spacing_standard_new),
                                    child: formField(context, "New Password",
                                     prefixIcon: Icons.lock_outline,
                                     isPassword: true,
                                     controller: password1,
                                     isPasswordVisible: passwordVisible1,
                                     validator: (value) {return value!.isEmpty ? "Required" : null;},
                                     focusNode: passwordFocus1,
                                     onSaved: (String value) {},
                                     textInputAction: TextInputAction.done,
                                     suffixIconSelector: () {
                                        setState(() {
                                          passwordVisible1 = !passwordVisible1;
                                        });
                                      },
                                      suffixIcon: passwordVisible1
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: formField(context, "Confirmasi Password",
                                    prefixIcon: Icons.lock_outline,
                                    isPassword: true,
                                    controller: password2,
                                    isPasswordVisible: passwordVisible2,
                                    validator: (value) {
                                      return value!.isEmpty ? "Required" : null;
                                    },
                                    focusNode: passwordFocus2,
                                    onSaved: (String value) {},
                                    textInputAction: TextInputAction.done,
                                    suffixIconSelector: () {
                                      setState(() {
                                        passwordVisible2 = !passwordVisible2;
                                      });
                                    },
                                    suffixIcon: passwordVisible2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),)

                              ],
                            ),
                          )),
                          Padding(padding: EdgeInsets.all(spacing_standard_new),
                            child: SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                  padding: EdgeInsets.only(
                                      top: spacing_standard_new,
                                      bottom: spacing_standard_new),
                                  child: text("Update",
                                      textColor: Colors.white,
                                      fontFamily: fontMedium),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                          spacing_standard)),
                                  color: p_12,
                                  onPressed: () => {
                                    if (_formKey.currentState!.validate()){
                                      EasyLoading.show(),
                                      if (password1.text == password2.text){update_pass()}
                                      else {
                                        Flushbar(title: "Perhatian",
                                          message: "Password tidak sama",
                                          duration: Duration(seconds: 2),
                                        ).show(context)
                                      }
                                    },
                                  }),
                            ),)
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: appBar(context, "Update"),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> update_pass() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = await FirebaseAuth.instance.currentUser!;
    auth.signInWithEmailAndPassword(email: widget.profil.email, password: passwordold.text).then((value) => {
      user.updatePassword(password1.text).then((value) => {
        if(EasyLoading.isShow){
          EasyLoading.dismiss()
        },
        Flushbar(title: "Success",
          message: "Password telah diupdate",
          duration: Duration(seconds: 2),
        ).show(context)
      }).catchError((onError){
        print(onError);
        if(EasyLoading.isShow){
          EasyLoading.dismiss();
        }
        Flushbar(
          title: "Error",
          message: 'Password Lemah',
          duration: Duration(seconds: 2),
        ).show(context);
      })
    }).catchError((onError){
      if(EasyLoading.isShow){
        EasyLoading.dismiss();
      }
      Flushbar(
        title: "Error",
        message: "Email & password tidak cocok",
        duration: Duration(seconds: 2),
      ).show(context);
    });
  }
}