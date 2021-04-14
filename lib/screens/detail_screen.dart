

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbsdonation/components/detail/report_screen.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/screens/grid_photo.dart';
import 'package:qbsdonation/screens/open_ticket.dart';
import 'package:qbsdonation/screens/pdf_screen.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

import 'image_all_screen.dart';

class detail_screen extends StatefulWidget{
  mission m;
  user_profil profil;

  detail_screen({required this.m, required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _detail_screen();
  }

}

class _detail_screen extends State<detail_screen>{

  List<ticket> tickets =<ticket>[];


  @override
  void initState() {
    tickets = getTickets();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSheet(context);
        },
        child: FaIcon(FontAwesomeIcons.donate),
        backgroundColor: p_12,
      ),

      body: SafeArea(
        child: Column(
          children: <Widget>[
            /* TopBar('Detail', bgColor: p_11.withOpacity(0.87),),*/
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                    decoration: backgroundDecor(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(spacing_standard_new),
                          child: Column(
                            children: <Widget>[
                              CachedNetworkImage(
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                imageUrl:widget.m.image,
                                width: width,
                                height: width * 0.4,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                            ],
                          ),
                        ),
                        DefaultTabController(
                          child: TabBar(
                            unselectedLabelColor: t10_textColorSecondary,
                            indicatorColor: t10_colorPrimary,
                            labelColor: t10_colorPrimary,
                            tabs: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: text_normal(
                                  widget.m.title,
                                ),

                              ),
                            ],
                          ),
                          length: 1,
                        ),
                        mInfo(),
                        Container(
                          margin: EdgeInsets.all(spacing_standard_new),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               BuildCollected(context),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text_normal('Laporan Misi',
                                      fontFamily: fontMedium,
                                      fontSize: textSizeLargeMedium),
                                  InkWell(
                                    onTap: ()=>{
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>pdf_screen(path:  widget.m.report,)))
                                    },
                                    child:  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Lihat',
                                              style: TextStyle(
                                                  fontSize: textSizeMedium,
                                                  fontFamily: fontMedium,
                                                  color: t10_textColorSecondary)),
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
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                              Divider(
                                height: 1,
                                color: t10_view_color,
                              ),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text_normal('Adukan Misi',
                                      fontFamily: fontMedium,
                                      fontSize: textSizeLargeMedium),
                                  InkWell(
                                    onTap: ()=>{
                                      showModalBottomSheet(context: context,
                                      isScrollControlled: true,
                                      builder:(BuildContext context)=>report_screen(profil: widget.profil, m: widget.m,))
                                    },
                                    child:  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Ajukan',
                                              style: TextStyle(
                                                  fontSize: textSizeMedium,
                                                  fontFamily: fontMedium,
                                                  color: t10_textColorSecondary)),
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
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                              Divider(
                                height: 1,
                                color: t10_view_color,
                              ),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  text_normal('Koleksi Photo',
                                      fontFamily: fontMedium,
                                      fontSize: textSizeLargeMedium),
                                  InkWell(
                                    onTap: ()=>{
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                          image_all_screen(images: widget.m.photos)
                                      ))
                                    },
                                    child:  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Lainnya',
                                              style: TextStyle(
                                                  fontSize: textSizeMedium,
                                                  fontFamily: fontMedium,
                                                  color: t10_textColorSecondary)),
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
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: spacing_standard_new,
                              ),
                              grid_photo(
                                images: widget.m.photos,
                                max: widget.m.photos.length <= 6 ?widget.m.photos.length:6 ,
                              ),
                              /*grid_photo(
                                images: widget.m.photos,
                                max: widget.m.photos.length <= 6 ?widget.m.photos.length:6 ,
                              )*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mInfo() {
    return Container(
      margin: EdgeInsets.all(spacing_standard_new),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text_normal(widget.m.detail.toString().replaceAll('/n', '\n'),
              textColor: t10_textColorSecondary,
              isLongText: true),
          SizedBox(
            height: spacing_standard_new,
          ),
          Divider(
            height: 1,
            color: t10_view_color,
          ),
        ],
      ),
    );
  }

  showSheet(BuildContext aContext) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.65,
              maxChildSize: 1,
              minChildSize: 0.5,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 24),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(color: t5LayoutBackgroundWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: t5ViewColor,
                        width: 50,
                        height: 3,
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: open_ticket(isScrollable: false,mFavouriteList: tickets,m: widget.m,profil: widget.profil,),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  List<ticket> getTickets(){
    var t = <ticket>[];
    ticket t1 = ticket();
    t1.color = p_12;
    t1.amount = '10,000';
    t1.value = 10000;
    t1.icon = 'assets/images/rp.png';

    ticket t2 = ticket();
    t2.color = p_12;
    t2.amount = '25,000';
    t2.value = 25000;
    t2.icon = 'assets/images/rp.png';

    ticket t3 = ticket();
    t3.color = p_12;
    t3.amount = '50,000';
    t3.value = 50000;
    t3.icon = 'assets/images/rp.png';

    ticket t4 = ticket();
    t4.color = p_12;
    t4.amount = '100,000';
    t4.value = 100000;
    t4.icon = 'assets/images/rp.png';

    ticket t5 = ticket();
    t5.color = p_12;
    t5.amount = '250,000';
    t5.value = 250000;
    t5.icon = 'assets/images/rp.png';

    ticket t6 = ticket();
    t6.color = p_12;
    t6.amount = '500,000';
    t6.value = 500000;
    t6.icon = 'assets/images/rp.png';

    ticket t7 = ticket();
    t7.color = p_13;
    t7.value = 1;
    t7.amount = 'Lainnya';
    t7.icon = 'assets/images/other.png';

    ticket t8 = ticket();
    t8.color = p_13;
    t8.value = 0;
    t8.amount = 'QR';
    t8.icon = 'assets/images/qr.png';

    ticket t9 = ticket();
    t9.color = p_13;
    t9.value = 2;
    t9.amount = 'Potong Saldo';
    t9.icon = 'assets/images/other.png';

    t.add(t1);
    t.add(t2);
    t.add(t3);
    t.add(t4);
    t.add(t5);
    t.add(t6);
    t.add(t7);
    // t.add(t8);
    //  t.add(t9);
    return t;
  }

  Widget BuildCollected(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('s-transactions').where('mis_id',isEqualTo: widget.m.id).snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _Collected(context, snapshot.data!.docs);
      },);
  }

  Widget _Collected(BuildContext context, List<DocumentSnapshot> snapshot){
    double total = 0;
    for(DocumentSnapshot element in snapshot){
      if(element['gross_amount']!=null){
        total+=double.parse(element['gross_amount']);
      }
    }
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text_normal('Target',
                  fontFamily: fontMedium,
                  fontSize: textSizeLargeMedium),
              InkWell(
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                      image_all_screen(images: widget.m.photos)
                  ))
                },
                child:  RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: toCurrencyString(widget.m.target,
                      thousandSeparator: ThousandSeparator.Comma,
                      leadingSymbol: "Rp ",
                      mantissaLength : 2
                  ),
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontFamily: fontMedium,
                              color: t10_textColorSecondary)),
                      /*  WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: t10_textColorPrimary,
                            size: 18,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text_normal('Terkumpul',
                  fontFamily: fontMedium,
                  fontSize: textSizeLargeMedium),
              InkWell(
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                      image_all_screen(images: widget.m.photos)
                  ))
                },
                child:  RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: toCurrencyString(total.toString(),
                              thousandSeparator: ThousandSeparator.Comma,
                              leadingSymbol: "Rp ",
                              mantissaLength : 2
                          ),
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontFamily: fontMedium,
                              color: t10_textColorSecondary)),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: spacing_standard_new,
          ),
          Divider(
            height: 1,
            color: t10_view_color,
          ),
        ],
      ),
    );
  }
}