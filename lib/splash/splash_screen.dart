import 'dart:async';
import 'package:emailmil/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            Image.asset(
              "assets/images/img.png",
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 1),

            const Text(
              "TempMail App",
              style: TextStyle(
                fontFamily: 'Font',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 1),

            const Text(
              "Secure your identity with temporary emails\nfor private and safe signups",
              style: TextStyle(
                fontFamily: 'Font1',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 2),

            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 4.5,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: const Text(
                "Powered by:",
                style: TextStyle(
                  fontFamily: 'Font1',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: const Text(
                "Ali Hassan",
                style: TextStyle(
                  fontFamily: 'Font',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.
                right,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
