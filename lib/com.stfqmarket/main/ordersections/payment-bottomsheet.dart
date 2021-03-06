import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qbsdonation/com.stfqmarket/helper/constant.dart';
import 'package:qbsdonation/com.stfqmarket/helper/saveddata.dart';
import 'package:qbsdonation/com.stfqmarket/main/ordersections/payment-webview.dart';
import 'package:qbsdonation/com.stfqmarket/objects/cart.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:http/http.dart' as http;
import 'package:qbsdonation/com.stfqmarket/pages/address-form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentBottomSheet extends StatefulWidget {
  final BuildContext cartContext;
  final num totalWeight;
  final Cart cart;
  final Function(BuildContext context, Cart cart) cancelOrder;

  const PaymentBottomSheet({Key? key, required this.cartContext, required this.cart, required this.cancelOrder, required this.totalWeight}) : super(key: key);
  @override
  _PaymentBottomSheetState createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  static const STATE_CONFIRM_PAYMENT = 0;
  static const STATE_GET_STATUS = 1;
  static const STATE_GET_STATUS_FAILED = 2;
  static const STATE_STATUS_PENDING = 3;
  static const STATE_STATUS_SETTLEMENT = 4;
  static const STATE_STATUS_FAILURE = 5;
  static const STATE_STATUS_CANCEL = 6;
  static const STATE_GET_TRANS_TOKEN = 7;
  static const STATE_GET_TRANS_TOKEN_FAILED = 8;
  static const STATE_TRANSACTION_FAILED = 9;
  static const STATE_FILL_FORM_FAILED = 10;

  var state = 0;
  var title = '';
  var bottomSheetContent;

  String? namaKurir;
  String? namaService;
  num? hargaOngkir;

  Future<dynamic> _getStatus() async {
    final statusResponse = await http.get(
      Uri.https('app.midtrans.com', '/v2/${widget.cart.orderId}/status'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${Constant.MIDTRANS_SERVER_KEY_AUTH_STRING}',
      },
    );

    if ([200, 201].contains(statusResponse.statusCode)) {
      var data = jsonDecode(statusResponse.body);
      print(data);

      return data;
    }

    return -1;
  }

  _launchWebViewTransaction() async {
    _changeState(STATE_GET_TRANS_TOKEN);

    var pref = await SharedPreferences.getInstance();
    var savedAddress = SavedData.getSavedAddress(pref);

    var responseToken = await http.post(
      Uri.https('app.midtrans.com', '/snap/v1/transactions'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic ${Constant.MIDTRANS_SERVER_KEY_AUTH_STRING}',
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': '${widget.cart.orderId}',
          'gross_amount': widget.cart.total + hargaOngkir!,
        },
        'item_details': [
          {
            'id': '-1',
            'price': hargaOngkir,
            'quantity': 1,
            'name': '$namaKurir -> $namaService',
          },
          for (var item in widget.cart.details) {
            'id': '${item.productId}',
            'price': (item.productPrice/item.countProduct),
            'quantity': item.countProduct,
            'name': item.productName,
          },
        ],
        'credit_card': {
          'secure': true,
        },
        'customer_details': {
          'first_name': '${savedAddress['first_name']}',
          'last_name': '${savedAddress['last_name']}',
          'email': '${savedAddress['email']}',
          'phone': '${savedAddress['phone']}',
          'shipping_address': {
            "first_name": '${savedAddress['first_name']}',
            "last_name": '${savedAddress['last_name']}',
            "email": '${savedAddress['email']}',
            "phone": '${savedAddress['phone']}',
            "address": '${savedAddress['address']}',
            "city": '${savedAddress['city']}',
            "postal_code": '${savedAddress['postal_code']}',
            "country_code": '${savedAddress['country_code']}',
          },
        },
      }),
    );

    if ([200, 201].contains(responseToken.statusCode)) {
      var data = jsonDecode(responseToken.body);
      var redirectUrl = data['redirect_url'];

      bool isPop = (await Navigator.of(context).push<bool>(
          new MaterialPageRoute<bool>(builder: (c) => PaymentWebView(
            url: redirectUrl, orderId: widget.cart.orderId,
          )))) ?? false;

      if (isPop) Navigator.pop(context);
      else _doPayment(reCheck: true);
    }
    else {
      print([responseToken.statusCode, responseToken.body]);
      _changeState(STATE_GET_TRANS_TOKEN_FAILED);
      Timer(Duration(seconds: 5), () {
        _launchWebViewTransaction();
      });
    }
  }

  _doPayment({bool reCheck=false}) async {
    _changeState(STATE_GET_STATUS);
    final status = await _getStatus();

    int tryInt;
    try {
      tryInt = int.tryParse(status['status_code']) ?? -1;
    } catch (e) {
      tryInt = -1;
    }
    switch (tryInt) {
      // order id not found
      case 404:
        if (!reCheck) {
          dynamic result = await Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => AddressFormPage(widget.cart.tenantCityCode, widget.totalWeight)));

          if (result != null) {
            namaKurir = result['name'];
            namaService = result['service'];
            hargaOngkir = result['cost'][0]['value'];

            _changeState(STATE_CONFIRM_PAYMENT);
          } else {
            _changeState(STATE_FILL_FORM_FAILED);
          }
        }
        else _changeState(STATE_TRANSACTION_FAILED);
        break;
      // order status settlement / cancel
      case 200:
        String transStatus = status['transaction_status'];
        if (transStatus == 'settlement') _changeState(STATE_STATUS_SETTLEMENT);
        else if (transStatus == 'cancel') _changeState(STATE_STATUS_CANCEL);
        else _changeState(STATE_GET_STATUS_FAILED);
        break;
      // order status pending
      case 201:
        _changeState(STATE_STATUS_PENDING);
        break;
      // order status denied
      case 202:
        _changeState(STATE_STATUS_FAILURE);
        break;
      // order status expired
      case 407:
        _changeState(STATE_STATUS_FAILURE);
        break;
      // unknown error
      default:
        _changeState(STATE_GET_STATUS_FAILED);
        break;
    }
  }

  _changeState(int state) {
    setState(() {
      this.state = state;
    });
    switch (state) {
      case STATE_CONFIRM_PAYMENT:
        setState(() {
          title = 'Konfirmasi Pembayaran';
          bottomSheetContent = _getStateConfirmPaymentContent();
        });
        break;
      case STATE_GET_STATUS:
        setState(() {
          title = 'Memeriksa Status';
          bottomSheetContent = _getStateLoadingContent();
        });
        break;
      case STATE_GET_STATUS_FAILED:
        setState(() {
          title = 'Gagal Memeriksa Status';
          bottomSheetContent = _getStateIconMessageContent(Icons.close, Colors.red, 'Gagal memeriksa status. Periksa internet anda dan ulangi lagi.', canRedoPayment: true);
        });
        break;
      case STATE_STATUS_PENDING:
        setState(() {
          title = 'Status Pending';
          bottomSheetContent = _getStateIconMessageContent(
            Icons.info, Colors.blue, 'Pembayaran belum selesai.', canRedoPayment: true,
            customAction: [
              TextButton(
                child: Text('Buka Payment'),
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  var paymentUrl = SavedData.getSavedPaymentUrl(pref);
                  String url = paymentUrl[widget.cart.orderId];
                  bool isAble = await canLaunch(url);
                  if (isAble) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ],
          );
        });
        break;
      case STATE_STATUS_SETTLEMENT:
        setState(() {
          title = 'Status Settlement';
          bottomSheetContent = _getStateIconMessageContent(Icons.check, Colors.green, 'Pembayaran sudah selesai. Mohon tunggu admin mengkonfirmasi pembayaran anda.');
        });
        break;
      case STATE_STATUS_FAILURE:
        setState(() {
          title = 'Status Gagal';
          bottomSheetContent = _getStateIconMessageContent(Icons.close, Colors.red, 'Pembayaran Gagal. Hapus order?', canCancelOrder: true);
        });
        break;
      case STATE_STATUS_CANCEL:
        setState(() {
          title = 'Status Cancel';
          bottomSheetContent = _getStateIconMessageContent(Icons.close, Colors.red, 'Pembayaran dibatalkan. Hapus order?', canCancelOrder: true);
        });
        break;
      case STATE_GET_TRANS_TOKEN:
        setState(() {
          title = 'Mengambil Token';
          bottomSheetContent = _getStateLoadingContent();
        });
        break;
      case STATE_GET_TRANS_TOKEN_FAILED:
        setState(() {
          title = 'Gagal Mengambil Token';
          bottomSheetContent = _getStateIconMessageContent(Icons.close, Colors.red, 'Gagal mengambil token, akan mencoba lagi dalam 5 detik. Tolong periksa internet anda.');
        });
        break;
      case STATE_TRANSACTION_FAILED:
        setState(() {
          title = 'Transaksi Gagal';
          bottomSheetContent = _getStateIconMessageContent(Icons.close, Colors.red, 'Anda belum menyelesaikan pembayaran.', canRedoPayment: true);
        });
        break;
      case STATE_FILL_FORM_FAILED:
        setState(() {
          title = 'Alamat belum diselesaikan';
          bottomSheetContent = _getStateIconMessageContent(Icons.info, Colors.blue, 'Tolong isi form alamat dengan baik dan benar.', canRedoPayment: true);
        });
        break;
    }
  }

  Widget _getStateConfirmPaymentContent() {
    return Column(
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Bayar barang barang di ${widget.cart.tenantName}?\n',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 1.1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total harga barang:',
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w300, letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          money.toCurrency(widget.cart.total.toString()),
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w300, letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Harga ongkir:',
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w300, letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          money.toCurrency(hargaOngkir.toString()),
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w300, letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\nTotal bayaran:',
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w300, letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          '\n${money.toCurrency((widget.cart.total + hargaOngkir!).toString())}',
                          style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w300, letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Tidak'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Ya'),
                  onPressed: () {
                    _launchWebViewTransaction();
                  },
                ),
              ],
            ),
          ],
        );
  }

  Widget _getStateLoadingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text('Mohon Tunggu...'),
        ),
      ],
    );
  }

  Widget _getStateIconMessageContent(IconData icon, Color iconColor, String message, {bool canRedoPayment=false, bool canCancelOrder=false, List<TextButton>? customAction}) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 48.0,),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Center(child: Text(message, style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,)),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (canRedoPayment) TextButton(
              child: Text('Refresh'),
              onPressed: () {
                _doPayment();
              },
            ),
            if (canCancelOrder) TextButton(
              child: Text('Hapus'),
              onPressed: () {
                widget.cancelOrder(widget.cartContext, widget.cart);
                Navigator.of(context).pop();
              },
            ),
            if (customAction!=null) for (var tb in customAction) tb,
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    _changeState(STATE_GET_STATUS);
    _doPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (4/5),
      child: Column(
        children: [
          Container(
            height: 60,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0,),
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: bottomSheetContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

