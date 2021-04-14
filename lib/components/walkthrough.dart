import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/helpers/widgets.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';

class walkthrough_widget extends StatelessWidget {
  var title;
  var image;
  var subTitle;

  walkthrough_widget({this.title, this.image, this.subTitle});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(image,
           //width: double.infinity,
           //height: double.infinity,
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
           },
          ),
      ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(spacing_large, spacing_large, spacing_large, 0),
                child: text(
                  title,
                  fontSize: textSizeLarge,
                  fontFamily: fontBold,
                  textColor: t12_text_color_primary,
                  isCentered: true,
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(spacing_large, spacing_standard, spacing_large, 0),
                child: text(subTitle, maxLine: 5, fontSize: textSizeMedium, isCentered: true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}