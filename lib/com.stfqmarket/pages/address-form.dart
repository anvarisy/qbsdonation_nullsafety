
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qbsdonation/com.stfqmarket/components/expansiontile.dart';
import 'package:qbsdonation/com.stfqmarket/components/formtextfield.dart';
import 'package:qbsdonation/com.stfqmarket/helper/constant.dart';
import 'package:qbsdonation/com.stfqmarket/helper/saveddata.dart';
import 'package:qbsdonation/com.stfqmarket/helper/sessionmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Kota {
  int id;
  String type;
  String name;

  Kota(this.id, this.type, this.name);

  ///custom comparing function to check if two users are equal
  bool isEqual(Kota model) {
    return this.id == model.id;
  }

  @override
  String toString() => '$type $name';

  static List<Kota> toKotaList(List<dynamic> json) {
    return json.map((e) => Kota(int.tryParse(e['city_id'])!, e['type'], e['city_name'])).toList();
  }
}

class SelectServiceDialog extends StatefulWidget {
  final BuildContext context;
  final Kota selectedKota;
  final String selectedKurir;
  final String tenantCityCode;
  final num cartTotalWeight;

  SelectServiceDialog(this.context, {
    required this.selectedKota, required this.selectedKurir, required this.tenantCityCode, required this.cartTotalWeight
  });

  @override
  _SelectServiceDialogState createState() => _SelectServiceDialogState();
}

class _SelectServiceDialogState extends State<SelectServiceDialog> {
  late Future<List<dynamic>?> _services;

  dynamic _selectedService;

  @override
  BuildContext get context => widget.context;

  Future<List<dynamic>?> _getServices() async {
    final response = await http.post(
      Uri.https('pro.rajaongkir.com', '/api/cost'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'key': Constant.RAJAONGKIR_API_KEY,
        //'android-key': Constant.ANDROID_KEY,
      },
      body: jsonEncode({
        'origin': widget.tenantCityCode,
        'originType': 'city',
        'destination': '${widget.selectedKota.id}',
        'destinationType': 'city',
        'weight': widget.cartTotalWeight,
        'courier': widget.selectedKurir,
      }),
    );

    if ([200, 201].contains(response.statusCode)) {
      final data = jsonDecode(response.body);
      return data['rajaongkir']['results'];
    }
    return null;
  }

