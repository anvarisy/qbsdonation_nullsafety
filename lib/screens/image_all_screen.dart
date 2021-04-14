
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/screens/grid_photo.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class image_all_screen extends StatefulWidget{
  final dynamic images;

  image_all_screen({this.images});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return image_all_screen_();
  }

}

class image_all_screen_ extends State<image_all_screen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // TopBar('Photo-Photo', bgColor: p_11.withOpacity(0.87),),
            Expanded(
              child: SingleChildScrollView(
                child:Container(
                  decoration: backgroundDecor(),
                  child:  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(spacing_standard_new),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            grid_photo(
                              images: widget.images,
                              max: widget.images.length ,
                            )
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

}