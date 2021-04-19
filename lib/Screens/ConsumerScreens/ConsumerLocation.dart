
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerBottomTabs.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocy/Screens/ShopScreens/BottomTabs.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/consumer_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ConsumerLocationScreen extends StatefulWidget {
  @override
  _ConsumerLocationScreenState createState() => _ConsumerLocationScreenState();
}

class _ConsumerLocationScreenState extends State<ConsumerLocationScreen> {
  File _image;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var imageUrl;
  var latitude;
  var loading=false;
  var longitude;
  var apiKey='AIzaSyB1hSZ48f5wir9fhHtrNWV6yhVW0H0ZDck';
  var name;
  var street;
  var locality;
  var sublocality;
  LatLng Pos;
  LocationResult _pickedLocation;
  final storage = new FlutterSecureStorage();
  var error;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future getImageFromGallery() async{
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image=File(image.path);
    });
  }
  Future getImageFromCamera() async{
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image=File(image.path);
    });
  }

  void storeLocation() async{
    var addresses = [];
    var res = {};
    res['latitude']=latitude;
    res['longitude']=longitude;
    res['street']=street;
    res['locality']=locality;
    res['sublocality']=sublocality;
    res['name']=name;
    addresses.add(res);
    print(addresses);
    var allAddresses = jsonEncode(addresses);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    await storage.write(key: 'addresses', value: allAddresses);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ConsumerBottomTabs()),(route) => false);
  }

  dynamic renderError(IconData icon,var message) {
    Size size = MediaQuery.of(context).size;
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Container(
        height: size.height/5,
        width: size.width-50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,size: 49,color: Colors.green,),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.grey
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
    return showDialog(context: context,builder: (BuildContext context) => errorDialog);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(

                  ),
                    margin: EdgeInsets.only(top:25,bottom: 25,left:0 ),
                    child: Image.asset(
                      "assets/images/loc2.jpg",
                      height: size.height/3,
                      width: size.width-45,
                    )
                ),
                Container(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            side: BorderSide(color:Colors.green)
                        ),
                      ),
                    ),
                    child: Container(
                      width: size.width-105,
                      height: size.height/31,
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_location,
                                color: Colors.white,
                                size: size.height/31,
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              !loading ?
                              Text(
                                'Get Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height/50,
                                ),
                              )
                                  :
                                  SizedBox(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                      strokeWidth: 1.5,
                                    ),
                                    height: size.height/31-5,
                                    width: size.height/31-5,
                                  )
                            ],
                          )
                      ),
                    ),
                    onPressed: () async{
                      setState(() {
                        loading=true;
                      });
                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      print(position);
                      setState(() {
                        loading=false;
                        latitude=position.latitude.toString();
                        longitude=position.longitude.toString();
                      });
                      if(!loading && latitude!=null && longitude!=null ) {
                        List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(
                            latitude), double.parse(longitude));
                        showModalBottomSheet(context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: size.height/4,
                                child: ListView.builder(
                                  itemCount: placemarks.length,
                                    itemBuilder: (BuildContext context,int index) {
                                     return ListTile(
                                       title: Text(
                                         placemarks[index].street
                                       ),
                                       onTap: () {
                                         setState(() {
                                           name = placemarks[index].name;
                                           locality = placemarks[index].locality;
                                           street = placemarks[index].street;
                                           sublocality = placemarks[index].subLocality;
                                         });
                                         Navigator.pop(context);
                                       },
                                     );
                                    })
                              );
                            }
                        );
                        print(placemarks);
                        if(street==null) {
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
                    margin: EdgeInsets.fromLTRB(5,35, 5, 0),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Latitude : $latitude',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.green
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5,35, 5, 0),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Longitude : $longitude',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.green
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5,35, 5, 0),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Street : $street',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.green
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5,35, 5, 0),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loaclity : $locality',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.green
                          ),
                        )
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, size.height/15, 0, 0),
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              side: BorderSide(color:Colors.green)
                          ),
                        ),
                      ),
                      child: Container(
                        width: size.width-51,
                        height: size.height/21,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: Colors.white,
                                  size: size.height/22.5,
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Text(
                                  'NEXT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height/45,
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                      onPressed: () async{
                        if(latitude==null || longitude==null){
                          return renderError(Icons.location_searching, 'Latitude and Longitude cannot be empty !');
                        }
                        storeLocation();
                      }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
