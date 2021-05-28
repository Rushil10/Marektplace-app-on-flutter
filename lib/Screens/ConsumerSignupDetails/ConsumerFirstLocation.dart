import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerBottomTabs.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/components/rounded_input_field.dart';
import 'package:grocy/consumer_api.dart';

class ConsumerFirstLocation extends StatefulWidget {
  @override
  final email;
  final password;
  final name;
  final contact;
  final imageUrl;
  ConsumerFirstLocation(
      {this.email, this.password, this.name, this.contact, this.imageUrl});
  _ConsumerFirstLocationState createState() => _ConsumerFirstLocationState();
}

class _ConsumerFirstLocationState extends State<ConsumerFirstLocation> {
  @override
  var latitude;
  var loading = false;
  var longitude;
  var name;
  var street;
  var locality;
  var sublocality;
  final storage = new FlutterSecureStorage();
  var error;
  var flat;
  var area;
  var landmark;
  var town;
  var aname;
  var faddress;
  var state;
  var pincode;
  ConsumerApi con = new ConsumerApi();

  dynamic renderError(IconData icon, var message) {
    Size size = MediaQuery.of(context).size;
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Container(
        height: size.height / 5,
        width: size.width - 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 49,
              color: Colors.green,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(
                message,
                style: TextStyle(fontSize: 21, color: Colors.grey),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
    return showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  void storeToken(var token) async {
    await storage.write(key: 'user_token', value: token);
    print(token);
    var caddress = convertAddressToJson(
        faddress, state, pincode, longitude, latitude, aname);
    var resp = await con.addAddress(caddress);
    print(resp);
    var addresses = [];
    var res = {};
    res['latitude'] = latitude;
    res['longitude'] = longitude;
    res['street'] = street;
    res['locality'] = locality;
    res['sublocality'] = sublocality;
    res['name'] = name;
    addresses.add(res);
    print(addresses);
    var allAddresses = jsonEncode(addresses);
    await storage.write(key: 'addresses', value: allAddresses);
    var res2 = await con.updateAddress(resp['addressId']);
    print(res2);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ConsumerBottomTabs()),
        (route) => false);
  }

  void storeLocation() async {
    if (flat == null || flat.toString().isEmpty) {
      return renderError(Icons.home, 'Enter Flat,House,Building Number !');
    }
    if (area == null || area.toString().isEmpty) {
      return renderError(Icons.location_city, 'Area must not be empty');
    }
    if (landmark == null || landmark.toString().isEmpty) {
      return renderError(Icons.location_on, 'Landmark must not be empty');
    }
    if (town == null || town.toString().isEmpty) {
      return renderError(Icons.location_city, 'Town/city name must be given !');
    }
    //var address
    faddress = flat + ', ' + area + ', ' + landmark + ', ' + town;
    var consumer = convertToJson(widget.email, widget.password, widget.contact,
        faddress, widget.name, widget.imageUrl);
    var data = await con.signup(consumer);
    if (data['token'] != null) {
      storeToken(data['token']);
    } else {
      error = data['error'];
      //await storage.write(key: 'error', value: error);
      return renderError(Icons.error, error);
      print(error);
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: RoundedInputField(
                    hintText: 'Flat, House no., Building',
                    icon: Icons.home,
                    onChanged: (value) {
                      flat = value;
                    },
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: RoundedInputField(
                    hintText: 'Area, Colony, Street, Sector',
                    icon: Icons.location_city,
                    onChanged: (value) {
                      area = value;
                    },
                  ),
                ),
              ),
              Container(
                child: RoundedInputField(
                  hintText: 'Landmark',
                  icon: Icons.location_on,
                  onChanged: (value) {
                    landmark = value;
                  },
                ),
              ),
              Container(
                child: RoundedInputField(
                  hintText: 'Town/City',
                  icon: Icons.location_city_outlined,
                  onChanged: (value) {
                    town = value;
                  },
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: 45),
                child: RoundedInputField(
                  hintText: 'Give Your Address a Name',
                  icon: Icons.person,
                  onChanged: (value) {
                    aname = value;
                  },
                ),
              ),
              Container(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                          side: BorderSide(color: Colors.green)),
                    ),
                  ),
                  child: Container(
                    width: size.width - 105,
                    height: size.height / 31,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_location,
                          color: Colors.white,
                          size: size.height / 31,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        !loading
                            ? Text(
                                'Get Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height / 50,
                                ),
                              )
                            : SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  strokeWidth: 1.5,
                                ),
                                height: size.height / 31 - 5,
                                width: size.height / 31 - 5,
                              )
                      ],
                    )),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    print(position);
                    setState(() {
                      loading = false;
                      latitude = position.latitude.toString();
                      longitude = position.longitude.toString();
                    });
                    if (!loading && latitude != null && longitude != null) {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              double.parse(latitude), double.parse(longitude));
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                height: size.height / 4,
                                child: ListView.builder(
                                    itemCount: placemarks.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(placemarks[index].street),
                                        onTap: () {
                                          setState(() {
                                            name = placemarks[index].name;
                                            locality =
                                                placemarks[index].locality;
                                            street = placemarks[index].street;
                                            sublocality =
                                                placemarks[index].subLocality;
                                            state = placemarks[index]
                                                .administrativeArea;
                                            pincode =
                                                placemarks[index].postalCode;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }));
                          });
                      print(placemarks);
                      if (street == null) {
                        setState(() {
                          name = placemarks[0].name;
                          locality = placemarks[0].locality;
                          street = placemarks[0].street;
                          sublocality = placemarks[0].subLocality;
                        });
                      }
                    }
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(5, 35, 5, 0),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Latitude : $latitude',
                        style: TextStyle(fontSize: 19, color: Colors.green),
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(5, 35, 5, 0),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Longitude : $longitude',
                        style: TextStyle(fontSize: 19, color: Colors.green),
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(5, 35, 5, 0),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Street : $street',
                        style: TextStyle(fontSize: 19, color: Colors.green),
                      )
                    ],
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(0, size.height / 25, 0, 0),
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            side: BorderSide(color: Colors.green)),
                      ),
                    ),
                    child: Container(
                      width: size.width - 51,
                      height: size.height / 21,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: size.height / 22.5,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            'Complete Signup',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height / 45,
                            ),
                          ),
                        ],
                      )),
                    ),
                    onPressed: () async {
                      if (latitude == null || longitude == null) {
                        return renderError(Icons.location_searching,
                            'Latitude and Longitude cannot be empty !');
                      }
                      storeLocation();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
