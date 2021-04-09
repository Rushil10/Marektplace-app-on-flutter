import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocy/Screens/Location/ConsumerLocationScreen.dart';
import 'package:grocy/Screens/Welcome/welcome_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ShopOwnerProfile extends StatefulWidget {
  @override
  _ShopOwnerProfileState createState() => _ShopOwnerProfileState();
}

class _ShopOwnerProfileState extends State<ShopOwnerProfile> {
  final storage = new FlutterSecureStorage();

  var shop;

  var loading=true;

  @override
  void initState() {
    // TODO: implement initState
    getShopInfo();
  }

  void getShopInfo() async{
    print("Here");
    var token = await storage.read(key: 'shop_token');
    Map<String, dynamic> decodedToken = await JwtDecoder.decode(token);
    setState(() {
      shop=decodedToken;
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:Text(
          'Shop Details'
        ),
        centerTitle: true,
        //backgroundColor: Colors.grey[850],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: !loading ? Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Container(
                      height:size.height/5,
                      width: size.height/5,
                      child: Image.network(shop['shop_image'],fit: BoxFit.contain,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shop['shop_name'],
                    style: TextStyle(
                      fontSize: 29
                    ),
                  )
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shop['shop_owner'],
                    style: TextStyle(
                        fontSize: 19
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 9,
              ),
              Padding(padding: EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone,color: Colors.green,size: 29,),
                  SizedBox(width: 5,),
                  Text(
                    shop['shop_contact'],
                    style: TextStyle(
                      fontSize: 21
                    ),
                  )
                ],
              ),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on,color: Colors.green,size: 29,),
                    SizedBox(width: 5,),
                    Container(
                      width: size.width-45,
                      child: Text(
                        shop['shop_location'],
                        style: TextStyle(
                            fontSize: 21,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.email,color: Colors.green,size: 29,),
                    SizedBox(width: 5,),
                    Container(
                      width: size.width-45,
                      child: Text(
                        shop['shop_email'],
                        style: TextStyle(
                          fontSize: 21,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                child: Container(
                  height: 45,
                  width: size.width-65,
                  margin: EdgeInsets.only(left: 25,right: 25,top: 25),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
                onTap: () async {
                  print('Hi');
                  await storage.delete(key: 'user_token');
                  await storage.delete(key: 'shop_token');
                  Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()),(route) => false);
                },
              )
              )

            ],
          ) : Text(
            'Loading'
          ),
        ),
      )
    );
  }
}
