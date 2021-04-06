import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocy/Screens/Location/ConsumerLocationScreen.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/components/RoundedInputNumberField.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/components/rounded_input_field.dart';
import 'package:grocy/consumer_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConsumerSignup extends StatefulWidget {

  ConsumerSignup({this.userInfo});

  final userInfo;
  @override
  _ConsumerSignupState createState() => _ConsumerSignupState();
}

class _ConsumerSignupState extends State<ConsumerSignup> {

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
                            address = flat + ', ' + area + ', ' + landmark + ', ' + town;
                            //print(address);
                            var temp = jsonDecode(widget.userInfo);
                            //print(temp['email']);
                            consumer = convertToJson(temp["email"], temp["password"], contact, address, name);
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
