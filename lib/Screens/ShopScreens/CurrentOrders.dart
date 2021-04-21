import 'package:flutter/material.dart';
import 'package:grocy/Screens/ShopScreens/OrderDetailsPage.dart';
import 'package:grocy/consumer_api.dart';

class CurrentOrders extends StatefulWidget {
  @override
  _CurrentOrdersState createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  var info=[];
  var l_arr;
  var loading = true;
  ShopApi shop = new ShopApi();

  void initState() {
    // TODO: implement initState
    print("HEllo");
    getInfo();
    super.initState();
  }

  Future getInfo() async {
    setState(() {
      loading=true;
    });
    var data = await shop.getOrderedProducts();
    var list = new List<int>.generate(data.length, (i) => i*0);
    if(data.length>0) {
      setState(() {
        l_arr=list;
        info=data;
        loading=false;
      });
    } else {
      setState(() {
        loading=false;
      });
    }
  }

  void sendToOutForDelivery(index,id) async{
    await shop.updateDeliveryStatus(id);
    var prevList = info;
    prevList.removeAt(index);
    var list = new List<int>.generate(prevList.length, (i) => i*0);
    setState(() {
      l_arr=list;
      info=prevList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Orders'
        ),
        centerTitle: true,
      ),
      body:SafeArea(
        child: Column(
          children: [
            Expanded(
              child:  RefreshIndicator(
                child: loading ?
                Center(
                    child : new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                ) : info.length!=0 ?
                ListView.builder(
                    itemCount: info.length,
                    itemBuilder: (BuildContext context,int index) {
                      var price = info[index]["tota"].toString();
                      var pm = info[index]['payment_mode'].toString();
                      var ps = info[index]['payment_status'].toString();
                      var cc = info[index]['consumer_contact'].toString();
                      var ad = info[index]['consumer_address'].toString();
                      return GestureDetector(
                        child: Container(
                          //height: 525,
                            width: size.width,
                            margin: EdgeInsets.only(top: 15,left:5,right:5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green,
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(7.5)),
                              color: Colors.green[50]
                            ),
                            child:Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:EdgeInsets.only(left:0),
                                        child : MaterialButton(
                                          onPressed:() {},
                                          child: Text(
                                              info[index]["order_cart_id"].toString()
                                          ),
                                          shape: CircleBorder(),
                                          color: Colors.green,
                                          padding: EdgeInsets.all(5),
                                          height: size.height/19,
                                          minWidth: 59,
                                        ),
                                      ),
                                      Container(
                                        width: size.width-200,
                                        child: Text(
                                          info[index]["consumer_name"],
                                          style: TextStyle(
                                              fontSize: 16.5
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          //width: 100,
                                          child: Text(
                                            'Rs $price',
                                            style: TextStyle(
                                                fontSize: 16.5
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.green,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(left:11,top:5),
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
                                      margin: EdgeInsets.only(left:11,top:5),
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
                                      margin: EdgeInsets.only(left:11,top:5),
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
                                      margin: EdgeInsets.only(left:11,top:5),
                                      child: Text(
                                        'Contact Number : $cc',
                                        style: TextStyle(
                                          fontSize: 16.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                            color: Colors.green,
                                            width:(size.width-10)-12,
                                            height: 41,
                                            child: Center(
                                              child: l_arr[index]==0 ? Text(
                                                'Out For Delivery',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              ) :
                                              SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                                    strokeWidth: 2.5,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            l_arr[index]=1;
                                          });
                                          await sendToOutForDelivery(index,info[index]["order_cart_id"].toString());
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return OrderDetailsPage(
                              info: info[index],
                              index: index,
                              changeDeliveryStatus: sendToOutForDelivery,
                              bt: 'Out For Delivery',
                            );
                          }));
                        },
                      );
                    }
                )
                    :
                Stack(
                  children: <Widget>[ListView(),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Orders are Placed Currently !',
                            style: TextStyle(
                              fontSize: 19
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Text(
                            'Pull To Refresh, to Update',
                            style: TextStyle(
                              fontSize: 19
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
                onRefresh: getInfo,
                color: Colors.green,
              )
            ),
          ],
        )
      )
    );
  }
}
