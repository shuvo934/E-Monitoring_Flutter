import 'package:e_monitoring/screens/home_page.dart';
import 'package:e_monitoring/screens/post_comment.dart';
import 'package:e_monitoring/screens/project_details.dart';
import 'package:e_monitoring/screens/projects.dart';
import 'package:e_monitoring/screens/projects_with_map.dart';
import 'package:e_monitoring/screens/three_sixty_image.dart';
import 'package:e_monitoring/screens/welcome_screen.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:e_monitoring/screens/loading_screen.dart';
import 'package:flutter/services.dart';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primary_dupain,
          primaryContainer: primaryVariant_spray,
          secondary: primary_dupain,
          secondaryContainer: primaryVariant_spray,
        ),
      ),
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomePage.id: (context) => HomePage(),
        Projects.id: (context) => Projects(),
        ThreeSixtyIMage.id: (context) => ThreeSixtyIMage(),
      },
    );
  }
}
