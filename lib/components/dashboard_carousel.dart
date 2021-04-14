import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';


class dashboard_carousel extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashboard();
  }

}

class dashboard extends State<dashboard_carousel>{
  var currentIndexPage = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BuildCarousel(context);
  }

  Widget BuildCarousel(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Carousel').orderBy('position').snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Text('-')
            : _Carousel(context, snapshot.data!.docs);
      },
    );
  }

  Widget _Carousel(BuildContext context, List<DocumentSnapshot> snapshot){
    List<carousel> list = <carousel>[];
    for (DocumentSnapshot element in snapshot){
      carousel model = carousel();
      model.title = element['title'];
      model.image = element['image'];
      model.subtitle = element['subtitle'];
      model.link = element['link'];
      list.add(model);
    }
    var width = MediaQuery.of(context).size.width;
    width = width - 20;
    final Size cardSize = Size(width, width / 1.8);
    return CarouselSlider(
      options: CarouselOptions(height: cardSize.height),
      items: list.map((slider) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(12.0),
                      child:
                      CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl:slider.image,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: cardSize.height,),
                      /*Image.network(slider.image,
                          width: MediaQuery.of(context).size.width,
                          height: cardSize.height,
                          fit: BoxFit.fill,
                          errorBuilder: (context, child,
                              StackTrace? img){
                            return Icon(Icons.error);
                          },
                          loadingBuilder:(BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if(loadingProgress == null){
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }

                      )*/
                      /*CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl:slider.image,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: cardSize.height,
                      ),*/
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          text(slider.title, textColor: t2_white, fontSize: textSizeNormal, fontFamily: fontSemibold),
                          SizedBox(height: 16),
                          text(slider.subtitle, textColor: t2_white, fontSize: textSizeMedium, maxLine: 2, isCentered: true),
                        ],
                      ),
                    )
                  ],
                ),
            );
          },
        );
      }).toList(),
    );
  }

/* List<carousel> getSliders() {
    List<carousel> list = List<carousel>();
    carousel model1 = carousel();
    model1.title = 'Pembangunan Mesjid';
    model1.subtitle = 'Pembangunan mesjid untuk shalat berjamaah santri dan warga sekitar';
    model1.image = 'assets/images/sample/mesjid.jpg';
    carousel model2 = carousel();
    model2.title = 'Pembangunan Kamar Mandi';
    model2.subtitle = 'Pembangunan kamar mandi untuk digunakan warga yang akan shalat ke mesjid';
    model2.image = 'assets/images/sample/mck.jpeg';
    carousel model3 = carousel();
    model3.title = 'Pembelian Buku';
    model3.subtitle = 'Pembelian buku materi untuk belajar santri penghafal alquran';
    model3.image = 'assets/images/sample/buku.jpg';

    list.add(model1);
    list.add(model2);
    list.add(model3);

    return list;
  }*/
}