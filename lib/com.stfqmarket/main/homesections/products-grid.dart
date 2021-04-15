import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/com.stfqmarket/item-view/product.dart';
import 'package:qbsdonation/com.stfqmarket/objects/product.dart';

class ProductsGrid extends StatefulWidget {
  static const String routeName = '/product-grid';

  final void Function(int count) rootAction;
  final void Function(int page) changeRootPage;
  final String searchQuery;

  const ProductsGrid({Key? key,
    required this.rootAction, required this.changeRootPage, required this.searchQuery
  }) : super(key: key);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  int _productsCount = -1;

  _setProductCount(int count) {
    setState(() => _productsCount = count);
    widget.rootAction(_productsCount);
  }

  @override
  void initState() {
    /*_scrollController = ScrollController(initialScrollOffset: 8.0)
      ..addListener(() {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange)
          if (!_isRefreshing) {
            _isRefreshing = true;
            _fetchProducts();
          }
      });
    _futureCategories = _fetchCategories();
    _fetchProducts(refresh: true);*/
    super.initState();
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
              const Text(
                'Semua Produk',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: FutureBuilder<QuerySnapshot>(
            future: widget.searchQuery.isNotEmpty 
                ? FirebaseFirestore.instance.collection('stfq-market').doc('Products').collection('items').orderBy('product_name')
                .where('product_query', arrayContains: widget.searchQuery).get()
                //.where('product_name', isGreaterThanOrEqualTo: widget.searchQuery).where('product_name', isLessThanOrEqualTo: widget.searchQuery+ '\uf8ff').get()
                : FirebaseFirestore.instance.collection('stfq-market').doc('Products').collection('items').orderBy('product_name')
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                var data = Product.toList(snapshot.data!.docs);
                var screenWidth = MediaQuery.of(context).size.width;
                int gridCrossAxisCount = (screenWidth / 120).truncate();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridCrossAxisCount, childAspectRatio: 9.0/16.0),
                  itemCount: data.length,
                  itemBuilder: (_, i) => ProductItemView(
                    key: Key('${data[i].id}'),
                    product: data[i],
                    buttonSize: 28.0,
                    titleFontWeight: FontWeight.w400,
                    buttonShrink: true,
                    buttonAttachedToBottom: true,
                    newProductCountAction: _setProductCount,
                    changeRootPage: widget.changeRootPage,
                  ),
                );
              }
              else if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(child: Text('Terjadi masalah'),);
              }

              return const Center(child: CircularProgressIndicator(),);
              },
          ),
        ),
      ],
    );
  }
}
