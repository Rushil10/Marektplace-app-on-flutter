import 'package:flutter/material.dart';
import 'package:grocy/Screens/ShopSignup/ShopLocation.dart';
import 'package:grocy/components/RoundedInputNumberField.dart';
import 'package:grocy/components/rounded_button.dart';
import 'package:grocy/components/rounded_input_field.dart';

class ShopSignupScreen extends StatefulWidget {
  ShopSignupScreen({this.email,this.password});
  final email;
  final password;
  @override
  _ShopSignupScreenState createState() => _ShopSignupScreenState();
}

class _ShopSignupScreenState extends State<ShopSignupScreen> {
  var shopName;
  var ownerName;
  var shopContact;
  var area;
  var landmark;
  var upiId;
  var address;

  dynamic renderError(IconData icon,var message) {
    Size size = MediaQuery.of(context).size;
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Container(
        height: size.height/5,
        width: size.width-50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,size: 49,color: Colors.green,),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.grey
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
    return showDialog(context: context,builder: (BuildContext context) => errorDialog);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: RoundedInputField(
                        hintText: 'Shop Name',
                        icon: Icons.store,
                        onChanged: (value) {
                          shopName=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Shop Owner Name',
                        icon: Icons.person,
                        onChanged: (value) {
                          ownerName=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputNumberField(
                        hintText: 'Shop Contact',
                        icon:Icons.phone,
                        onChanged: (value) {
                          shopContact=value;
                        },
                      )
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Area',
                        icon: Icons.location_city,
                        onChanged: (value) {
                          area=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Landmark',
                        icon: Icons.location_on,
                        onChanged: (value) {
                          landmark=value;
                        },
                      ),
                    ),
                    Container(
                      child: RoundedInputField(
                        hintText: 'Shop UPI Id',
                        icon: Icons.payment,
                        onChanged: (value) {
                          upiId=value;
                        },
                      ),
                    ),
                    RoundedButton(
                      text: 'SIGNUP',
                      press: () async {
                        if(shopName==null){
                          return renderError(Icons.store_mall_directory_rounded, 'Shop name must not be empty');
                        }
                        if(ownerName==null){
                          return renderError(Icons.person, 'Shop owner Name is mandatory !');
                        }
                        if(shopContact==null){
                          return renderError(Icons.call, 'Contact number mst be provided');
                        }
                        if(area==null){
                          return renderError(Icons.location_city, 'Area must not be empty');
                        }
                        if(landmark==null){
                          return renderError(Icons.location_on, 'Landmark must not be empty');
                        }
                        if(shopContact.toString().length>10 || shopContact.toString().length<7){
                          return renderError(Icons.call, 'Contact number cannot be greater than 10 and less than 7');
                        }
                        address = area + ', ' + landmark ;
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ShopLocationScreen(
                            email: widget.email,
                            password: widget.password,
                            shopName: shopName,
                            shopContact: shopContact,
                            address: address,
                            ownerName: ownerName,
                            upiId: upiId,
                          );
                        }));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
