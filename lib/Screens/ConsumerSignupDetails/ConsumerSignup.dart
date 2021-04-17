import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerLocation.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/components/RoundedInputNumberField.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/components/rounded_input_field.dart';
import 'package:grocy/consumer_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ConsumerSignup extends StatefulWidget {

  ConsumerSignup({this.email,this.password});

  final email;
  final password;
  @override
  _ConsumerSignupState createState() => _ConsumerSignupState();
}

class _ConsumerSignupState extends State<ConsumerSignup> {
  File _image;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var imageUrl;
  ConsumerApi funcs = ConsumerApi();
  final storage = new FlutterSecureStorage();
  var name;
  var contact;
  var flat;
  var area;
  var landmark;
  var town;
  var address;
  var data;
  var token;
  var error;
  String consumer;

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

  void storeToken(var token) async{
    await storage.write(key: 'user_token', value: token);
    print(token);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ConsumerLocationScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Center(
              child: SafeArea(
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                //height: size.height/2.5,
                                  margin: EdgeInsets.only(bottom: 9),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.green,
                                          width: 0.75
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: TextButton(
                                    child: _image == null ? Image.asset('assets/images/new_user.jpg',height: size.height/5,) : Image.file(_image,height: size.height/5,width: size.width/5,fit: BoxFit.contain,),
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
                          //width: size.width*0.8,
                          child: RoundedInputField(
                            hintText: 'Name',
                            icon:Icons.person,
                            onChanged: (value) {
                              name=value;
                              print(name);
                            },
                          ),
                        ),
                        Container(
                          child:RoundedInputNumberField(
                            hintText: 'Contact',
                            icon:Icons.phone,
                            onChanged: (value) {
                              contact=value;
                            },
                          ),
                        ),
                        Container(
                          child: RoundedInputField(
                            hintText: 'Flat, House no., Building',
                            icon: Icons.home,
                            onChanged: (value) {
                              flat=value;
                            },
                          ),
                        ),
                        Container(
                          child: RoundedInputField(
                            hintText: 'Area, Colony, Street, Sector',
                            icon: Icons.location_city,
                            onChanged: (value) {
                              area=value;
                            },
                          ),
                        ),
                        Container(
                          child: RoundedInputField(
                            hintText: 'Landmark',
                            icon:Icons.location_on,
                            onChanged: (value) {
                              landmark=value;
                            },
                          ),
                        ),
                        Container(
                          child: RoundedInputField(
                            hintText: 'Town/City',
                            icon:Icons.location_city_outlined,
                            onChanged: (value) {
                              town=value;
                            },
                          ),
                        ),
                        RoundedButton(
                          text: 'SIGNUP',
                          press: () async{
                            var iname = getRandomString(8);
                            final _storage = firebase_storage.FirebaseStorage.instance;
                            var snapshot = await _storage.ref().child('$iname').putFile(_image);
                            var downloadUrl = await snapshot.ref.getDownloadURL();
                            print(downloadUrl);
                            await setState(() {
                              imageUrl=downloadUrl;
                            });
                            address = flat + ', ' + area + ', ' + landmark + ', ' + town;
                            //print(address);
                            //var temp = jsonDecode(widget.userInfo);
                            //print(temp['email']);
                            consumer = convertToJson(widget.email,widget.password, contact, address, name,imageUrl);
                            var data = await funcs.signup(consumer);
                            if(data['token']!=null) {
                              await storeToken(data['token']);
                            } else {
                              error=data['error'];
                              await storage.write(key: 'error', value: error);
                              print(error);
                            }
                          },
                        )
                      ],
                    )
                ),
              ),
            ),
        ),
      ),
    );
  }
}
