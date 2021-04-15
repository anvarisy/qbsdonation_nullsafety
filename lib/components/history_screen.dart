
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class history_screen extends StatefulWidget{
  user_profil profil;
  history_screen({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _history_screen();
  }

}

class _history_screen extends State<history_screen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )),
      backgroundColor: t4_app_background,
      body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              /* padding: EdgeInsets.only(top: 36),*/
                physics: ScrollPhysics(),
                child: Container(
                  decoration: backgroundDecor(),
                  child: BuildHistory(context),
                )
            ),
            /*TopBar('Donasi Anda',bgColor: p_11.withOpacity(0.87),),*/
          ]
      ),
    );
  }

  Widget BuildHistory(BuildContext) {
    print('-----------------');
    print(widget.profil.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('s-transactions')
          .where('p_uid', isEqualTo: '${widget.profil.uid}').orderBy('transaction_time',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _history(context, snapshot.data!.docs);
      },
    );
  }

  Widget _history(BuildContext context, List<DocumentSnapshot> snapshot) {
    var width = MediaQuery.of(context).size.width;
    List<donation> list = <donation>[];
    for (DocumentSnapshot element in snapshot) {
      if(element['mis_id']!='12345678'){
        if(element['gross_amount']!= null){
          donation d = donation();
          d.title = element['mis_name'];
          d.date =  DateFormat('yyyy-MM-dd').format(DateTime.parse(element['transaction_time']));
          d.amount = element['gross_amount'];
          d.image = element['mis_image']!=null?element['mis_image']:null;
          list.add(d);
        }
      }
    };

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 18, bottom: 18),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      width: width / 6.2,
                      height: width / 6.2,
                      child:list[index].image==null?Image.asset('assets/images/icon.png',
                        fit: BoxFit.cover,):
                      Image.network(list[index].image,
                        fit: BoxFit.cover,),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          text(list[index].title,
                              maxLine: 2,
                              textColor: t10_textColorPrimary,
                              fontSize: textSizeMedium,
                              fontFamily: fontSemibold),
                          text_normal(list[index].date,
                              fontSize: textSizeMedium),
                          text_normal(toCurrencyString(list[index].amount,thousandSeparator: ThousandSeparator.Comma,
                          leadingSymbol: "Rp ",
                              mantissaLength : 2),
                              textColor: t10_textColorPrimary,
                              fontSize: textSizeMedium,
                              fontFamily: fontSemibold)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 0.5,
                color: t10_view_color,
              )
            ],
          );
        });
  }
}