import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocy/Screens/ShopScreens/BottomTabs.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/consumer_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ShopLocationScreen extends StatefulWidget {
  final email;
  final password;
  final shopName;
  final ownerName;
  final shopContact;
  final address;
  final upiId;
  ShopLocationScreen({this.email,this.password,this.shopName,this.ownerName,this.shopContact,this.upiId,this.address});
  @override
  _ShopLocationScreenState createState() => _ShopLocationScreenState();
}

class _ShopLocationScreenState extends State<ShopLocationScreen> {
  File _image;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var imageUrl;
  var product;
  var latitude;
  var longitude;
  var apiKey='AIzaSyB1hSZ48f5wir9fhHtrNWV6yhVW0H0ZDck';
  var shop;
  ShopApi shopApi = new ShopApi();
  LatLng Pos;
  LocationResult _pickedLocation;
  final storage = new FlutterSecureStorage();
  var error;
  var loading=false;
  var name;
  var street;
  var locality;
  var sublocality;
  var postalcode;
  var completeaddress;

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

  void storeShopToken(var token) async{
    await storage.delete(key: 'user_token');
    await storage.write(key: 'shop_token', value: token);
    print(token);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BottomTabs()), (route) => false);
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
                  margin: EdgeInsets.fromLTRB(0, size.height/15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //height: size.height/2.5,
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 0.75
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                          child: TextButton(
                            child: _image == null ? Image.asset('assets/images/shop_logo.png',height: size.height/5,) : Image.file(_image,height: size.height/5,width: size.width/5,fit: BoxFit.contain,),
                            onPressed: () {
                              showModalBottomSheet(context: context,
                                  builder: (
                                          (builder) =>
                                          Container(
                                            height: size.height/5,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text('Choose Product Image',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height/35,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons.photo),
                                                          iconSize: size.height/15,
                                                          color: Colors.green,
                                                          onPressed: () async{
                                                            await getImageFromGallery();
                                                            print(_image);
                                                          },
                                                        ),
                                                        Text('Gallery',
                                                          style: TextStyle(
                                                              fontSize: 19
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: size.width/3,
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                          icon:const Icon(Icons.camera),iconSize: size.height/15,color: Colors.green,
                                                          onPressed: () async{
                                                            await getImageFromCamera();
                                                          },
                                                        ),
                                                        Text('Camera',
                                                          style: TextStyle(
                                                              fontSize: 19
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                  )
                              );
                            },
                          )
                      )
                    ],
                  ),
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
                        await showModalBottomSheet(context: context,
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
                                              postalcode=placemarks[index].postalCode;
                                              completeaddress=widget.address+ ' , ' + street + ' , ' + locality + ' , ' + sublocality + ' , ' + placemarks[index].administrativeArea + ' , ' + postalcode;
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      })
                              );
                            }
                        );
                        print(placemarks);
                        print(completeaddress);
                        if(street==null) {
                          setState(() {
                            name = placemarks[0].name;
                            locality = placemarks[0].locality;
                            street = placemarks[0].street;
                            sublocality = placemarks[0].subLocality;
                            postalcode=placemarks[0].postalCode;
                            completeaddress=widget.address+ ' , ' + street + ' , ' + locality + ' , ' + sublocality + ' , ' + placemarks[0].administrativeArea+' , ' + postalcode;
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
                  margin: EdgeInsets.fromLTRB(0, size.height/9, 0, 0),
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
                                'Complete Signup',
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
                      var iname = getRandomString(8);
                      final _storage = firebase_storage.FirebaseStorage.instance;
                      var snapshot = await _storage.ref().child('$iname').putFile(_image);
                      var downloadUrl = await snapshot.ref.getDownloadURL();
                      print(downloadUrl);
                      setState(() {
                        imageUrl=downloadUrl;
                      });
                      shop=convertShopSignupDetailsToJson(widget.email, widget.password, widget.shopName, widget.ownerName, widget.shopContact, widget.upiId, latitude, longitude, completeaddress,imageUrl);
                      print(shop);
                      var data = await shopApi.signup(shop);
                      print(data);
                      if(data['token']!=null) {
                        await storeShopToken(data['token']);
                      } else {
                        error=data['error'];
                        await storage.write(key: 'error', value: error);
                        print(error);
                      }
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
