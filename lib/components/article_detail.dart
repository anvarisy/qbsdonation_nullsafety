import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';

class article_detail extends StatefulWidget {
  articles article;

  article_detail({required this.article});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return article_detail_();
  }
}

class article_detail_ extends State<article_detail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Detail Article'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            /*TopBar('Article',bgColor: p_11.withOpacity(0.87),),*/
            Expanded(
              child: SingleChildScrollView(
                child: Container(
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
                              imageUrl:widget.article.image,
                              width: width,
                              // height: width * 0.4,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: spacing_standard_new,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 14),
                        child: Text(widget.article.title, textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, letterSpacing: 1.2,
                                color: t4_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontBold)),
                      ),
                      Container(
                        margin: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Html(
                              data: """
                                        <body>
                                          <div>
                                           ${widget.article.detail.toString()}
                                          </div>
                                        </body>
                                    """,
                              style: {
                                "div":Style(
                                    textAlign: TextAlign.justify,
                                    color: Color(0xFF130925),
                                    fontSize: FontSize(16.0),
                                    letterSpacing: 0.25
                                ),
                              },
                              //Optional parameters:
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
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}