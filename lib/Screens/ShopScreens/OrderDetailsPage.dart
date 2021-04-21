import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocy/Screens/Location/ConsumerLocationScreen.dart';
import 'package:grocy/consumer_api.dart';

class OrderDetailsPage extends StatefulWidget {
  final info;
  final Function changeDeliveryStatus;
  final index;
  final bt;
  OrderDetailsPage({this.info,this.changeDeliveryStatus,this.index,this.bt});
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  ShopApi shop = new ShopApi();
  var orders = [];
  bool loading = true;
  var pressed = 0;
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
  
  String renderText(ds){
    print(ds);
    if(ds=='pending'){
      return 'Out For Delivery';
    } else if(ds == 'Out For Delivery') {
      return 'Delivered';
    } else {
      return 'Not Yet Dispatched';
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Status of Delivery'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('If you have by mistakely updated the status of order to delivered, click on Change Status to undo it!\n\nThis will also change the payment status to pending if the payment type was cod'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Change Status'),
              onPressed: () async{
                await widget.changeDeliveryStatus(widget.index,widget.info['order_cart_id'].toString());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String gT() {
    if(widget.bt=='Change Status To Delivered'){
      return 'Updated Status To Delivered';
    } else {
      return 'Updated Status to Out For Delivery';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var price = widget.info['tota'].toString();
    var pm = widget.info['payment_mode'].toString();
    var ps = widget.info['payment_status'].toString();
    var cc = widget.info['consumer_contact'].toString();
    var ad = widget.info['consumer_address'].toString();
    var email = widget.info['consumer_email'].toString();
    var deliveryStatus = widget.info['delivery_status'].toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details'
        ),
        centerTitle: true,
        actions: [
          widget.bt=='Not Yet Dispatched' ?
              IconButton(icon:Icon(
                Icons.help
              ), onPressed: () async {
                _showMyDialog();
              })
              :
              Text(
                ''
              )
        ],
      ),
      body: SingleChildScrollView(
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
              !loading ? ListView.builder(
                scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context,int index) {
                  var image = orders[index]['product_image'];
                  var qty = orders[index]['quantity'];
                  var type = orders[index]['product_type'];
                  var price = orders[index]['product_price'];
                  var total = orders[index]['total'];
                    return Container(
                      margin: EdgeInsets.only(left:5,top:15,right:5),
                      //height: size.height/4.005,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 1.25
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(7.5)),
                        color: Colors.green[50]
                      ),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(5.0),
                                child: Container(
                                  height:size.height/12.5,
                                  width: size.height/12.5,
                                  child: Image.network(image,fit: BoxFit.contain,),
                                ),
                              ),
                              SizedBox(
                                width: 7.5,
                              ),
                              Text(
                                orders[index]['product_name'],
                                style: TextStyle(
                                  fontSize: 19
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.green,
                          ),
                          Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              child: Text(
                                'Quantity : $qty',
                                style: TextStyle(
                                  fontSize: 16.5
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              child: Text(
                                'Price : $price',
                                style: TextStyle(
                                    fontSize: 16.5
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              child: Text(
                                'Total : $total',
                                style: TextStyle(
                                    fontSize: 16.5
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              child: Text(
                                'Type : $type',
                                style: TextStyle(
                                    fontSize: 16.5
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    );
                  }
              ) : Text(
                'Loading'
              ),
              SizedBox(
                height: 15,
              ),
              !loading ? widget.bt!='Not Yet Dispatched' ?
              pressed==0?
              GestureDetector(
                child: Container(
                  height: 45,
                  width: size.width,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      widget.bt,
                      style: TextStyle(
                          fontSize: 19
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  await widget.changeDeliveryStatus(widget.index,widget.info['order_cart_id'].toString());
                  setState(() {
                    pressed=1;
                  });
                },
              )
              :
                  Container(
                    margin: EdgeInsets.only(top: 15,left: 15,),
                    child: Text(
                      gT(),
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.green
                      ),
                    ),
                  )
                  :
                  Text(
                    ''
                  ):
              Text(
                ''
              ),
              SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
