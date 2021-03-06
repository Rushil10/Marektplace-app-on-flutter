import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocy/consumer_api.dart';

class ShopProducts extends StatefulWidget {
  @override
  final shop;
  ShopProducts({this.shop});
  _ShopProductsState createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  var loading = true;
  var ordered = [];
  var pl=[];
  var products;
  var showSearch=false;
  var st = '';
  var bp = [];
  var orderCount = new Map();
  @override
  void initState() {
    // TODO: implement initState
    getAllProducts();
    super.initState();
  }

  void getAllProducts() async{
    setState(() {
      loading=true;
    });
    ConsumerApi consumer = new ConsumerApi();
    var data = await consumer.getShopProducts(widget.shop['shop_id']);
    print(data);
    var orderC = new Map();
    for(int i=0;i<data.length;i++){
      orderC[data[i]['product_id']]=0;
    }
    setState(() {
      orderCount=orderC;
      products=data;
      bp=data;
      ordered=List.generate(products.length, (index) => index*0);
      pl=List.generate(products.length, (index) => index*0);
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.shop['shop_name']
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(
            Icons.search,
            size: 29,
          ),
              onPressed: () {
            if(showSearch){
              setState(() {
                products=bp;
              });
            }
                  setState(() {
                    showSearch=!showSearch;
                  });
              })
        ],
      ),
      body: Column(
        children: [
          showSearch ? Container(
            margin: EdgeInsets.only(left: 12.5,right: 12.5,top: 5),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 9),
                //border: InputBorder.none
              ),
              style: TextStyle(
                fontSize: 19
              ),
              onChanged: (val) {
                setState(() {
                  st=val;
                });
                print(st.length);
                if(st.length==0){
                  setState(() {
                    loading=true;
                    products=bp;
                    loading=false;
                  });
                } else {
                  var items = bp.where((element) => element['product_name'].toString().toLowerCase().contains(st.toLowerCase())).toList();
                  setState(() {
                    loading=true;
                    products=items;
                    loading=false;
                  });
                }
              },
            ),
          ) : Container(
            height: 0,
          ),
          Expanded(
              child: !loading ? products.length > 0 ?
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
                          Container(
                            width: (size.width-25)/3,
                            child: Container(
                              margin: EdgeInsets.only(left: 12.5,top: 12.5),
                              width: ((size.width-25)/3)-12.5,
                              height: ((size.width-25)/3)-12.5,
                              child: Image.network(products[index]['product_image'],fit: BoxFit.fitWidth,),
                            ),
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
                                          ordered[index]=ordered[index]+1;
                                        });
                                        print(ordered[index]);
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
                                                ordered[index]=ordered[index]-1;
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
                                                ordered[index]=ordered[index]+1;
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
                  child : Text(
                      'No Products Available !'
                  )
              )
                  :
              Center(
                child: Text(
                    'Loading'
                ),
              )
          ),
        ],
      ),
    );
  }
}
