import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qbsdonation/com.stfqmarket/helper/tempdata.dart';
import 'package:qbsdonation/com.stfqmarket/item-view/product.dart';
import 'package:qbsdonation/com.stfqmarket/objects/product.dart';

class ProductsGrid extends StatefulWidget {
  static const String routeName = '/product-grid';

  final void Function(int count) rootAction;
  final void Function(int page) changeRootPage;
  final String searchQuery;

  const ProductsGrid({Key? key,
    required this.rootAction, required this.changeRootPage,
    required this.searchQuery
  }) : super(key: key);

  @override
  MarketProductsGridState createState() => MarketProductsGridState();
}

class MarketProductsGridState extends State<ProductsGrid> {

  late String _searchHistory;
  int _productsCount = -1;
  int numberOfRefresh = 0;

  _setProductCount(int count) {
    setState(() => _productsCount = count);
    widget.rootAction(_productsCount);
  }

  Future<List<Product>> _getProducts() async {
    if (TempData.MarketProducts != null && _searchHistory == widget.searchQuery) return TempData.MarketProducts!;

    var snapshot = widget.searchQuery.isNotEmpty
        ? await FirebaseFirestore.instance.collection('stfq-market').doc('Products').collection('items').orderBy('product_name')
        .where('product_query', arrayContains: widget.searchQuery).get()
    //.where('product_name', isGreaterThanOrEqualTo: widget.searchQuery).where('product_name', isLessThanOrEqualTo: widget.searchQuery+ '\uf8ff').get()
        : await FirebaseFirestore.instance.collection('stfq-market').doc('Products').collection('items').orderBy('product_name')
        .get();
    var data = Product.toList(snapshot.docs);
    TempData.MarketProducts = data;
    return data;
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
    _searchHistory = widget.searchQuery;
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
              const Text(
                'Semua Produk',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: FutureBuilder<List<Product>>(
            key: Key('$numberOfRefresh'),
            future: _getProducts(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
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
                return Center(
                  child: Column(
                    children: [
                      Text('Gagal memuat. Cek internet anda'),
                      ElevatedButton(onPressed: refresh, child: Text('Muat Ulang')),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator(),);
              },
          ),
        ),
      ],
    );
  }
}
