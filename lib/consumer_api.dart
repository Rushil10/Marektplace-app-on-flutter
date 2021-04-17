import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

Uri url = Uri.parse('http://e52f7ce7c325.ngrok.io');
var url2 = 'https://localhost:3000';

final storage = new FlutterSecureStorage();

class ConsumerApi {
  Future signup(String user) async {
    http.Response response = await http.post(Uri.parse('$url/consumer/signup'),
        headers: {"Content-Type": "application/json"},
        body:user);
    String data = response.body;
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }

  Future login(String user) async {
    http.Response response = await http.post(Uri.parse('$url/consumer/login'),
        headers: {"Content-Type": "application/json"},
        body:user);
    String data = response.body;
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }

  Future getShops(String location) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.post(Uri.parse('$url/consumer/shops'),
        headers: {"Content-Type": "application/json","Authorization": 'Bearer $token'},
        body:location);
    String data = response.body;
    print(data);
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }

  Future getShopProducts(var shop_id) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/$shop_id/products'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future addToCart(var product_id) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/cart/$product_id'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future subtractFromCart(var product_id) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/cart/remove/$product_id'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future deleteFromCart(var product_id) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.delete(Uri.parse('$url/consumer/cart/$product_id'),
      headers: {"Content-Type": "application/json","Authorization": 'Bearer $token'},
    );
  }

  Future getCartItems() async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/cartItems'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future checkAvalibility() async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/checkAvalibility'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future makeOrder(String pm) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    print(pm);
    String p = await convertOrderPaymentTypeToJson();
    http.Response response = await http.post(Uri.parse('$url/consumer/makeOrder'),
      headers: {"Authorization": 'Bearer $token'},
      body:p
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future makeCodOrder() async {
    var token = await storage.read(key: 'user_token');
    print(token);
    //print(pm);
    String p = await convertCodOrderPaymentTypeToJson();
    http.Response response = await http.post(Uri.parse('$url/consumer/makeOrderCod'),
        headers: {"Authorization": 'Bearer $token'},
        body:p
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getOrders() async{
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/pending'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getOutForDelivery() async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/outForDelivery'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getDelivered() async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/delivered'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getOrderDetails(var cartId) async {
    var token = await storage.read(key: 'user_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/orders/$cartId'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }
}

class ShopApi {

  Future getProducts() async{
    var token = await storage.read(key: 'shop_token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var shop_id = decodedToken['shop_id'];
    print(decodedToken);
    print(token);
    http.Response response = await http.get(Uri.parse('$url/consumer/$shop_id/products'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getOutForDeliveryProducts() async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/orders/outForDelivery'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getDeliveredProducts() async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/orders/delivered'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future getOrderedProducts() async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/shop/orders'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }

  Future signup(String shop) async {
    http.Response response = await http.post(Uri.parse('$url/shop/signup'),
        headers: {"Content-Type": "application/json"},
        body:shop);
    String data = response.body;
    print(data);
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }


  Future login(String shop) async {
    http.Response response = await http.post(Uri.parse('$url/shop/login'),
        headers: {"Content-Type": "application/json"},
        body:shop);
    String data = response.body;
    print(data);
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }

  Future addProduct(String product) async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.post(Uri.parse('$url/shop/product'),
        headers: {"Content-Type": "application/json","Authorization": 'Bearer $token'},
        body:product);
    String data = response.body;
    print(data);
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }

  Future updateProduct(String product,var product_id) async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.post(Uri.parse('$url/shop/product/$product_id'),
        headers: {"Content-Type": "application/json","Authorization": 'Bearer $token'},
        body:product);
    String data = response.body;
    print(data);
    var decodedData = jsonDecode(data);
    print(decodedData);
    return decodedData;
  }

  Future deleteProduct(var product_id) async{
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.delete(Uri.parse('$url/shop/product/$product_id'),
        headers: {"Content-Type": "application/json","Authorization": 'Bearer $token'},
    );
  }

  Future updateDeliveryStatus(var cart_id) async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/order/$cart_id'),
      headers: {"Content-Type": "application/json","Authorization": 'Bearer $token'},
    );
  }

  Future getOrders(var cart_id) async {
    var token = await storage.read(key: 'shop_token');
    print(token);
    http.Response response = await http.get(Uri.parse('$url/shop/orders/$cart_id'),
      headers: {"Authorization": 'Bearer $token'},
    );
    //print(response.body);
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }
}