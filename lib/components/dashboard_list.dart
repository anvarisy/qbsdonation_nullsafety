import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/screens/detail_screen.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';


class dashboard_list extends StatefulWidget{
  final user_profil profil;
  //final bool compact;

  dashboard_list({required this.profil});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _dashboard_list();
  }

}

class _dashboard_list extends State<dashboard_list>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BuildDashboard(context);
  }

  Widget BuildDashboard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Missions').orderBy('type').snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _Mission(context, snapshot.data!.docs);
      },
    );
  }

  Widget divider() {
    return Divider(
      height: 0.5,
      color: t4_view_color,
    );
  }

  Widget _Mission(BuildContext context, List<DocumentSnapshot> snapshot){
    List<mission> list = <mission>[];
    for(DocumentSnapshot element in snapshot){
      mission model = mission();
      model.id = element.id;
      model.title = element['title'];
      model.target = element['target'];
      model.detail = element['detail'];
      model.image = element['photo'];
      model.photos = element['photos'];
      model.start = element['start'];
      model.end = element['end'];
      model.collected = element['collected'];
      model.report = element['report'];
      list.add(model);
    }
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final Size cardSize = Size(width, width / 1.8);
    var screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: list.length <= 4 ? list.length : 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: ()=>{
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=>detail_screen(
              m: list[index],
              profil: widget.profil,
              )))
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            child:
                            ClipRRect(
                              child:  CachedNetworkImage(
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                imageUrl:list[index].image,
                                width: screenHeight * (1/5),
                                height: screenHeight * (1/5),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            /* Image.network(list[index].image,
                               width: width / 3,
                                height: width / 3.2,
                                fit: BoxFit.fill,
                                errorBuilder: (context, child,
                                StackTrace? img){
                                return Icon(Icons.error,size:  width / 3,);},
                                loadingBuilder:(BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                                if(loadingProgress == null){
                                return child;}
                                return Center(
                                  child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,),);}
                                ),*/
                            borderRadius: BorderRadius.circular(10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      text(list[index].title, textColor: t4_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontBold),
                                      text(toCurrencyString(list[index].target,
                                       thousandSeparator: ThousandSeparator.Comma,
                                       leadingSymbol: "Rp ",
                                       mantissaLength : 2
                                      ),
                                          fontSize: textSizeMedium, textColor: t4_textColorPrimary),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Html(
                                        data: """
                                             <div>
                                              ${list[index].detail.substring(0, 60)+'..'}
                                             </div>
                                              """,

                                        style: {
                                          "div": Style(
                                            textAlign: TextAlign.left,
                                            color: Color(0xFF130925),
                                            fontSize: FontSize(16.0),
                                            letterSpacing: 0.25,
                                          ),
                                        },
                                        //Optional parameters:
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      divider(),
                    ],
                  )),
            );
          }),
    );
  }

}