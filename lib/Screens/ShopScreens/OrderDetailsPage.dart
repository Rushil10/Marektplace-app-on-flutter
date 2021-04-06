import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocy/Screens/Location/ConsumerLocationScreen.dart';
import 'package:grocy/consumer_api.dart';

class OrderDetailsPage extends StatefulWidget {
  final info;
  OrderDetailsPage({this.info});
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  ShopApi shop = new ShopApi();
  var orders = [];
  bool loading = true;

  @override
  void initState() {
    getOrders();
    // TODO: implement initState
    super.initState();
  }

  void getOrders() async {
    var data = await shop.getOrders(widget.info['order_cart_id']);
    if(data.length>0){
      setState(() {
        orders=data;
        loading=false;
      });
      print(orders);
    } else {
      setState(() {
        loading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var price = widget.info['order_cart_total'].toString();
    var pm = widget.info['payment_mode'].toString();
    var ps = widget.info['payment_status'].toString();
    var cc = widget.info['consumer_contact'].toString();
    var ad = widget.info['consumer_address'].toString();
    var email = widget.info['consumer_email'].toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details'
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:Container(
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height/11,
                    width: size.height/11,
                    margin:EdgeInsets.only(left:0,top:0),
                    child : Center(
                      child: Text(
                        widget.info['order_cart_id'].toString(),
                        style: TextStyle(
                            fontSize: 29
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(size.height/22))
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                          widget.info['consumer_name'],
                          style: TextStyle(
                              fontSize: 22.5
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        child: Text(
                          'Rs $price',
                          style: TextStyle(
                              fontSize: 22.5
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left:5,top:5),
                  child: Text(
                    'Payment Mode : $pm',
                    style: TextStyle(
                      fontSize: 16.5,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left:5,top:5),
                  child: Text(
                    'Payment Status : $ps',
                    style: TextStyle(
                      fontSize: 16.5,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left:5,top:5),
                  child: Text(
                    'Address : \n'
                        '$ad',
                    style: TextStyle(
                      fontSize: 16.5,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left:5,top:5),
                  child: Text(
                    'Contact Number : $cc',
                    style: TextStyle(
                      fontSize: 16.5,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left:5,top:5),
                  child: Text(
                    'Email : $email',
                    style: TextStyle(
                      fontSize: 16.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
