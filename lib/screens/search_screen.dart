
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

import 'package:qbsdonation/screens/detail_screen.dart';

class search_screen extends StatefulWidget{
  final user_profil profil;
  search_screen({required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return search_screen_state();
  }

}

class search_screen_state extends State<search_screen>{
  TextEditingController search = TextEditingController();
  late List<mission> all_missions;
  List<mission> missions = [];

  Future<void> getAll_missions() async {
    var documents = await FirebaseFirestore.instance.collection('Missions').orderBy('type').get();

    setState(() {
      all_missions = documents.docs.map<mission>((element) {
        mission model = mission();
        Map<String, dynamic> data = element.data();

        model.title = data['title'];
        model.target = data['target'];
        model.detail = data['detail'];
        model.image = data['photo'];
        model.photos = data['photos'];
        model.start = data['start'];
        model.end = data['end'];
        model.report = data['report'];
        model.collected = data['collected'];
        return model;
      }).toList();
      missions.addAll(all_missions);
    });
  }

  Widget BuildMission(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: boxDecoration(radius: 10, showShadow: true),
            child: TextField(
              controller: search,
              onEditingComplete: ()=>{
                FocusScope.of(context).requestFocus(new FocusNode()),
                filter(search.text)
              },
              onTap: ()=>{
                search.text = "",
                setState((){
                  missions.clear();
                  missions.addAll(all_missions);
                })
              },
              textAlignVertical: TextAlignVertical.center,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: t11_WhiteColor,
                hintText: 'Cari Misi',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.only(left: 26.0, bottom: 8.0, top: 8.0, right: 50.0),
              ),
            ),
            alignment: Alignment.center,
          ),
        ),
        _Mission(context),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getAll_missions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: BackButton(color: Colors.black,),
      ),
      body: all_missions == null
          ? Center(child: CircularProgressIndicator(),)
          : BuildMission(context),
    );
  }

  Widget _Mission(BuildContext context){
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
          itemCount: missions.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>detail_screen(
                      m: missions[index],
                      profil: widget.profil,
                    )))
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                              imageUrl:missions[index].image,
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
                                      text(missions[index].title, textColor: t4_textColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontBold),
                                      text(money.toCurrency(missions[index].target as String), fontSize: textSizeMedium, textColor: t4_textColorPrimary),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      text(missions[index].detail, fontSize: textSizeSMedium, maxLine: 3),
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
                        height: 16,
                      ),
                      divider()
                    ],
                  )),
            );
          }),
    );
  }
  Widget divider() {
    return Divider(
      height: 0.5,
      color: t4_view_color,
    );
  }
  void filter(String param){
    List<mission> a = [];
    all_missions.forEach((element) {
      var title = element.title;
      if(title.toLowerCase().contains(new RegExp(param.toLowerCase()))){
        print('found');
        a.add(element);
      }
    });
    setState(() {
      missions = a;
    });
  }
}
