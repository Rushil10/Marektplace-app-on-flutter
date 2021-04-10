import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/Welcome/welcome_screen.dart';

class ConsumerProfile extends StatefulWidget {
  @override
  _ConsumerProfileState createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(50),
        child: GestureDetector(
          child: Text(
            'Logout'
          ),
          onTap: () async{
            FlutterSecureStorage storage = new FlutterSecureStorage();
            await storage.delete(key: 'addresses');
            await storage.delete(key: 'user_token');
            await storage.delete(key: 'shop_token');
            Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()),(route) => false);
          },
        )
      ),
    );
  }
}
