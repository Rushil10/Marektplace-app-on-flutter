import 'package:flutter/material.dart';
import 'package:grocy/Screens/ShopScreens/Delivered.dart';
import 'package:grocy/Screens/ShopScreens/OutForDelivery.dart';

class DeliveryTabs extends StatefulWidget {
  @override
  _DeliveryTabsState createState() => _DeliveryTabsState();
}

class _DeliveryTabsState extends State<DeliveryTabs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Delivery Details'
        ),
      ),
      body: DefaultTabController(
        length: 2,
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
                            'Out For Delivery',
                            style: TextStyle(
                                fontSize: 15
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
             OutForDelivery(),
              Delivered()
            ]
          ),
        ),
      )
    );
  }
}
