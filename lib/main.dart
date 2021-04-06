import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocy/Screens/Welcome/welcome_screen.dart';
import 'package:grocy/constants.dart';
import 'package:grocy/redux/model.dart';
import 'package:grocy/redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
as location_picker;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  //final Store<AppState> _store = Store(appReducer, initialState: AppState(new shopDetails()),);
  runApp(MyApp());
}

class CheckingScreen extends StatefulWidget {
  @override
  _CheckingScreenState createState() => _CheckingScreenState();
}

class _CheckingScreenState extends State<CheckingScreen> {
  @override
  void initState() async{
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: 'user_token');
    print(token);
  }
  Widget build(BuildContext context) {
    return Container();
  }
}


class MyApp extends StatelessWidget {
  /*
  final Store<AppState> store;
  MyApp({this.store});
   */

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [thunkMiddleware]
    );
    return StoreProvider(store: store,
        child:MaterialApp(
          localizationsDelegates: const[
            location_picker.S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Flutter Auth',
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: WelcomeScreen(),
        ),
    );
  }
}
