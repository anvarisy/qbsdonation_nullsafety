

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/components/dashboard_carousel.dart';
import 'package:qbsdonation/components/dashboard_list.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

import 'mission_screen.dart';

class dashboard_screen extends StatefulWidget{
  user_profil profil;

  dashboard_screen({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _dashboard_screen();
  }

}

class _dashboard_screen extends State<dashboard_screen>{

  late PageController _landscapeScreenPageController;

  @override
  void initState() {
    _landscapeScreenPageController = PageController(
      viewportFraction: 0.85,
    );
    super.initState();
  }

  @override
  void dispose() {
    _landscapeScreenPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: OrientationBuilder(
       builder: (BuildContext context, Orientation orientation) {
         if (orientation == Orientation.portrait) return SingleChildScrollView(
             physics: ScrollPhysics(),
             child: Container(
               padding: EdgeInsets.only(top: 8.0),
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
                             Navigator.of(context).push(MaterialPageRoute(
                                 builder: (context) => mission_screen(
                                   profil: widget.profil,
                                 )))
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
                   dashboard_list(profil: widget.profil,)
                 ],
               ),
             )
         );
         return PageView(
           controller: _landscapeScreenPageController,
           scrollDirection: Axis.vertical,
           children: [
             dashboard_carousel(),
             Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: ListView(
                 children: [
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
                   dashboard_list(profil: widget.profil, /*compact: true,*/)
                 ],
               ),
             ),
           ],
         );
       },
     )
   );
  }

}