import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/ShopScreens/Components/ProductTile.dart';
import 'package:grocy/Screens/ShopScreens/Components/UpdateProduct.dart';
import 'package:grocy/Screens/Welcome/welcome_screen.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/redux/actions.dart';
import 'package:grocy/redux/model.dart';
import 'package:redux/redux.dart';
import 'package:grocy/consumer_api.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool get wantKeepAlive => true;
  ShopApi shop = ShopApi();
  var allProducts = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
    print("Getting Products");
    //print(allProducts);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getProducts() async {
    setState(() {
      loading=true;
    });
    var allProduct = await shop.getProducts();
    print(allProduct.length);
    if(allProduct.length!=0){
      setState(() {
        allProducts=allProduct;
        loading=false;
      });
    } else {
      setState(() {
        //allProducts=allProduct;
        loading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StoreConnector<AppState,_ViewModel>(
        //onInit: (store) => store.dispatch(new AddProduct(allProducts)),
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context,_ViewModel viewModel) => Container(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  child: TextButton(
                    onPressed: () async{
                      final storage = new FlutterSecureStorage();
                      allProducts = await shop.getProducts();
                      viewModel.onAddProduct(allProducts);
                      print("H");
                      print(viewModel.products);
                    },
                    child: Text(
                        'Redux Testing'
                    ),
                  ),
                ),
                Container(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                          side: BorderSide(color:Colors.green)
                        ),
                      ),
                    ),
                    child: Container(
                      width: size.width-25,
                      height: size.height/21,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_box_outlined,
                            color: Colors.white,
                              size: size.height/22.5,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Text(
                                'Add New Product',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height/41,
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    onPressed: () {
                      //Navigator.push(context, ProductTile())
                      Navigator.push(context, CupertinoPageRoute(builder: (context) {
                        return ProductTile();
                      }));
                    },
                  ),
                ),
                Expanded(
                    child : loading ? Center(
                      child : new CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    )
                        : allProducts.length!=0 ?
                    ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allProducts.length,
                      itemBuilder: (context,index) {
                        final item = allProducts[index];
                        print(item);
                        final name = item["product_name"];
                        print(name);
                        final qty = item['product_quantity'];
                        final price = item['product_price'].toString();
                        final image = item['product_image'].toString();
                        final id = item['product_id'].toString();
                        final type = "packaged";
                        return Card(
                          margin: EdgeInsets.fromLTRB(7, 12.5, 7, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          elevation: 5,
                          child: ListTile(
                              leading: Image.network(image,fit: BoxFit.contain,),
                              title: Text(
                                  name
                              ),
                              subtitle: Text(
                                  'Quantity : $qty'
                              ),
                              trailing: Text(
                                  'Rs $price'
                              ),
                              onTap: () {
                                print("Update Product Page");
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return UpdateProduct(
                                    name: name,
                                    qty: qty,
                                    price: price,
                                    type: type,
                                    url: image,
                                    id: id,
                                  );
                                }));
                              },
                          ),
                        );
                      },
                    ) :
                        Container(
                          child: Center(
                            child :Text(
                              'Add Products',
                              style: TextStyle(
                                fontSize: 41,
                                color: Colors.green
                              ),
                            )
                          ),
                        )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  List<dynamic> products;
  Function(dynamic) onAddProduct;

  _ViewModel({
    this.products,
    this.onAddProduct,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(var productsData) {
      store.dispatch(AddProductAction(productsData));
    }

    return _ViewModel(
      products: store.state.products,
      onAddProduct: _onAddItem,
    );
  }
}
