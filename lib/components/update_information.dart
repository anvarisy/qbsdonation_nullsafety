import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class update_information extends StatefulWidget{
  final user_profil profil;

  update_information({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return update_state();
  }

}

class update_state extends State<update_information>{
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  TextEditingController phone = new TextEditingController();
  TextEditingController name= new TextEditingController();
  TextEditingController email= new TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    phone.text = widget.profil.mobile;
    name.text = widget.profil.name;
    email.text = widget.profil.email;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient:  LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                p_11.withOpacity(0.87),
                t11_GradientColor1.withOpacity(0.4),

              ],
            ),
          ),
          child:  SafeArea(
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
                          Padding(padding: EdgeInsets.all(spacing_standard_new), child: themeLogo(),),
                         Padding(padding: EdgeInsets.fromLTRB(spacing_standard_new, spacing_standard_new, spacing_standard_new, 0),
                           child:  Form(
                             key: _formKey,
                             autovalidate: _autoValidate,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, spacing_standard_new),
                                   child: formField(context, "Your Name",
                                       prefixIcon: Icons.person_outline,
                                       focusNode: nameFocus,
                                       controller: name,

                                       textInputAction: TextInputAction.next,
                                       validator: (value) {
                                         return value!.isEmpty ? "Required" : null;
                                       },
                                       nextFocus: emailFocus,
                                       onSaved: (String value) {
                                         setState(() {});
                                       }),),
                                 Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, spacing_standard_new),
                                   child: formField(context, "Your Email",
                                       isReadOnly: true,
                                       prefixIcon: Icons.email,
                                       controller: email,
                                       isEnabled: false,
                                       focusNode: emailFocus,
                                       textInputAction: TextInputAction.next,
                                       validator: (value) {
                                         return value!.isEmpty ? "Required" : null;
                                       },
                                       nextFocus: phoneNumberFocus,
                                       onSaved: (String value) {
                                         setState(() {});
                                       }),
                                 ),
                                 Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, spacing_standard_new),
                                   child: formField(context, "Phone Number",
                                       prefixIcon: Icons.phone_iphone,
                                       focusNode: phoneNumberFocus,
                                       controller: phone,
                                       maxLength: 12,
                                       textInputAction: TextInputAction.next,
                                       keyboardType: TextInputType.number,
                                       validator: (value) {
                                         return value!.isEmpty ? "Required" : null;
                                       },
                                       onSaved: (String value) {
                                         setState(() {});
                                       }),),

                               ],
                             ),
                           ),),
                          Padding(padding: EdgeInsets.all(spacing_standard_new),
                            child: SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                padding: EdgeInsets.only(
                                    top: spacing_standard_new,
                                    bottom: spacing_standard_new),
                                child: text("Update",
                                    textColor: Colors.white, fontFamily: fontMedium),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(spacing_standard)),
                                color: p_12,
                                onPressed: () => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      EasyLoading.show(),
                                      FirebaseFirestore.instance.collection('User').doc(widget.profil.uid).update({
                                        "uid": widget.profil.uid,
                                        "full_name": name.text,
                                        "phone": phone.text,
                                        "email": email.text,
                                      }).then((value) => {
                                        if(EasyLoading.isShow){
                                          EasyLoading.dismiss()
                                        },
                                        Flushbar(
                                          title: "Success",
                                          message: "Data berhasil diperbarui, Silakan Reload Aplikasi!",
                                          duration: Duration(seconds: 2),
                                        ).show(context)
                                      }).catchError((onError){
                                        if(EasyLoading.isShow){
                                          EasyLoading.dismiss();
                                        }
                                        Flushbar(
                                          title: "Error",
                                          message: "Jaringan bermasalah",
                                          duration: Duration(seconds: 2),
                                        ).show(context);
                                      })
                                    }
                                },
                              ),
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

}