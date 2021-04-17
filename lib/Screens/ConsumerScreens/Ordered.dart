import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerOrderDetails.dart';
import 'package:grocy/Screens/signupFunctions.dart';
import 'package:grocy/consumer_api.dart';

class Ordered extends StatefulWidget {
  @override
  _OrderedState createState() => _OrderedState();
}

class _OrderedState extends State<Ordered> {
  var orders;
  var loading = true;
  ConsumerApi con = new ConsumerApi();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      loading=true;
    });
    var data = await con.getOrders();
    setState(() {
      orders=data;
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 5,right: 5),
      child: Column(
        children: [
          Expanded(
            child: !loading ?  orders.length >0 ?
            ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context,int index) {
                  var total = orders[index]['order_cart_total'];
                  var count = orders[index]['total_items'];
                  var ps = orders[index]['payment_status'];
                  var pm = orders[index]['payment_mode'];
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 9.5),
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.all(Radius.circular(7.5)),
                          border: Border.all(
                              color: Colors.green,
                              width: 0.5
                          )
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:EdgeInsets.only(left:0),
                                    child : MaterialButton(
                                      onPressed:() {},
                                      child: Text(
                                          orders[index]["order_cart_id"].toString()
                                      ),
                                      shape: CircleBorder(),
                                      color: Colors.green,
                                      padding: EdgeInsets.all(5),
                                      height: size.height/19,
                                      minWidth: 59,
                                    ),
                                  ),
                                  Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          //margin: EdgeInsets.only(right: 0),
                                          //alignment: Alignment.topRight,
                                          width: size.width/2.55,
                                          child: Text(
                                            'Total : Rs $total',
                                            style: TextStyle(
                                                fontSize: 16.5
                                            ),
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.green,
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      'Ordered Items : $count',
                                      style: TextStyle(
                                          fontSize: 16.5
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.green,
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      'Payment Mode : $pm',
                                      style: TextStyle(
                                          fontSize: 16.5
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ConsumerOrderDetails(
                          orders: orders[index],
                        );
                      }));
                    },
                  );
                }
            )
            :
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Orders Placed !'
                      )
                    ],
                  ),
                )
            :
            Center(
              child: CircularProgressIndicator(
                //valueColor: ,
              ),
            ),
          )
        ],
      )
    );
  }
}
