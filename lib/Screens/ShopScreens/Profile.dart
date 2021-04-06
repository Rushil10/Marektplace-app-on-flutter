import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocy/Screens/Welcome/welcome_screen.dart';

class ShopOwnerProfile extends StatefulWidget {
  @override
  _ShopOwnerProfileState createState() => _ShopOwnerProfileState();
}

class _ShopOwnerProfileState extends State<ShopOwnerProfile> {
  static final kInitialPosition = LatLng(19.8567844, 72.213108);
  var apiKey='AIzaSyB1hSZ48f5wir9fhHtrNWV6yhVW0H0ZDck';
  LocationResult _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: TextButton(
                onPressed: () async{
                  final storage = new FlutterSecureStorage();
                  await storage.delete(key: 'user_token');
                  await storage.delete(key: 'shop_token');
                  Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()),(route) => false);
                },
                child: Text(
                    'Logout'
                ),
              ),
            ),
            Container(
              child: TextButton(
                onPressed: () async{
                  LocationResult result = await showLocationPicker(
                    context,
                    apiKey,
                    initialCenter: LatLng(31.1975844, 29.9598339),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                    myLocationButtonEnabled: true,
                    // requiredGPS: true,
                    layersButtonEnabled: true,
                    // countries: ['AE', 'NG']

//                      resultCardAlignment: Alignment.bottomCenter,
                    desiredAccuracy: LocationAccuracy.best,
                  );
                  print("result = $result");
                  setState(() => _pickedLocation = result);
                },
                child: Text(
                    'Maps Testing'
                ),
              ),
            ),
              Text(_pickedLocation.toString()),
          ],
        ),
      )
    );
  }
}
