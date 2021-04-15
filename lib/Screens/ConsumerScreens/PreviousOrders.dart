import 'package:flutter/material.dart';
import 'package:grocy/Screens/ConsumerScreens/Delivered.dart';
import 'package:grocy/Screens/ConsumerScreens/Ordered.dart';
import 'package:grocy/Screens/ConsumerScreens/OutForDelivery.dart';

class PreviousOrders extends StatefulWidget {
  @override
  _PreviousOrdersState createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders'
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: new PreferredSize(
                  child: Container(
                    height: 45,
                    child: TabBar(
                      indicatorColor: Colors.grey,
                      indicatorWeight: 5,
                      tabs: [
                        Tab(
                            child: Container(
                              height:25,
                              child: Text(
                                'Ordered',
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                            )
                        ),
                        Tab(
                            child: Container(
                              height:25,
                              //width: 150,
                              child: Text(
                                'Out For Delivery',
                                style: TextStyle(
                                    fontSize: 12.9
                                ),
                              ),
                            )
                        ),
                        Tab(
                            child:Container(
                              height: 25,
                              child: Text(
                                'Delivered',
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                  preferredSize: Size(size.width,0 ))
          ),
          body: TabBarView(
              children: [
                Ordered(),
                OutForDelivery(),
                Delivered(),
              ]
          ),
        ),
      )
    );
  }
}
