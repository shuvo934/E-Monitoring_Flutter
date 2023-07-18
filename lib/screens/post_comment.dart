import 'dart:convert';

import 'package:e_monitoring/response/post_response.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PostComment extends StatefulWidget {
  static const String id = 'post_comment';

  final pcmID;

  PostComment(this.pcmID);

  @override
  State<PostComment> createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  bool nameEditMiss = false;
  bool emailEditMiss = false;
  bool commentEditMiss = false;

  String nameOfUser = "";
  String emailOfUser = "";
  String commentOfUser = "";

  bool conn = false;
  bool connected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //     padding: const EdgeInsets.all(12),
        //     child: Image.asset('images/bd_icon.png')),
        title: Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'NEW COMMENT',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'RussoOne'),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Name'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryVariant_spray, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary_dupain, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                onChanged: (value) {
                  nameOfUser = value;
                  if (nameEditMiss) {
                    if (nameOfUser.isNotEmpty) {
                      setState(() {
                        nameEditMiss = false;
                      });
                    }
                  }
                },
              ),
            ),
            Visibility(
              visible: nameEditMiss,
              child: Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Please Fill Out This Field",
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Email'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryVariant_spray, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary_dupain, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                onChanged: (value) {
                  emailOfUser = value;
                  if (emailEditMiss) {
                    if (emailOfUser.isNotEmpty) {
                      setState(() {
                        emailEditMiss = false;
                      });
                    }
                  }
                },
              ),
            ),
            Visibility(
              visible: emailEditMiss,
              child: Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Please Fill Out This Field",
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Comment'),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: primaryVariant_spray, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primary_dupain, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                onChanged: (value) {
                  commentOfUser = value;
                  if (commentEditMiss) {
                    if (commentOfUser.isNotEmpty) {
                      setState(() {
                        commentEditMiss = false;
                      });
                    }
                  }
                },
              ),
            ),
            Visibility(
              visible: commentEditMiss,
              child: Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Please Fill Out This Field",
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
                  )),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size(150, 40))),
                  onPressed: () {
                    setState(() {
                      if (nameOfUser.isNotEmpty) {
                        nameEditMiss = false;
                        if (emailOfUser.isNotEmpty) {
                          emailEditMiss = false;
                          if (commentOfUser.isNotEmpty) {
                            commentEditMiss = false;
                            _postPreAlertDialogue();
                          } else {
                            commentEditMiss = true;
                          }
                        } else {
                          emailEditMiss = true;
                        }
                      } else {
                        nameEditMiss = true;
                      }
                    });
                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _postPreAlertDialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Do you want to submit your comment?'),
              ],
            ),
          ),
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
                Navigator.of(context, rootNavigator: true).pop();
                postComment();
              },
            ),
          ],
        );
      },
    );
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
                Navigator.of(context, rootNavigator: true).pop();
                postComment();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _failedCommentDialogue() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Comment Submission Failed!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                postComment();
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
      content: Container(
        alignment: Alignment.center,
        child: const SpinKitFadingCircle(
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

  void postComment() async {
    showLoaderDialog(context);
    conn = false;
    connected = false;
    String postCommentUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/comments/uploadComments";
    http.Response response = await http.post(
      Uri.parse(postCommentUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pcm_id': widget.pcmID.toString(),
        'submitter_name': nameOfUser,
        'submiiter_email': emailOfUser,
        'submitter_message': commentOfUser,
      }),
      encoding: Encoding.getByName("utf-8"),
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      conn = true;
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String stringOut = PostResponse.fromJson(data).stringOut;
      if (stringOut == "Successfully Created") {
        connected = true;
        updateUI();
      } else {
        connected = false;
        updateUI();
      }
    } else {
      conn = false;
      updateUI();
      throw Exception('Failed to post comment.');
    }
  }

  void updateUI() {
    Navigator.pop(context);
    if (conn) {
      if (connected) {
        Fluttertoast.showToast(
          msg: 'Comment Submitted Successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      } else {
        _failedCommentDialogue();
      }
    } else {
      _noConnectionDialogue();
    }
  }
}
