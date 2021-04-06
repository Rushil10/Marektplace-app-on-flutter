import 'package:flutter/material.dart';
import 'package:grocy/Screens/ShopSignup/ShopLocation.dart';
import 'package:grocy/components/RoundedInputNumberField.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/components/rounded_input_field.dart';

class ShopSignupScreen extends StatefulWidget {
  ShopSignupScreen({this.email,this.password});
  final email;
  final password;
  @override
  _ShopSignupScreenState createState() => _ShopSignupScreenState();
}

class _ShopSignupScreenState extends State<ShopSignupScreen> {
  var shopName;
  var ownerName;
  var shopContact;
  var area;
  var landmark;
  var town;
  var upiId;
  var address;
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
                      child: RoundedInputField(
                        hintText: 'Shop Name',
                        icon: Icons.store,
                        onChanged: (value) {
                          shopName=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Shop Name',
                        icon: Icons.person,
                        onChanged: (value) {
                          ownerName=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputNumberField(
                        hintText: 'Shop Contact',
                        icon:Icons.phone,
                        onChanged: (value) {
                          shopContact=value;
                        },
                      )
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Area',
                        icon: Icons.location_city,
                        onChanged: (value) {
                          area=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Landmark',
                        icon: Icons.location_on,
                        onChanged: (value) {
                          landmark=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Town/City',
                        icon: Icons.location_city_outlined,
                        onChanged: (value) {
                          town=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Shop UPI Id',
                        icon: Icons.payment,
                        onChanged: (value) {
                          upiId=value;
                        },
                      ),
                    ),
                    RoundedButton(
                      text: 'SIGNUP',
                      press: () async {
                        address = area + ', ' + landmark + ', ' + town;
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ShopLocationScreen(
                            email: widget.email,
                            password: widget.password,
                            shopName: shopName,
                            shopContact: shopContact,
                            address: address,
                            ownerName: ownerName,
                            upiId: upiId,
                          );
                        }));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
