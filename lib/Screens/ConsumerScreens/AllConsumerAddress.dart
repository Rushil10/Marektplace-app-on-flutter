import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerLocation.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/consumer_api.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:redux/redux.dart';

class AllAddresses extends StatefulWidget {
  @override
  final Function update;
  AllAddresses({this.update});

  _AllAddressesState createState() => _AllAddressesState();
}

class _AllAddressesState extends State<AllAddresses> {
  ConsumerApi con = new ConsumerApi();
  var addresses = [];
  var loading = true;
  var selected_name = '';
  var selected_index = 0;
  @override
  void initState() {
    getAllMyAddresses();
  }

  void changeMyAddress() async {
    ConsumerApi con = new ConsumerApi();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print(decodedToken);
    decodedToken['consumer_address'] =
        addresses[selected_index]['consumer_address'];
    print(decodedToken);
    var newAd = await convertNewAddressToJson(
        addresses[selected_index]['consumer_address']);
    var data = await con.getTokenDetails(newAd);
    print(data);
    Map<String, dynamic> decodedToken2 = JwtDecoder.decode(data['token']);
    print(decodedToken2);
    await storage.delete(key: 'user_token');
    await storage.write(key: 'user_token', value: data['token']);
    widget.update(addresses[selected_index]['consumer_address']);
    var addressess = [];
    var res = {};
    res['latitude'] = addresses[selected_index]['latitude'];
    res['longitude'] = addresses[selected_index]['longitude'];
    addressess.add(res);
    print(addressess);
    var allAddresses = jsonEncode(addressess);
    await storage.delete(key: 'addresses');
    await storage.write(key: 'addresses', value: allAddresses);
    var res2 = await con.updateAddress(addresses[selected_index]['addressId']);
    print(res2);
    var token3 = await storage.read(key: 'addresses');
    print(token3);
    Navigator.of(context).pop();
  }

  void addNewAddress(var address) {
    print(address);
    setState(() {
      loading = true;
    });
    var old = addresses;
    old.add(address);
    setState(() {
      addresses = old;
      loading = false;
    });
  }

  void getAllMyAddresses() async {
    setState(() {
      loading = true;
    });
    var data = await con.getMyAddresses();
    setState(() {
      addresses = data;
      loading = false;
    });
    print(data);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Address'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 29,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ConsumerLocationScreen(
                      addAddress: addNewAddress,
                      alreadyin: true,
                    );
                  }));
                })
          ],
        ),
        body: SafeArea(
          child: Container(
              child: loading
                  ? Text('Loading')
                  : Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: addresses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.all(9),
                                      child: Container(
                                        padding: EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.green, width: 0.75),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.5)),
                                          color: addresses[index]
                                                      ['address_name'] ==
                                                  selected_name
                                              ? Colors.green[50]
                                              : null,
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected_name = addresses[index]
                                                    ['address_name'];
                                                selected_index = index;
                                              });
                                              print(selected_name);
                                            },
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          addresses[index]
                                                              ['address_name'],
                                                          style: TextStyle(
                                                              fontSize: 22.5),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      addresses[index]
                                                          ['consumer_address'],
                                                      style: TextStyle(
                                                          fontSize: 19),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      addresses[index]
                                                          ['consumer_state'],
                                                      style: TextStyle(
                                                          fontSize: 19),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ));
                                }),
                          ),
                          GestureDetector(
                            onTap: () {
                              changeMyAddress();
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 7.5),
                                color: Colors.green,
                                width: size.width - 18,
                                padding: EdgeInsets.all(9),
                                height: 45,
                                child: Center(
                                  child: Text(
                                    'Change My Address',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 21),
                                  ),
                                )),
                          )
                        ],
                      ),
                    )),
        ));
  }
}
