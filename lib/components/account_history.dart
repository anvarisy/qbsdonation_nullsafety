import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class account_history extends StatefulWidget {
  final user_profil profil;

  account_history({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return transaction();
  }
}

class transaction extends State<account_history> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: BuildHistory(BuildContext));
  }

  Widget BuildHistory(BuildContext) {
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
          d.image = element['mis_image']!=null?element['mis_image']:null;//'https://i.pinimg.com/originals/58/a9/f9/58a9f937bcf3bd15903a60370bedf940.png';
          list.add(d);
        }
      }
    };

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length <= 7?list.length:7,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                width: width,
                margin: EdgeInsets.only(top: 18, bottom: 18),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 0, right: 16),
                      width: width / 4.2,
                      height: width / 4.2,
                      child: list[index].image==null?Image.asset('assets/images/icon.png',
                        fit: BoxFit.cover,):
                      CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: 5.0,
                            height: 5.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl:list[index].image,
                        fit: BoxFit.cover,
                      ),
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
                          text_normal(toCurrencyString(list[index].amount,
                              thousandSeparator: ThousandSeparator.Comma,
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
