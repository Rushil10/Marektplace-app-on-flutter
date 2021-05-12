import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocy/Screens/ConsumerScreens/ConsumerLocation.dart';
import 'package:grocy/consumer_api.dart';

class AllAddresses extends StatefulWidget {
  @override
  _AllAddressesState createState() => _AllAddressesState();
}

class _AllAddressesState extends State<AllAddresses> {
  ConsumerApi con = new ConsumerApi();
  var addresses = [];
  var loading = true;
  var selected_name = '';
  @override

  void initState() {
    getAllMyAddresses();
  }

  void addNewAddress(var address) {
    print(address);
    setState(() {
      loading=true;
    });
    var old = addresses;
    old.add(address);
    setState(() {
      addresses=old;
      loading=false;
    });
  }

  void getAllMyAddresses() async{
    setState(() {
      loading=true;
    });
    var data = await con.getMyAddresses();
    setState(() {
      addresses=data;
      loading=false;
    });
    print(data);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Address'
        ),
      ),
      body: SafeArea(
        child: Container(
          child: loading ?
              Text(
                'Loading'
              ) :
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: addresses.length,
                          itemBuilder: (BuildContext context,int index){
                          return Padding(
                              padding: EdgeInsets.all(9),
                              child: Container(
                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 0.75
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(7.5)),
                                  color: addresses[index]['address_name']==selected_name ? Colors.green[50] : null,
                                ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected_name=addresses[index]['address_name'];
                                  });
                                  print(selected_name);
                                },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text(
                                              addresses[index]['address_name'],
                                              style: TextStyle(
                                                  fontSize: 22.5
                                              ),
                                            ),)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            addresses[index]['consumer_address'],
                                            style: TextStyle(
                                                fontSize: 19
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            addresses[index]['consumer_state'],
                                            style: TextStyle(
                                                fontSize: 19
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                            )
                          );
                      }),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ConsumerLocationScreen(
                            addAddress: addNewAddress,
                            alreadyin: true,
                          );
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 7.5),
                        color: Colors.green,
                        width: size.width-18,
                        padding: EdgeInsets.all(9),
                        height: 45,
                        child: Center(
                          child: Text(
                            'Add New Address',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 21

                            ),
                          ),
                        )
                      ),
                    )
                  ],
                ),
              )
        ),
      )
    );
  }
}
