import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/com.stfqmarket/helper/tempdata.dart';
import 'package:qbsdonation/com.stfqmarket/objects/category.dart';

class MainPageCategorySection extends StatefulWidget {
  MainPageCategorySection({Key? key}) : super(key: key);

  @override
  MarketCategorySectionState createState() => MarketCategorySectionState();
}

class MarketCategorySectionState extends State<MainPageCategorySection> {

  int numberOfRefresh = 0;

  Future<List<Category>> _getCategories({bool refresh=false}) async {
    if (TempData.MarketCategories != null && refresh == false) return TempData.MarketCategories!;

    var snapshot = await FirebaseFirestore.instance.collection('stfq-market').doc('Categories').collection('items').get();
    var data = Category.toList(snapshot.docs);
    TempData.MarketCategories = data;
    return data;
  }

  void refresh() {
    setState(() {
      numberOfRefresh++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Semua Kategori',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,),),
            ],
          ),
        ),
        Container(
          //key: Key('$numberOfRefresh'),
          height: 120.0,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: FutureBuilder<List<Category>>(
            key: Key('$numberOfRefresh'),
            future: _getCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    return Container(
                      width: 80.0,
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            color: Theme.of(context).cardColor,
                            child: AspectRatio(
                              child: Image.network(
                                  data[i].image!, fit: BoxFit.cover),
                              aspectRatio: 1,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data[i].name,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 13.0,),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              else if (snapshot.hasError)
                return Center(
                  child: Column(
                    children: [
                      Text('Gagal memuat. Cek internet anda'),
                      ElevatedButton(onPressed: refresh, child: Text('Muat Ulang')),
                    ],
                  ),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          ),
        ),
      ],
    );
  }
}
