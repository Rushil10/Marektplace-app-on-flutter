import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocy/Screens/ShopScreens/AddProduct.dart';
import 'package:grocy/Screens/ShopScreens/Components/ProductTile.dart';
import 'package:grocy/Screens/ShopScreens/DeliveryDetailsScreen.dart';
import 'package:grocy/Screens/ShopScreens/Profile.dart';

class BottomTabs extends StatefulWidget {
  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedIndex = 0;
  CupertinoTabController _tabController;
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    //AddProduct(),
    Navigator(
      onGenerateRoute: (home) {
        Widget page = AddProduct();
        if(home.name=='newProduct') page = ProductTile();
        if(home.name=='home') page = AddProduct();
        return MaterialPageRoute(builder: (_) => page);
      },
    ),
    Text(
      'Orders Placed',
      style: optionStyle,
    ),
    Text(
      'Orders out for delivery',
      style: optionStyle,
    ),
    ShopOwnerProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  GlobalKey<NavigatorState> currentNavigatorKey() {
    switch (_tabController.index) {
      case 0:
        return firstTabNavKey;
        break;
      case 1:
        return secondTabNavKey;
        break;
      case 2:
        return thirdTabNavKey;
        break;
      case 3:
        return fourthTabNavKey;
        break;
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: CupertinoTabScaffold(
          controller: _tabController,
          tabBar: CupertinoTabBar(
            backgroundColor: Colors.green,
            activeColor: Colors.white,
            inactiveColor: Colors.white60,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: 'Home',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Orders',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delivery_dining),
                label: 'Delivery',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.green,
              ),
            ],
          ),
          tabBuilder: (context,index) {
            switch(index) {
              case 0:
                return CupertinoTabView(
                    navigatorKey: firstTabNavKey,
                    builder: (context) {
                      return CupertinoPageScaffold(
                          child: AddProduct()
                      );
                    });
              case 1:
                return CupertinoTabView(
                    navigatorKey: secondTabNavKey,
                    builder: (context) {
                      return CupertinoPageScaffold(
                          child: ShopOwnerProfile()
                      );
                    });
              case 2:
                return CupertinoTabView(
                    navigatorKey: thirdTabNavKey,
                    builder: (context) {
                      return CupertinoPageScaffold(
                          child: DeliveryTabs()
                      );
                    });
              case 3:
                return CupertinoTabView(
                    navigatorKey: fourthTabNavKey,
                    builder: (context) {
                      return CupertinoPageScaffold(
                          child: ShopOwnerProfile()
                      );
                    });
              default: return CupertinoTabView(
                  navigatorKey: firstTabNavKey,
                  builder: (context){
                    return CupertinoPageScaffold(
                        child: AddProduct()
                    );
                  });
            }
          }
      ),
      onWillPop: () async {
        print("Back Pressed");
        return !await currentNavigatorKey().currentState.maybePop();
      },
    );
  }
}
