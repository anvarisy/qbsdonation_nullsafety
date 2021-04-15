import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

import 'article_detail.dart';

class article_list extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _article_list();
  }

}

class _article_list extends State<article_list>{

  @override
  Widget build(BuildContext context) {
    return BuildArticle(context);

  }
  Widget divider() {
    return Divider(
      height: 0.5,
      color: t4_view_color,
    );
  }


  Widget BuildArticle(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Article').orderBy('date').snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _Article(context, snapshot.data!.docs);
      },
    );
  }

  Widget _Article(BuildContext context, List<DocumentSnapshot> snapshot){
    List<articles> list = <articles>[];
    for(DocumentSnapshot element in snapshot){
      articles item = articles();
      item.detail = element['detail'];
      item.title = element['title'];
      item.image = element['image'];
      item.date = element['date'];
      list.add(item);
    }
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>article_detail(article: list[index],)))
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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
                              width: width / 3,
                              height: width / 3.2,
                              fit: BoxFit.fill,
                            ),
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
                                      // text(list[index].date, fontSize: textSizeSMedium, textColor: t4_textColorPrimary),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      text(list[index].detail.toString().replaceAll('/n', '\n'), fontSize: textSizeSMedium, maxLine: 3),
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
                        height: 12,
                      ),
                      divider()
                    ],
                  ))
          );
        });
  }

}