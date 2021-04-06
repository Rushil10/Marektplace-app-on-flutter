import 'package:flutter/material.dart';
import 'package:grocy/consumer_api.dart';
class AddProductAction {
  static int _id = 0;
  int num;
  var productsData;
  AddProductAction(this.productsData){
    _id++;
  }
  int get id => _id;
}