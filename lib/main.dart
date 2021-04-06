import 'package:b_wishes/pages/list.dart';
import 'package:b_wishes/pages/walk_through.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B_wish',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: primarySnowColor,
        primaryColor: primaryPinkColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Noto Sans',
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: HomeFire(),
    );
  }
}