  @override
  void initState() {
    _services = _getServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pilih servis ${widget.selectedKurir}'),
      content: FutureBuilder(
        future: _services,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic snapData = snapshot.data;
            return SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var result in snapData) CustomExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 4.0),
                  title: Text('${result['name']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var cost in result['costs'])
                      GestureDetector(
                        onTap: () {
                          var selected = cost;
                          selected['name'] = result['code'];
                          setState(() { _selectedService = selected; });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              color: _selectedService != null
                                  ? _selectedService['service'] == cost['service']
                                  ? Colors.green[100]
                                  : Colors.white
                                  : Colors.white,
                              child: Column(
                                children: [
                                  Text(
                                    '${cost['service']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${cost['description']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${NumberFormat.currency(locale: "id-ID").format(cost['cost'][0]['value'])}',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            '${cost['cost'][0]['etd']} hari',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (cost['cost'][0]['note'] != null && cost['cost'][0]['note'] != '') Padding(
                                        padding: EdgeInsets.only(top: 6.0),
                                        child: Text(
                                          '${cost['cost'][0]['note']}',
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1.0, thickness: 1.0,),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
          }
          return Container(
            height: 80.0,
            alignment: Alignment.center,
            child: snapshot.hasError
                ? Text('Gagal mengambil service. Silahkan diulang kembali.', textAlign: TextAlign.center,)
                : CircularProgressIndicator(),
          );
        },
      ),
      actions: [
        TextButton(
          child: Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: (_selectedService != null)
              ? () => Navigator.of(context).pop(_selectedService)
              : null,
        ),
      ],
    );
  }
}


class AddressFormPage extends StatefulWidget {
  final String tenantCityCode;
  final num totalWeight;

  const AddressFormPage(this.tenantCityCode, this.totalWeight, {Key? key}) : super(key: key);

  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCon = TextEditingController();
  final _lastNameCon = TextEditingController();
  final _emailCon = TextEditingController();
  final _phoneCon = TextEditingController();
  final _addressCon = TextEditingController();
  final _postalCodeCon = TextEditingController();

  List<Kota> _suggestions = [];
  Kota? _selectedKota;
  String? _selectedKurir;

  SharedPreferences? _sharedPreferences;

  _saveAddressAndGetService() async {
    var savedAddress = {
      "first_name": _firstNameCon.text,
      "last_name": _lastNameCon.text,
      "email": _emailCon.text,
      "phone": _phoneCon.text,
      "address": _addressCon.text,
      "city": _selectedKota!.name,
      "city_id": _selectedKota!.id,
      "city_type": _selectedKota!.type,
      "postal_code": _postalCodeCon.text,
      "country_code": "IDN"
    };
    SavedData.setSavedAddress(_sharedPreferences!, savedAddress);

    dynamic selectedService = await showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SelectServiceDialog(context,
        selectedKurir: _selectedKurir!, selectedKota: _selectedKota!, tenantCityCode: widget.tenantCityCode, cartTotalWeight: widget.totalWeight,
      ),
    );
    if (selectedService != null) {
      Navigator.of(context).pop(selectedService);
    }
  }

  _loadData() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    var savedAddress = SavedData.getSavedAddress(_sharedPreferences!);
    if (savedAddress == null) {
      var loginState = await SessionManager.loginState;
      if (loginState) {
        var sessionData = await SessionManager.sessionData;
        setState(() {
          _firstNameCon.text = sessionData!.fullName;
          _emailCon.text = sessionData.email;
          _phoneCon.text = sessionData.phone;
        });
      }
    }
    else {
      setState(() {
        _firstNameCon.text = savedAddress['first_name'];
        _lastNameCon.text = savedAddress['last_name'];
        _emailCon.text = savedAddress['email'];
        _phoneCon.text = savedAddress['phone'];
        _addressCon.text = savedAddress['address'];
        _postalCodeCon.text = savedAddress['postal_code'];
      });
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Alamat'),
      ),
      body: Builder(
        builder: (context) {
          return ListView(
            padding: EdgeInsets.all(24.0),
            children: [
              SizedBox(height: 48.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomFormTextField(
                      label: 'Nama Awal',
                      controller: _firstNameCon,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    CustomFormTextField(
                      label: 'Nama Akhir',
                      controller: _lastNameCon,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    CustomFormTextField(
                      label: 'Email',
                      inputType: TextInputType.emailAddress,
                      controller: _emailCon,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    CustomFormTextField(
                      label: 'No. Hp',
                      inputType: TextInputType.phone,
                      controller: _phoneCon,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    CustomFormTextField(
                      label: 'Kode Pos',
                      inputType: TextInputType.number,
                      controller: _postalCodeCon,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    CustomFormTextField(
                      label: 'Alamat',
                      inputType: TextInputType.multiline,
                      controller: _addressCon,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    DropdownSearch<Kota>(
                      mode: Mode.DIALOG,
                      isFilteredOnline: true,
                      onFind: (filter) async {
                        if (_suggestions.isEmpty) {
                          final response = await http.get(
                            Uri.https('api.rajaongkir.com', '/starter/city'),
                            headers: {
                              'key': Constant.RAJAONGKIR_API_KEY,
                              //'android-key': Constant.ANDROID_KEY,
                            },
                          );

                          if (response.statusCode == 200) {
                            final results = jsonDecode(response.body)['rajaongkir']['results'];
                            final kotas = Kota.toKotaList(results);

                            _suggestions.addAll(kotas);

                            return _suggestions;
                          }
                        }

                        List<Kota> filteredKotas = _suggestions.where((element) => element.name.toLowerCase().contains(filter.toLowerCase())).toList();
                        return filteredKotas;
                      },
                      showSearchBox: true,
                      showSelectedItem: true,
                      compareFn: (Kota? city, Kota? filter) {
                        if (filter == null) return false;
                        return city?.isEqual(filter) ?? false;
                      },
                      label: "Kota",
                      dropdownBuilder: (context, Kota? city, str) => (city?.name.isEmpty == null)
                          ? ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text("Pilih kota"),
                      )
                          : ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(city!.name),
                        subtitle: Text(city.type),
                      ),
                      popupItemBuilder: (context, Kota? city, selected) =>
                      (selected)
                          ? ListTile(
                        title: Text(city!.name, style: TextStyle(color: Colors.green),),
                        subtitle: Text(city.type),
                      )
                          : ListTile(
                        title: Text(city!.name),
                        subtitle: Text(city.type),
                      ),
                      searchBoxDecoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Cari Kota...',
                      ),
                      dropdownSearchDecoration: DefaultInputDecoration(),
                      onChanged: (Kota? city) => setState(() { _selectedKota = city; }),
                      validator: (val) {
                        if (val == null) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0,),
                    DropdownSearch<String>(
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      maxHeight: 160,
                      items: [
                        'jne', 'pos', 'wahana', 'jnt', 'sap', 'sicepat', 'jet',
                        'dse', 'first', 'ninja', 'lion', 'idl', 'rex', 'ide', 'sentral', 'anteraja'
                      ],
                      label: "Kurir",
                      hint: "Pilih kurir",
                      dropdownBuilder: (context, String? courier, str) => ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(courier ?? "Pilih kurir"),
                      ),
                      dropdownSearchDecoration: DefaultInputDecoration(),
                      popupItemDisabled: (String? courier) {
                        if (_selectedKurir != null) return _selectedKurir == courier;
                        return false;
                      },
                      onChanged: (String? courier) => setState(() { _selectedKurir = courier; }),
                      validator: (val) {
                        if (val == null) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.0,),
                    RaisedButton(
                      padding: EdgeInsets.all(14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text('Konfirmasi', style: TextStyle(color: Colors.white),),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) _saveAddressAndGetService();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),
            ],
          );
        },
      ),
    );
  }
}
