import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/ConsumerScreens/AllConsumerAddress.dart';
import 'package:grocy/Screens/Welcome/welcome_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ConsumerProfile extends StatefulWidget {
  @override
  _ConsumerProfileState createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  @override
  var loading = true;
  var consumer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async{
    setState(() {
      loading=true;
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print(decodedToken);
    setState(() {
      consumer=decodedToken;
      loading=false;
    });
  }

  void logout() async {
    FlutterSecureStorage storage = new FlutterSecureStorage();
    await storage.delete(key: 'addresses');
    await storage.delete(key: 'user_token');
    await storage.delete(key: 'shop_token');
    Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()),(route) => false);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure, you want to logout ?',
                    style: TextStyle(
                        fontSize: 21,
                        //color: Colors.green
                    ),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',
              style: TextStyle(
                fontSize: 21,
                color: Colors.green
              ),),
              onPressed: () {
                logout();
              },
            ),
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.green
                  ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile'
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(
            Icons.logout,
            color: Colors.white,
              size: 29,
          ), onPressed: () {
            _showMyDialog();
          })
        ],
      ),
      body: SingleChildScrollView(
        child: !loading ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top:7.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.blue[50],
                  border: Border.all(
                    width: 0.75,
                    color: Colors.green
                  )
                ),
                height: size.width/2.99,
                width: size.width/2.99,
                alignment: Alignment.center,
                child: Image.network(consumer['consumer_image'],fit: BoxFit.contain,),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top:9),
                child: Text(
                  consumer['consumer_name'],
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24.555
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(9),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.email_outlined,color: Colors.green,size: 29,),
                    SizedBox(
                      width: 9,
                    ),
                    Text(
                      consumer['consumer_email'],
                      style: TextStyle(
                        fontSize: 21,color: Colors.black54
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.phone,color: Colors.green,size: 29,),
                    SizedBox(
                      width: 9,
                    ),
                    Text(
                      consumer['consumer_contact'],
                      style: TextStyle(
                          fontSize: 21,color: Colors.black54
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      child: Text(
                        'Address : ',
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.green
                        ),
                      ),
                    ),
                    Expanded(child: Text(
                      ''
                    )),
                    IconButton(icon: Icon(Icons.edit,color: Colors.green,size: 25,), onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return AllAddresses();
                      }));
                    })
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Container(
                  width: size.width-18,
                    child: Text(
                      consumer['consumer_address'],
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.black54
                      ),
                    ),
                )
              ],
            ),
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 0),
                width: size.width-15,
                alignment: Alignment.centerLeft,

                child: Padding(
                  padding: EdgeInsets.only(top:5,bottom: 5),
                  child: Text(
                    'Manage My Address',
                    style: TextStyle(
                        fontSize: 22.5,
                      color: Colors.green
                    ),
                  ),
                )
              ),
            )
          ],
        )
        :
          Text(
          'Loading'
      )
      )
    );
  }
}
