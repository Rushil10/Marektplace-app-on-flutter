import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/ConsumerScreens/ShopProducts.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/consumer_api.dart';

class NearbyShops extends StatefulWidget {
  @override
  _NearbyShopsState createState() => _NearbyShopsState();
}

class _NearbyShopsState extends State<NearbyShops> {
  var loading = true;
  var shops;
  @override
  void initState() {
    // TODO: implement initState
    getShops();
    super.initState();
  }

  void getShops() async{
    setState(() {
      loading=true;
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    var addresses = await storage.read(key: 'addresses');
    var allAddresses = jsonDecode(addresses);
    var longitude = allAddresses[0]['longitude'];
    var latitude = allAddresses[0]['latitude'];
    var data = convertLatLongToJson(latitude, longitude);
    print(data);
    ConsumerApi consumer = new ConsumerApi();
    var allShops = await consumer.getShops(data);
    print(allShops);
    setState(() {
      shops=allShops;
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearby Shops'
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: !loading ?
              GridView.builder(
                  itemCount: shops.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: size.width/(size.height/1.75),
                crossAxisCount: 2
              ), itemBuilder: (BuildContext context,int index) {
                    var distance = shops[index]["D"];
                    var dt;
                    if(distance<0){
                      dt="<1km";
                    } else {
                      dt=(1*distance).round();
                    }
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height/4.5,
                        width: size.width/2-39,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border:Border.all(
                            width: 0.79,
                            color: Colors.green
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9))
                        ),
                        child: GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: (size.width/2-39)/1.75,
                                width: (size.width/2-39)/1.75,
                                margin: EdgeInsets.only(top:15),
                                child: Image.network(shops[index]['shop_image'],fit: BoxFit.contain,),
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Container(
                                child: Text(
                                  shops[index]['shop_name'],
                                  style: TextStyle(
                                      fontSize: 25
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Container(
                                child: Text(
                                    "Distance : $dt km"
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            print("Take Me to that shop !");
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ShopProducts(
                                shop: shops[index],
                              );
                            }));
                          },
                        )
                      )
                    ],
                  )
                );
              })
              :
              Center(
                child: Text(
                  'Loading'
                ),
              )
        )
      )
    );
  }
}
