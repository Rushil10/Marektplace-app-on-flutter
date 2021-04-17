import 'package:flutter/material.dart';
import 'package:grocy/consumer_api.dart';

class ConsumerOrderDetails extends StatefulWidget {
  @override
  final orders;
  ConsumerOrderDetails({this.orders});
  _ConsumerOrderDetailsState createState() => _ConsumerOrderDetailsState();
}

class _ConsumerOrderDetailsState extends State<ConsumerOrderDetails> {
  var loading = true;
  var products ;
  ConsumerApi con = new ConsumerApi();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  void getProducts() async{
    setState(() {
      loading=true;
    });
    var data = await con.getOrderDetails(widget.orders['order_cart_id']);
    setState(() {
      products=data;
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var total = widget.orders['order_cart_total'];
    var ps = widget.orders['payment_status'];
    var pm = widget.orders['payment_mode'];
    var count = widget.orders['total_items'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details'
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5),
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
                          widget.orders["order_cart_id"].toString()
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
              Divider(
                color: Colors.green,
              ),
              !loading ?
                  ListView.builder(
                      itemCount: products.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,int index) {
                        var price = products[index]['product_price'];
                        var quantity = products[index]['quantity'];
                        var total = products[index]['total'];
                        var ds = products[index]['delivery_status'];
                        var shop_name = products[index]['shop_name'];
                        var pas = products[index]['payment_status'];
                        return Container(
                          margin: EdgeInsets.only(top:9),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(
                              color: Colors.green,
                              width: 0.75
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(7.5))
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin:EdgeInsets.only(right:5),
                                      child: Image.network(products[index]['product_image'],height: size.width/3.255,width: size.width/3.255,fit: BoxFit.fitWidth,),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width:size.width/2,
                                          child: Text(
                                            products[index]['product_name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 19
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width:size.width/2,
                                          child: Text(
                                            'Price : Rs $price',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 19
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: size.width/2,
                                          child: Text(
                                            'Quantity : $quantity',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 19
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: size.width/2,
                                          child: Text(
                                            'Total : $total',
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 19
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Divider(
                                  color: Colors.green,
                                ),
                                Container(
                                  width: size.width-20,
                                  child: Text(
                                    'Delivery Status : $ds',
                                    style: TextStyle(
                                      fontSize: 16.9
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.green,
                                ),
                                Container(
                                  width: size.width-20,
                                  child: Text(
                                    'Payment Status : $pas',
                                    style: TextStyle(
                                        fontSize: 16.9
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.green,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: size.width-59,
                                      child: Text(
                                        shop_name,
                                        style: TextStyle(
                                            fontSize: 16.9
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.grey,
                                      size: 25,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        );
                      }
                  )
                  :
                  Text(
                    'Loading'
                  )
            ],
          )
        ),
      ),
    );
  }
}
