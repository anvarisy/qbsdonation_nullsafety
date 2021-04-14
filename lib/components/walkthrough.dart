import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/helpers/widgets.dart';
import 'package:qbsdonation/models/colors.dart';
import 'package:qbsdonation/models/font_sizes.dart';

class walkthrough_widget extends StatelessWidget {
  var title;
  var image;
  var subTitle;

  walkthrough_widget({this.title, this.image, this.subTitle});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        SizedBox(
          height: height * 0.3,
        ),
        Expanded(
          child:
/*          Image(
            width: double.infinity,
            height: double.infinity,
            image: NetworkImage(image),
          ),*/
           Image.network(image,
            width: double.infinity,
            height: double.infinity,
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

          )

        ),
        Padding(padding: EdgeInsets.fromLTRB(spacing_large, height * 0.2, spacing_large, 0),
          child: text(title,
              fontSize: textSizeLarge,
              fontFamily: fontBold,
              textColor: t12_text_color_primary),),
        Padding(padding: EdgeInsets.fromLTRB(spacing_large, spacing_standard, spacing_large, 0),
          child: text(subTitle, maxLine: 5, fontSize: textSizeMedium, isCentered: true) ,)

      ],
    ));
  }
}