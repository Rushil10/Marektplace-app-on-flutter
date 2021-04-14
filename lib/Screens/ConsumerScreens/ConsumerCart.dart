import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocy/consumer_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConsumerCart extends StatefulWidget {
  @override
  _ConsumerCartState createState() => _ConsumerCartState();
}

class _ConsumerCartState extends State<ConsumerCart> {
  ConsumerApi con = new ConsumerApi();
  var products = [];
  var loading = true;
  var orderCount = new Map();
  var total;
  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    getCartItems();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess() {
    print("DOne");
    Fluttertoast.showToast(
        msg: "SUCCESS: " );
  }

  void _handlePaymentError() {
    print("Error");
  }

  void _handleExternalWallet() {
    print("Wallet Handling");
  }

  Future getConsumrerDetails() async{
    FlutterSecureStorage storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken;
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_4t0sWSsmlcPd5x',
      'amount':total*100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    print('disposed');
    super.dispose();
  }

  void getCartItems() async {
    setState(() {
      loading=true;
    });
    var data = await con.getCartItems();
    var orderC = new Map();
    for(int i=0;i<data.length;i++){
      orderC[data[i]['product_id']]=data[i]['quantity'];
    }
    double tot=0;
    if(data.length>0){
      tot = data[0]['cart_total'].toDouble();
    }
    setState(() {
      products=data;
      orderCount=orderC;
      loading=false;
      total = tot;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var tp=total.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart'
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          !loading ? Container(
              margin: EdgeInsets.only(left: 12.5,right: 12.5,top: 5,bottom: 5),
              child: Row(
                children: [
                  Text(
                    'Total :',
                    style: TextStyle(
                        fontSize: 25
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Rs $tp',
                        style: TextStyle(
                            fontSize: 25
                        ),
                      ),
                    ),
                  )
                ],
              )
          )
          :
              SizedBox(height: 0,)
          ,
          Expanded(
              child: !loading ? products.length>0 ?
              ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context,int index) {
                    var price = products[index]['product_price'].toString();
                    ConsumerApi con = new ConsumerApi();
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          border: Border.all(
                              width: 0.5,
                              color: Colors.green
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9))
                      ),
                      margin: EdgeInsets.only(left:12.5,right: 12.5,top: 15),
                      height: size.height/5,
                      width: size.width-25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: (size.width-25)/3,
                                child: Container(
                                  margin: EdgeInsets.only(left: 12.5,top: 12.5),
                                  width: ((size.width-25)/3)-12.5,
                                  height: ((size.width-25)/3)-12.5,
                                  child: Image.network(products[index]['product_image'],fit: BoxFit.fitWidth,),
                                ),
                              ),
                              Container(
                                width:(size.width-25)/3,
                                height:(size.height/5-((size.width-25)/3)-12.5),
                                //margin:EdgeInsets.only(left:12.5),
                                decoration: BoxDecoration(
                                  //color: Colors.white
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.5,top: 4.000005),
                                  child: Text(
                                    products[index]['shop_name'],
                                    style: TextStyle(
                                      fontSize: 19
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 2*(size.width-25-12)/3,
                                margin: EdgeInsets.only(top:12.5,left: 5),
                                child: ConstrainedBox(
                                  constraints : BoxConstraints(
                                    maxHeight: size.height/10,
                                  ),
                                  child: Text(
                                    products[index]['product_name'],
                                    style: TextStyle(
                                        fontSize: 25
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Container(
                                  height: size.height/35,
                                  decoration: BoxDecoration(
                                    //color: Colors.white
                                  ),
                                  //width: 2*(size.width-25-18)/3,
                                  margin: EdgeInsets.only(left:9,top:5),
                                  child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Rs $price',
                                          //textAlign: TextAlign.start,
                                        ),
                                      )
                                  )
                              ),
                              Expanded(
                                  child: Container(
                                    width: 2*(size.width-25-15)/3,
                                    alignment: Alignment.bottomRight,
                                    decoration: BoxDecoration(
                                      //color: Colors.white
                                    ),
                                    child: orderCount[products[index]['product_id']]==0 ? GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 11),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(Radius.circular(5))
                                        ),
                                        height: 29,
                                        width: 65,
                                        child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 5.5,right: 5.5,top: 1.5,bottom: 1.5),
                                              child: Text(
                                                'ADD',
                                                style: TextStyle(
                                                    color: Colors.grey[100]
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                      onTap: () async{
                                        //ordered+=1;
                                        con.addToCart(products[index]['product_id']);
                                        setState(() {
                                          //consumer
                                          orderCount[products[index]['product_id']]=orderCount[products[index]['product_id']]+1;
                                          total=total+products[index]['product_price'];
                                          //ordered[index]=ordered[index]+1;
                                        });
                                        //print(ordered[index]);
                                      },
                                    )
                                        :
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      width: size.width/3.5,
                                      decoration: BoxDecoration(
                                        //color: Colors.white
                                      ),
                                      margin: EdgeInsets.only(bottom: 11),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              height: size.width/14,
                                              width: size.width/14,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(size.width/28)),
                                                  color: Colors.blue
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () async{
                                              con.deleteFromCart(products[index]['product_id']);
                                              setState(() {
                                                orderCount[products[index]['product_id']]=orderCount[products[index]['product_id']]-1;
                                                total=total-products[index]['product_price'];
                                                //ordered[index]=ordered[index]-1;
                                              });
                                            },
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left:5,right: 5),
                                              height: size.width/14,
                                              width: size.width/7-10,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  border: Border.all(
                                                      color: Colors.green,
                                                      width: 0.25
                                                  )
                                              ),
                                              child: Center(
                                                child: Text(
                                                  orderCount[products[index]['product_id']].toString(),
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                              )
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              height: size.width/14,
                                              width: size.width/14,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(size.width/28)),
                                                  color: Colors.blue
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              con.addToCart(products[index]['product_id']);
                                              setState(() {
                                                orderCount[products[index]['product_id']]=orderCount[products[index]['product_id']]+1;
                                                total=total+products[index]['product_price'];
                                                //ordered[index]=ordered[index]+1;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                    ,
                                  )
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
              )
                  :
                  Center(
                    child: Text(
                      'Cart Is Empty !'
                    ),
                  )
                  : Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                )
              )
          ),
          !loading ? total >0 ?
              Container(
                //color: Colors.green[50],
                child: GestureDetector(
                    child : Container(
                      //color: Colors.green,
                        width: size.width-25,
                        height:size.height/21,
                        margin: EdgeInsets.only(bottom: 7.5,top: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7.5)),
                            color: Colors.green
                        ),
                        child: Center(
                          child: Text(
                            'Place Order and Pay',
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.green[50]
                            ),
                          ),
                        )
                    ),
                  onTap: () async {
                      var data = await con.checkAvalibility();
                      if(data['products'].length==0){
                        print(data);
                        var name = data['faulty']['product_name'];
                        Dialog errorDialog = Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: Container(
                            height: size.height/3,
                            width: size.width-50,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height/45,
                                ),
                                Image.network(data['faulty']['product_image'],height: size.height/7,width: size.height/7,fit: BoxFit.fitWidth,),
                                SizedBox(
                                  height: size.height/45,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left:25,right: 25),
                                  child: data['faulty']['product_quantity']==0 ?
                                  Center(
                                    child: Text(
                                      '$name is Out Of Stock !',
                                      style: TextStyle(
                                          fontSize: 29
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ) :
                                  Text(
                                    data['message'],
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 21
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                        return showDialog(context: context,builder: (BuildContext context) => errorDialog);
                      } else {
                        openCheckout();
                      }
                  },
                ),
              )
              : SizedBox(
            height: 0,
          )
              :
          SizedBox(
            height: 0,
          )
        ],
      ),
    );
  }
}
