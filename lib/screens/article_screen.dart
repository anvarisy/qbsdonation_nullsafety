import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/components/article_list.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/widgets.dart';

class article_screen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _article_screen();
  }

}

class _article_screen extends State<article_screen>{

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        backgroundColor: t4_app_background,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              /*  TopBar('News',bgColor: p_11.withOpacity(0.87),),*/
              Expanded(
                child:  SingleChildScrollView(

                    child: Container(
                      decoration: backgroundDecor(),
                      child: article_list(),
                    )
                ),
              ),

            ],
          ),
        )
    );
  }


}