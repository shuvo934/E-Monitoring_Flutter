import 'package:e_monitoring/screens/home_page.dart';
import 'package:e_monitoring/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('EXIT',
                style: TextStyle(color: primaryVariant_spray)),
            content: Text(
              'Do you want to exit app?',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Yes")),
            ],
          ));
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: primaryVariant_spray,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Image.asset(
                          'images/bd_icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, top: 30, right: 10, bottom: 30),
                        child: Text(
                          'E-MONITORING',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RussoOne'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LOG IN AS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 10, top: 40, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        userType: 'GUEST',
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.account_box,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    Text(
                                      'GUEST',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginScreen.id);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.account_box,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    Text(
                                      'ADMIN',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
