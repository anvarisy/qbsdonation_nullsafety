import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:qbsdonation/components/account_history.dart';
import 'package:qbsdonation/components/history_screen.dart';
import 'package:qbsdonation/components/update_information.dart';
import 'package:qbsdonation/components/update_password.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class profil_screen extends StatefulWidget{
  user_profil u_profil;

  profil_screen({required this.u_profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }


}

class _profil_screen extends State<profil_screen>{

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
        backgroundColor: t10_white,
        body: Container(
          decoration: backgroundDecor(),
          child:  SafeArea(
            child: Column(
              children: <Widget>[
                /* TopBar('Account', bgColor: p_11.withOpacity(0.2),logout: 'Logout',),*/
                Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(spacing_standard_new, 0, spacing_standard_new, 0),
                        child:  Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(spacing_middle), bottomRight: Radius.circular(spacing_standard_new), topLeft: Radius.circular(spacing_standard_new), bottomLeft: Radius.circular(spacing_standard_new)),
                                    child: Image.asset(
                                      'assets/images/icon.png',
                                      fit: BoxFit.cover,
                                      height: width * 0.35,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: spacing_standard_new,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      text_normal(widget.u_profil.name, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                                      text(widget.u_profil.mobile, textColor: t10_textColorSecondary),
                                      SizedBox(
                                        height: spacing_control,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(right: spacing_control),
                                                child: Icon(
                                                  Icons.email,
                                                  color: t10_textColorSecondary,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            TextSpan(text: widget.u_profil.email, style: TextStyle(fontSize: textSizeMedium, color: t10_textColorSecondary)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: spacing_standard,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              text_normal('Donasi', textColor: t10_textColorSecondary),
                                            ],
                                          ),
                                          Container(
                                            height: width * 0.1,
                                            width: 0.5,
                                            color: t10_view_color,
                                            margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              TotalDonasi(context),

                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: spacing_standard_new,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                      onTap: ()=>{
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>update_information(profil: widget.u_profil,)))
                                      },
                                      child:  RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: 'Update Informasi', style: TextStyle(fontSize: textSizeMedium, fontFamily: fontMedium, color: t10_textColorSecondary)),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 0),
                                                /*  child: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: t10_textColorPrimary,
                                                size: 18,
                                              ),*/
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  InkWell(
                                      onTap: ()=>{
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>update_password(profil: widget.u_profil,)))
                                      },
                                      child:  RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: 'Update Password', style: TextStyle(fontSize: textSizeMedium, fontFamily: fontMedium, color: t10_textColorSecondary)),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 0),
                                                /* child: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: t10_textColorPrimary,
                                                size: 18,
                                              ),*/
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: spacing_standard_new,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text('Riwayat Donasi', textColor: t2TextColorPrimary, fontSize: textSizeNormal, fontFamily: fontBold),
                                  InkWell(
                                      onTap: ()=>{
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>history_screen(profil: widget.u_profil,)))
                                      },
                                      child:  RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: 'Lainnya', style: TextStyle(fontSize: textSizeMedium, fontFamily: fontMedium, color: t10_textColorSecondary)),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 0),
                                                child: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: t10_textColorPrimary,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: spacing_standard_new,
                            ),
                            account_history(profil: widget.u_profil,)
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Widget TotalDonasi(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('s-transactions').where('p_uid',isEqualTo: '${widget.u_profil.uid}').orderBy('transaction_time', descending: true).snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _total(context, snapshot.data!.docs);
      },
    );
  }

  Widget _total(BuildContext context, List<DocumentSnapshot> snapshot){
    double total = 0;
    for(DocumentSnapshot element in snapshot){
      if(element['mis_id']!='12345678'){
        if(element['gross_amount']!= null){
          total += double.parse(element['gross_amount']);
        }
      }


    };
    return  text_normal(toCurrencyString(total.toString(),thousandSeparator: ThousandSeparator.Comma,
        leadingSymbol: "Rp ",
        mantissaLength : 2), fontFamily: fontMedium);
  }



}