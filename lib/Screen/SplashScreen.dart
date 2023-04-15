import 'package:chet/Screen/HomePage.dart';
import 'package:chet/Screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checklogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("islogin"))
    {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
    else
    {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      checklogin();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea(
       child:Center(
     child: Container(
     alignment: Alignment.center,
       child: Image.asset("img/logo.jpg"),
       
    ),
     ),
    ),
    );
  }
}
