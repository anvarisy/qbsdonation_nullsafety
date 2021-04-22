import 'dart:convert';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qbsdonation/components/dialog.dart';
import 'package:qbsdonation/models/dafq.dart';
import 'package:qbsdonation/screens/snap_screen.dart';
import 'package:qbsdonation/utils/colors.dart';
import 'package:qbsdonation/utils/constants.dart';
import 'package:qbsdonation/utils/widgets.dart';

class open_ticket extends StatefulWidget {
  var isScrollable = false;
  List<ticket> mFavouriteList;
  final mission m;
  final user_profil profil;

  open_ticket({required this.isScrollable, required this.mFavouriteList, required this.m, required this.profil});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _open_ticket();
  }
}

class _open_ticket extends State<open_ticket> {
  bool isMakePayment = false;
  double value = 0;
  TextEditingController amount = new TextEditingController();
  TextEditingController amount_saldo = new TextEditingController();
  String random_id = '';

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(spacing_standard_new),
        child:GridView.builder(
            scrollDirection: Axis.vertical,
            physics: widget.isScrollable
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemCount: widget.mFavouriteList.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (widget.mFavouriteList[index].value == 1) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) =>SingleChildScrollView(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: const Offset(0.0, 10.0),
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width,
                            //height: MediaQuery.of(context).size.height * 0.8,
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // To make the card compact
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/icon.png',
                                  width: width * 0.25,
                                  height: width * 0.25,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height: spacing_standard_new,
                                ),
                                text_normal(
                                    'Silakan masukan nominal yang ingin anda donasikan',
                                    textColor: t10_textColorSecondary,
                                    isLongText: true,
                                    isCentered: true),
                                SizedBox(
                                  height: spacing_standard_new,
                                ),
                                TextFormField(
                                  controller: amount,
                                  cursorColor: t10_colorPrimary,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.fromLTRB(16, 8, 4, 8),
                                    hintText: 'Rp -.00',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: t10_view_color, width: 0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: t10_view_color, width: 0.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  style: TextStyle(
                                    fontSize: textSizeMedium,
                                    color: t10_textColorPrimary,
                                  ),
                                ),
                                SizedBox(
                                  height: spacing_standard_new,
                                ),
                                AppButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    setState(() {
                                      value = double.parse(amount.text);
                                    });
                                    makePayment(double.parse(amount.text));

                                  },
                                  textContent: "Donate",
                                ),
                                SizedBox(
                                  height: spacing_large,
                                ),
                              ],
                            ),
                          ),));
                  } else {
                    // Navigator.pop(context);
/*                    setState(() {
                      value = widget.mFavouriteList[index].value!;
                    });*/
                    print(widget.mFavouriteList[index].value!);
                    makePayment(widget.mFavouriteList[index].value!);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: boxDecoration(
                      radius: 10, showShadow: true, bgColor: t5White),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: width / 7.5,
                        width: width / 7.5,
                        margin: EdgeInsets.only(bottom: 4, top: 8),
                        padding: EdgeInsets.all(width / 30),
                        decoration: boxDecoration(
                            bgColor: widget.mFavouriteList[index].color!,
                            radius: 10),
                        child: Image.asset(
                          widget.mFavouriteList[index].icon,
                          color: t5White,
                        ),
                      ),
                      text(widget.mFavouriteList[index].amount,
                          fontSize: textSizeMedium)
                    ],
                  ),
                ),
              );
            }),
      ),
    );



  }

  @override
  void initState() {
    super.initState();
  }

  String randomId(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  makePayment(double donation) {
/*    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                payment_screen(
                  profil: widget.profil,
                  m: widget.m,
                  amount: donation,
                )));*/
    EasyLoading.show();
    random_id = 'dafq-'+randomId(12);
      var  data = {
      "transaction_details": {
        "order_id": random_id,
        "gross_amount": donation,
      },
      "item_details": [
        {
          "id": widget.m.id,
          "price": donation,
          "quantity": 1,
          "name": widget.m.title,
          "merchant_name": "Yayasan Dompet Amal Fahim Quran"
        }
      ],
      "customer_details": {
        "first_name": widget.profil.name,
        "last_name": "",
        "email": widget.profil.email,
        "phone": widget.profil.mobile,
      },
        "callbacks": {
          //"finish": "dafq://id.khwarizmi.qbsdonation",
        },
        "gopay": {
          "enable_callback": true,
          //"callback_url":'dafq://id.khwarizmi.qbsdonation'
        }
    };
    var json ;
    chargeServer(data).then((value) => {
      print(value),
      if(EasyLoading.isShow){
        EasyLoading.dismiss()
      },
      json =jsonDecode(value),
      FirebaseFirestore.instance.collection("s-transactions")
          .doc(random_id).set({
        "p_uid":widget.profil.uid,
        "p_name":widget.profil.name,
        "mis_id":widget.m.id,
        "mis_name":widget.m.title,
        "mis_image":widget.m.image,
        "gross_amount": "0"
      }).then((value) => {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => snap_screen(snap_url: json['redirect_url'],)))
      }).catchError((onError){
        if(EasyLoading.isShow){
          EasyLoading.dismiss();
        };
        Flushbar(
          title: "Error",
          message: "Terjadi gangguan jaringan",
          duration: Duration(seconds: 2),
        ).show(context);
      })
    });
  }

  Future<dynamic> chargeServer(var data) async {
    //'https://payment.daf-q.id/charge'
    String url = 'https://app.midtrans.com/snap/v1/transactions';
    final http.Response res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':' Basic TWlkLXNlcnZlci1RZUFWM2hCN0pSaEFhVTRHT1RZX254Q046'
        },
        body: jsonEncode(data)

    );
    return Future.value(res.body);

  }

}
