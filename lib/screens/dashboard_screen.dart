

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/components/dashboard_carousel.dart';
import 'package:qbsdonation/components/dashboard_list.dart';
import 'package:qbsdonation/helpers/widgets.dart';
import 'package:qbsdonation/models/colors.dart';
import 'package:qbsdonation/models/font_sizes.dart';

class dashboard_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _dashboard_screen();
  }

}

class _dashboard_screen extends State<dashboard_screen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body:
     SingleChildScrollView(
         physics: ScrollPhysics(),
         child: Container(
           padding: EdgeInsets.only(top: 36.0),
           decoration: backgroundDecor(),
           child: Column(
             children: <Widget>[
               // Saldo(
               //   profil: widget.profil,
               // ),
               // SizedBox(height: 16),
               dashboard_carousel(),
               SizedBox(height: 16),
               Padding(
                 padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     text('Lihat Misi Kami',
                         textColor: t2TextColorPrimary,
                         fontSize: textSizeNormal,
                         fontFamily: fontBold),
                     InkWell(
                       onTap: () => {

                       },
                       child: RichText(
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
               ),
               dashboard_list()
             ],
           ),
         )
     )
   );
  }

}