import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class report_screen extends StatefulWidget{
  final mission m;
  final user_profil profil;

  report_screen({required this.m, required this.profil});

  @override
  State<StatefulWidget> createState() {
    return _report_screen();

  }

}
class _report_screen extends State<report_screen>{
  TextEditingController title = TextEditingController();
  TextEditingController lampiran = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: 50,
            height: 10,
            decoration: boxDecoration(color: t7view_color, radius: 16, bgColor: t7view_color),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: t7white),
              height: MediaQuery.of(context).size.width * 1.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text_normal('Laporkan Misi Terkait', fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                    SizedBox(
                      height: 8,
                    ),
                    text_normal('Fitur ini digunakan apabila ternyata misi yang anda lihat tidak relevan dengan kenyataan. \n'
                        'Atau mungkin alasan lainnya terkait misi tersebut.', isLongText: true, textColor: t7textColorSecondary),
                    SizedBox(
                      height: 16,
                    ),
                    Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: title,
                            decoration: InputDecoration(
                              labelText: 'Alasan Pengaduan',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: Divider(
                              color: t7view_color,
                              height: 0.5,
                            ),
                          ),
                          TextFormField(
                            onTap: ()=>{
                                print('Ontaped')
                            },
                            controller: lampiran,
                            decoration: InputDecoration(
                              labelText: 'lampiran',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 16),
                      child: Divider(
                        height: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: ()=>{
                            if(title.text!="" && lampiran.text!="" ){

                              FirebaseFirestore.instance.collection('Pengaduan').doc().set({
                                'p_uid':widget.profil.uid,
                                'p_name':widget.profil.name,
                                'mis_id':widget.m.id,
                                'mis_name':widget.m.title,
                                'reason':title.text,
                                'lampiran':lampiran.text,
                                "date": DateFormat('yyyy-MM-dd').format(new DateTime.now())
                              }).then((value) => {
                                EasyLoading.show(),
                                lampiran.clear(),
                                title.clear(),
                                Flushbar(
                                  title: "Success",
                                  message: "Terimakasih atas laporannya",
                                  duration: Duration(seconds: 2),
                                ).show(context)
                              }).catchError((onError){
                                Flushbar(
                                  title: "Error",
                                  message: "Terjadi gangguan pada server",
                                  duration: Duration(seconds: 2),
                                ).show(context);
                              })
                            }else{
                              Flushbar(
                                title: "Perhatian",
                                message: "Lengkapi formulir",
                                duration: Duration(seconds: 2),
                              ).show(context)
                            }

                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                              child: text('LAPORKAN', textColor: t7white , isCentered: true, fontFamily: fontMedium),
                              decoration: boxDecoration(bgColor: t7view_color, radius: 6)),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
  Future<File> takeFile() async {
    String path = '';
    FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],).then((value) => {
       print(value!.files.single.path),
      path = value.files.single.path!
    });
    /*if(result != null) {
      file = File(result.files.single.path!);
    } else {
      file = File("");
    }*/
    return Future.value(File(path));
  }

  Future uploadPhoto(File file) async {
    firebase_storage.Reference  storageReference = firebase_storage.FirebaseStorage.instance.ref()
      .child('Pengaduan/${widget.profil.uid}/${file.path.split('/').last}');
      storageReference.getDownloadURL().then((value) => {
      lampiran.text = value
      });
/*    storageReference.getDownloadURL().then((fileURL) {
      print(fileURL);
      lampiran.text = fileURL;

      setState(() {
        _isLoading = false;
      });
    }).catchError((onError) {
      print(onError);
      Flushbar(
        title: "Error",
        message: "Terjadi gangguan jaringan atau masalah pada server",
        duration: Duration(seconds: 2),
      )..show(context);
      setState(() {
        _isLoading = false;
      });
    });*/
  }
}