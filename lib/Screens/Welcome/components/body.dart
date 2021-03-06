import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerBottomTabs.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerLocation.dart';
import 'package:grocy/Screens/Login/login_screen.dart';
import 'package:grocy/Screens/ShopScreens/AddProduct.dart';
import 'package:grocy/Screens/ShopScreens/BottomTabs.dart';
import 'package:grocy/Screens/Signup/signup_screen.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/constants.dart';
import 'package:flutter_svg/svg.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async{
    print("Called");
    final storage = new FlutterSecureStorage();
    String user_token = await storage.read(key: 'user_token');
    String shop_token = await storage.read(key: 'shop_token');
    String addresses = await storage.read(key: 'addresses');
    print("Shop Token");
    print(shop_token);
    print(user_token);
    if(user_token!=null && addresses==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ConsumerLocationScreen()),(route) => false);
    }
    if(addresses!=null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ConsumerBottomTabs()),(route) => false);
    }
    if(shop_token!=null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BottomTabs()),(route) => false);
    }
  }
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                Image.asset(
                  "assets/images/shopping_logo.jpg",
                  height: size.height * 0.45,
                ),
                SizedBox(height: size.height * 0.025),
                Container(
                  child: Text(
                    'Grocyyy',
                    style: TextStyle(
                      color: Color(0xFF27AE60),
                      fontSize: 40
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                RoundedButton(
                  text: "LOGIN",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                RoundedButton(
                  text: "SIGN UP",
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
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
        )
      ),
    );
  }
}
