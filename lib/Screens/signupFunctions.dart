import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final storage = new FlutterSecureStorage();

String convertDetailsToJson(var email,var password) {
  var res={};
  res["consumer_email"]=email;
  res["consumer_password"]=password;
  String js = json.encode(res);
  print(js);
  return js;
}

String convertShopDetailsToJson(var email,var password) {
  var res={};
  res["email"]=email;
  res["password"]=password;
  String js = json.encode(res);
  print(js);
  return js;
}

String convertToJson(var email,var password,var contact,var address,var name) {
  var res = {};
  res["consumer_email"]=email;
  res["consumer_password"]=password;
  res["consumer_contact"]=contact;
  res["consumer_address"]=address;
  res["consumer_name"]=name;
  String js = json.encode(res);
  print(js);
  return js;
}

String convertProductDetailsToJson(var name, var price,var qty,var imageUrl,var type) {
  var res = {};
  res["product_name"]=name;
  res["product_price"]=price;
  res["product_quantity"]=qty;
  res["product_type"]=type;
  res["product_image"]=imageUrl;
  String js = json.encode(res);
  print(js);
  return js;
}

String convertShopSignupDetailsToJson(var email,var password,var shopName,var ownerName,var shopContact,var upiId,var latitude,var longitude,var address,var imageUrl){
  var res = {};
  res["shop_email"]=email;
  res["shop_password"]=password;
  res["shop_name"]=shopName;
  res["shop_owner"]=ownerName;
  res["shop_contact"]=shopContact;
  res["shop_upiId"]=upiId;
  res["shop_location"]=address;
  res["shop_latitude"]=latitude;
  res["shop_longitude"]=longitude;
  res["shop_image"]=imageUrl;
  String js = json.encode(res);
  print(js);
  return js;
}

String updateProductJson(var product_name,var product_price,var product_type,var product_quantity,var increase_quantity,var decrease_quantity,var product_image) {
  var res = {};
  //res["shop_id"]=shop_id;
  //res["product_id"]=product_id;
  res["product_name"]=product_name;
  res["product_price"]=product_price;
  res["product_type"]=product_type;
  res["product_quantity"]=product_quantity;
  res["increase_quantity"]=increase_quantity;
  res["decrease_quantity"]=decrease_quantity;
  res["product_image"]=product_image;
  String js = json.encode(res);
  print(js);
  return js;
}
