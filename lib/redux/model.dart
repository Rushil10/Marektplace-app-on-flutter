import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class shopDetails {
  var allShopDetails;
  shopDetails({this.allShopDetails});
}

class Product {
  int id;
  String name;
  String type;
  int qty;
  int price;

  Product({
    this.id,this.name,this.type,this.qty,this.price
  });

  Product copyWith({int id,String name,String type,int qty,int price}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      qty: qty ?? this.qty,
      price: price ?? this.price
    );
  }
}
/*
AppState appReducer(AppState state,action) => new AppState(
  shopDetailsReducer(state.shop, action),
);
*/
class AppState {
  List<dynamic> products;
  AppState({
    this.products
  });

  AppState.initialState() : products = List.unmodifiable([]);
}

shopDetailsReducer(shopDetails prevState,dynamic action) {
  print("Here");
  print(action);
  print(prevState);
  return prevState;
}