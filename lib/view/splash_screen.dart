import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cubit_metal/main.dart';

class SplashScreenPage extends StatefulWidget {
  //const SplashScreenPage({ Key? key }) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState(){
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ListMetalPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Image.asset(
          "assets/images/metal_simple.png",
          width: 200.0,
          height: 100.0,
        ),
      ),
    );
  }
  
}