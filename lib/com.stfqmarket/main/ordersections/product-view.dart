
import 'package:flutter/material.dart';
import 'package:qbsdonation/com.stfqmarket/helper/constant.dart';
import 'package:qbsdonation/com.stfqmarket/helper/saveddata.dart';
import 'package:qbsdonation/com.stfqmarket/objects/cart.dart';
import 'package:qbsdonation/com.stfqmarket/objects/product.dart';

class ProductView extends StatefulWidget {
  final String tenantId;
  final CartDetail detail;
  final int detailIndex;

  final String? cartOrderId;
  final int? status;

  final void Function(int count)? updateCartCount;
  final void Function(String cartOrderId, int detailI, int count)? updateViewTotal;
  final Future<void> Function(String cartOrderId, int detailI)? deleteProductAction;

  ProductView({Key? key, required this.detail, required this.detailIndex, this.updateViewTotal, this.updateCartCount, this.deleteProductAction, required this.tenantId,
    this.cartOrderId, this.status}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  late CartDetail _detail;
  late int _count = 0;

  _changeCount(String id, String tenantId, int count) async {
    setState(() {
      _detail.countProduct = count;
    });
    Product product = Product(id, tenantId, null, null, null, null, null, null, null, null);
    product.count = _count;
    try {
      widget.updateCartCount!(await SavedData.putProductToCart(product));
      widget.updateViewTotal!(widget.cartOrderId!, widget.detailIndex, _count);

      if (_count == 0) widget.deleteProductAction!(widget.cartOrderId!, widget.detailIndex);
    } catch (e) {}
  }

  Future<bool?> _showDeleteDialog(String productName) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Produk'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apa anda yakin ingin menghapus Produk $productName dari pembelian?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _detail = widget.detail;
    _count = _detail.countProduct;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  _detail.productImage,
                  errorBuilder: (context, e, trace) {
                    return Center(child: Icon(Icons.broken_image, size: 24,));
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_detail.productName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.status == 1) Text(
                        'Jumlah: ${_detail.countProduct}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        widget.status == 0 ? _detail.formattedMultipliedTotal : _detail.formattedTotal,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.status == 0) Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 23.0,
                      height: 23.0,
                      child: OutlinedButton(
                        child: Icon(Icons.remove, size: 18, color: Colors.black,),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                        onPressed: () async {
                          if (_count == 1) {
                            bool deleteConfirmed = (await _showDeleteDialog(_detail.productName))!;
                            if (deleteConfirmed) {
                              _changeCount(_detail.productId, widget.tenantId, --_count);
                            }
                          } else if (_count > 1)
                            _changeCount(_detail.productId, widget.tenantId, --_count);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 30.0,
                        child: Text(
                          '$_count',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 23.0,
                      height: 23.0,
                      child: RaisedButton(
                        child: Icon(Icons.add, size: 18, color: Colors.white,),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () => _changeCount(_detail.productId, widget.tenantId, ++_count),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}