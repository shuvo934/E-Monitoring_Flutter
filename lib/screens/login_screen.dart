import 'package:e_monitoring/lists/users.dart';
import 'package:e_monitoring/response/api_response.dart';
import 'package:e_monitoring/screens/home_page.dart';
import 'package:e_monitoring/services/networking.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  static List<Users> userLists = [];

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool checked = false;
  String email = "";
  String password = "";
  bool conn = false;
  bool userFound = false;

  String? getUserName;
  String? getPassword;
  bool? getChecked;

  bool emailPassInvalid = false;
  String contactEmail = Uri.encodeComponent("info@techterrain-it.com");

  final String adminUserEmail = "admin_emailKey";
  final String adminPassword = "admin_passKey";
  final String remembered = "rememberedKey";
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.white;
  }

  void getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    getUserName = preferences.getString(adminUserEmail);
    getPassword = preferences.getString(adminPassword);
    getChecked = preferences.getBool(remembered);

    if (getUserName != null && getPassword != null && getChecked != null) {
      setState(() {
        email = getUserName!;
        password = getPassword!;
        checked = getChecked!;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryVariant_spray,
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 10, top: 80, right: 10, bottom: 10),
                child: Image.asset(
                  'images/bd_icon.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 10, top: 25, right: 10, bottom: 10),
                child: Text(
                  'E-MONITORING',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'RussoOne'),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 70, right: 20, bottom: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                  controller: TextEditingController(text: email),
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 0),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureText,
                  decoration: kTextFieldDecoration
                      .copyWith(hintText: 'Password')
                      .copyWith(
                          suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),
                  controller: TextEditingController(text: password),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5, top: 5, right: 10, bottom: 0),
                alignment: AlignmentDirectional.centerStart,
                child: CheckboxListTile(
                  title: Text(
                    'Remember Me',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  checkColor: primaryVariant_spray,
                  activeColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                  value: checked,
                  controlAffinity: ListTileControlAffinity.leading,
                  //fillColor: MaterialStateProperty.resolveWith(getColor),
                  onChanged: (value) {
                    setState(() {
                      checked = value!;
                    });
                  },
                ),
              ),
              Visibility(
                visible: emailPassInvalid,
                child: const Text(
                  'INVALID USER!!',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 20, top: 25, right: 20, bottom: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40),
                    primary: Color(0xff60a3bc),
                  ),
                  onPressed: () {
                    loginButtonAction();
                  },
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
                child: const Text(
                  'Could not Login?',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
                child: TextButton(
                  onPressed: () {
                    mailDialog(context);
                  },
                  child: const Text(
                    'Contact Here',
                    style: TextStyle(
                        color: Color(0xff60a3bc),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginButtonAction() {
    setState(() {
      emailPassInvalid = false;
    });
    if (!email.isEmpty && !password.isEmpty) {
      getUserFromServer();
    } else {
      Fluttertoast.showToast(
        msg: 'Please Give Email and Password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void getUserFromServer() async {
    showLoaderDialog(context);
    conn = false;
    userFound = false;
    String getUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/admin_users/admin_login/" +
            email +
            "/" +
            password;
    NetworkHelper networkHelper = NetworkHelper(getUrl);
    var userData = await networkHelper.getData();
    if (userData != null) {
      conn = true;
      ApiResponse userResponse = ApiResponse.fromJson(userData);
      int count = userResponse.count;

      if (count != 0) {
        userFound = true;
        // var name = userData['items'][0]['name'];
        // var email = userData['items'][0]['email'];
        // var id = userData['items'][0]['id'];
        for (int i = 0; i < userResponse.items.length; i++) {
          var id = userResponse.items[i]['id'];
          String name = userResponse.items[i]['name'];
          String e_mail = userResponse.items[i]['email'];
          Users users = Users(id, name, e_mail);
          LoginScreen.userLists = [users];
        }
        updateInterface();
      } else {
        userFound = false;
        updateInterface();
      }
    } else {
      conn = false;
      updateInterface();
    }
  }

  void updateInterface() async {
    Navigator.pop(context);
    if (conn) {
      if (userFound) {
        print(LoginScreen.userLists[0].name);
        if (checked) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove(adminUserEmail);
          preferences.remove(adminPassword);
          preferences.remove(remembered);
          preferences.setString(adminUserEmail, email);
          preferences.setString(adminPassword, password);
          preferences.setBool(remembered, checked);
        } else {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove(adminUserEmail);
          preferences.remove(adminPassword);
          preferences.remove(remembered);
        }

        Fluttertoast.showToast(
          msg: 'Login Successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userType: 'ADMIN',
            ),
          ),
        );
      } else {
        setState(() {
          emailPassInvalid = true;
        });
      }
    } else {
      _noConnectionDialogue();
    }
  }

  Future<void> _noConnectionDialogue() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Please Check Your Internet Connection!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                getUserFromServer();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showLoaderDialog(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: new Container(
        alignment: Alignment.center,
        child: SpinKitFadingCircle(
          color: Colors.white,
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> mailDialog(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      elevation: 0,
      content: Text('Do you want to send an Email to info@techterrain-it.com?'),
      actions: [
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            sendMail();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void sendMail() async {
    Uri mail = Uri.parse("mailto:$contactEmail");
    if (await launchUrl(mail)) {
      //email app opened
      print('Opened');
    } else {
      //email app is not opened
      Fluttertoast.showToast(
        msg: 'Could not open Mail app!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
