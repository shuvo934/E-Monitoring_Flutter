import 'dart:async';

import 'package:e_monitoring/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_monitoring/utilities/constants.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return WelcomeScreen();
        }));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryVariant_spray,
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, top: 60, right: 10, bottom: 0),
                child: Image.asset(
                  'images/bd_icon.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 0),
                child: Text(
                  "E-MONITORING\n\nদুর্যোগ ব্যবস্থাপনা ও ত্রাণ মন্ত্রণালয়\nগণপ্রজাতন্ত্রী বাংলাদেশ সরকার",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin:
                    EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Version 1.0',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Developed by:',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                'images/ttit_new2.png',
                                width: 45,
                                height: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
