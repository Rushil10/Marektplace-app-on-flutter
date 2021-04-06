import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/Location/ConsumerLocationScreen.dart';
import 'package:grocy/Screens/ShopScreens/AddProduct.dart';
import 'package:grocy/Screens/ShopScreens/BottomTabs.dart';
import 'package:grocy/Screens/Signup/signup_screen.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/components/already_have_an_account_acheck.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/components/rounded_input_field.dart';
import 'package:grocy/components/rounded_password_field.dart';
import 'package:grocy/constants.dart';
import 'package:grocy/consumer_api.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ConsumerApi funcs = ConsumerApi();
  ShopApi shop = ShopApi();
  final storage = new FlutterSecureStorage();
  var email;
  var password;
  var consumer;
  var shopOwner;
  var error;
  void storeToken(var token) async{
    await storage.delete(key: 'shop_token');
    await storage.write(key: 'user_token', value: token);
    print(token);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ConsumerLocationScreen()), (route) => false);
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
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: size.height * 0.09,
                  //fontFamily: "Lobster",
                ),
              ),
              SizedBox(height: size.height * 0.05),
              RoundedInputField(
                hintText: "Your Email",
                icon: Icons.email,
                onChanged: (value) {
                  email=value;
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  password=value;
                },
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              RoundedButton(
                text: "LOGIN AS CUSTOMER",
                press: () async{
                  consumer=convertDetailsToJson(email, password);
                  print(consumer);
                  var data = await funcs.login(consumer);
                  print(data);
                  if(data['token']!=null) {
                    await storeToken(data['token']);
                  } else {
                    error=data['error'];
                    await storage.write(key: 'error', value: error);
                    print(error);
                  }
                },
              ),
              RoundedButton(
                text: "LOGIN AS SHOP OWNER",
                press: () async{
                  shopOwner=convertShopDetailsToJson(email, password);
                  print(shopOwner);
                  var data = await shop.login(shopOwner);
                  print(data);
                  if(data['token']!=null) {
                    await storeShopToken(data['token']);
                  } else {
                    error=data['error'];
                    await storage.write(key: 'error', value: error);
                    print(error);
                  }
                },
              ),
              SizedBox(height: size.height * 0.02),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



