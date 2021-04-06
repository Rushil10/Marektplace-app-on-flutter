import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocy/Screens/ShopScreens/AddProduct.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/consumer_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class ProductTile extends StatefulWidget {
  ProductTile({this.product});
  final product;
  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  ShopApi shop = new ShopApi();
  File _image;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var imageUrl;
  var product;
  var type="packaged";
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
  var name;
  var price;
  var qty;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Product'
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.05*size.width, 15, 0.05*size.width, 0),
                  child: TextField(
                    onChanged: (value) {
                      name=value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding: EdgeInsets.all(5.0),
                        labelText: 'Product Name'
                    ),
                    style: TextStyle(
                        fontSize: 19
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                  ),
                  margin: EdgeInsets.fromLTRB(0.05*size.width, 15, 0.05*size.width, 0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        width: 0.325*size.width,
                        margin: EdgeInsets.fromLTRB(0.0275*size.width, 0, 0, 0),
                        child:TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            price=value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Cost',
                            contentPadding: EdgeInsets.fromLTRB(5,0, 5, 0),
                            //labelText: 'Cost'
                          ),
                          style: TextStyle(
                              fontSize: 19
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        width: 0.225*size.width,
                        margin: EdgeInsets.fromLTRB(0.0275*size.width, 0, 0, 0),
                        child:TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            qty=value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Quantity',
                            contentPadding: EdgeInsets.fromLTRB(5,0, 5, 0),
                            //labelText: 'Cost'
                          ),
                          style: TextStyle(
                              fontSize: 19
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //height: size.height/2.5,
                          child: TextButton(
                            child: _image == null ? Image.asset('assets/images/bag.jpg',height: size.height/2.5,) : Image.file(_image,height: size.height/2.5,width: size.width/2.5,fit: BoxFit.contain,),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width-0.1*size.width,
                        height: size.height/18.5,
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: TextButton(onPressed: () async{
                          var iname = getRandomString(8);
                          final _storage = firebase_storage.FirebaseStorage.instance;
                          var snapshot = await _storage.ref().child('$iname').putFile(_image);
                          var downloadUrl = await snapshot.ref.getDownloadURL();
                          print(downloadUrl);
                          setState(() {
                            imageUrl=downloadUrl;
                          });
                          product=convertProductDetailsToJson(name, price, qty, imageUrl, type);
                          print(product);
                          var res = await shop.addProduct(product);
                          print(res);
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AddProduct()), (route) => false);
                        },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9.0),
                                    side: BorderSide(color:Colors.green)
                                ),
                              ),
                            ),
                            child: Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.white
                              ),
                            )
                        ),
                      )
                    ],
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
