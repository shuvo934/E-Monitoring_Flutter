import 'dart:core';
import 'package:e_monitoring/lists/district.dart';
import 'package:e_monitoring/lists/divisions.dart';
import 'package:e_monitoring/lists/financial_years.dart';
import 'package:e_monitoring/lists/location_lists.dart';
import 'package:e_monitoring/lists/project_lists.dart';
import 'package:e_monitoring/lists/project_map_lists.dart';
import 'package:e_monitoring/lists/project_sub_type.dart';
import 'package:e_monitoring/lists/project_type.dart';
import 'package:e_monitoring/lists/source_of_fund.dart';
import 'package:e_monitoring/lists/union.dart';
import 'package:e_monitoring/lists/upazila.dart';
import 'package:e_monitoring/response/api_response.dart';
import 'package:e_monitoring/screens/login_screen.dart';
import 'package:e_monitoring/screens/projects.dart';
import 'package:e_monitoring/screens/projects_with_map.dart';
import 'package:e_monitoring/services/networking.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  final userType;
  static List<ProjectLists> projectLists = [];
  static List<ProjectMapLists> projectMapLists = [];

  HomePage({this.userType});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool conn = false;
  String userName = "";
  bool isButtonEnabled = false;
  bool afterYearSelection = false;
  bool logOutVisibility = false;
  bool searchMapVisibility = false;

  List<FinancialYears> fyStart = [];
  List<FinancialYears> fyEnd = [];
  List<DropdownMenuItem> fyStartDropDownLists = [];
  List<DropdownMenuItem> fyEndDropDownLists = [];
  String fysId = "";
  String fyeId = "";

  List<Divisions> divisionLists = [];
  List<DropdownMenuItem> divisionDropDownLists = [];
  String divId = "";

  List<SourceOfFund> fundLists = [];
  List<DropdownMenuItem> fundDropDownLists = [];
  String fsmId = "";
  final GlobalKey<FormFieldState> _fundKey = GlobalKey<FormFieldState>();

  List<ProjectType> projectTypeLists = [];
  List<DropdownMenuItem> pTypeDropDownLists = [];
  String ptmId = "";
  final GlobalKey<FormFieldState> _ptmKey = GlobalKey<FormFieldState>();

  List<District> districtLists = [];
  List<DropdownMenuItem> disDropDownLists = [];
  String distId = "";
  final GlobalKey<FormFieldState> _distKey = GlobalKey<FormFieldState>();

  List<Upazila> upazilaLists = [];
  List<DropdownMenuItem> upaDropDownLists = [];
  String ddId = "";
  final GlobalKey<FormFieldState> _upaKey = GlobalKey<FormFieldState>();

  List<Union> unionLists = [];
  List<DropdownMenuItem> unionDropDownLists = [];
  String dduId = "";
  final GlobalKey<FormFieldState> _uniKey = GlobalKey<FormFieldState>();

  List<ProjectSubType> projectSubTypeLists = [];
  List<DropdownMenuItem> ptdDropDownLists = [];
  String ptdId = "";
  final GlobalKey<FormFieldState> _ptdKey = GlobalKey<FormFieldState>();

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'LOG OUT!',
              style: TextStyle(color: primaryVariant_spray),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text(
                    'Do you want to Log Out?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  LoginScreen.userLists.clear();
                  LoginScreen.userLists = [];
                  Navigator.pop(context, true);
                },
              ),
            ],
          ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userType);
    if (widget.userType == "GUEST") {
      userName = widget.userType;
      logOutVisibility = false;
      searchMapVisibility = false;
    } else if (widget.userType == "ADMIN") {
      userName = LoginScreen.userLists[0].name;
      logOutVisibility = true;
      searchMapVisibility = true;
    }

    Future.delayed(Duration.zero, () {
      getFinancialYearData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback? searchOnPress = isButtonEnabled
        ? () {
            getProjectData();
          }
        : null;
    final VoidCallback? searchMapOnPress = isButtonEnabled
        ? () {
            getProjectMapData();
          }
        : null;
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop;
        if (widget.userType == "GUEST") {
          shouldPop = true;
        } else if (widget.userType == 'ADMIN') {
          shouldPop = await showWarning(context);
        }
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: EdgeInsets.all(12),
              child: Image.asset('images/bd_icon.png')),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'E-MONITORING',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RussoOne'),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Visibility(
                visible: logOutVisibility,
                child: GestureDetector(
                    onTap: () {
                      if (widget.userType == "GUEST") {
                        Navigator.pop(context);
                      } else if (widget.userType == 'ADMIN') {
                        _logOutDialogue();
                      }
                    },
                    child: Icon(Icons.power_settings_new)),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5, left: 10, bottom: 5, right: 10),
                                child: Text(
                                  'WELCOME,',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5, left: 10, bottom: 5, right: 10),
                                child: Text(
                                  userName,
                                  style: TextStyle(
                                      color: primary_dupain,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'RussoOne'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Text(
                        'Search Projects List & Details',
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontFamily: 'CantoraOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Financial Year(start)'),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: primaryVariant_spray, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: primaryVariant_spray, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: primaryVariant_spray, width: 2.0),
                          ),
                        ),
                        items: fyStartDropDownLists,
                        onChanged: (dynamic? value) {
                          fysId = value.toString();
                          if (fyeId.isNotEmpty) {
                            setState(() {
                              afterYearSelection = true;
                              if (fysId.isNotEmpty &&
                                  fyeId.isNotEmpty &&
                                  divId.isNotEmpty &&
                                  distId.isNotEmpty) {
                                isButtonEnabled = true;
                              } else {
                                isButtonEnabled = false;
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 8, right: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Financial Year(end)'),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: primaryVariant_spray, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: primaryVariant_spray, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: primaryVariant_spray, width: 2.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 2.0),
                          ),
                        ),
                        items: fyEndDropDownLists,
                        onChanged: (dynamic? value) {
                          fyeId = value.toString();
                          if (fysId.isNotEmpty) {
                            setState(() {
                              afterYearSelection = true;
                              if (fysId.isNotEmpty &&
                                  fyeId.isNotEmpty &&
                                  divId.isNotEmpty &&
                                  distId.isNotEmpty) {
                                isButtonEnabled = true;
                              } else {
                                isButtonEnabled = false;
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: afterYearSelection,
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 8, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: 2.5,
                                    ),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        label: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Division',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '*',
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.black38,
                                              width: 2.0),
                                        ),
                                      ),
                                      items: divisionDropDownLists,
                                      onChanged: (dynamic? value) {
                                        divId = value.toString();

                                        disDropDownLists = [];
                                        distId = "";
                                        _distKey.currentState?.reset();

                                        upaDropDownLists = [];
                                        ddId = "";
                                        _upaKey.currentState?.reset();

                                        unionDropDownLists = [];
                                        dduId = "";
                                        _uniKey.currentState?.reset();

                                        if (divId.isNotEmpty &&
                                            fysId.isNotEmpty &&
                                            fyeId.isNotEmpty &&
                                            distId.isNotEmpty) {
                                          isButtonEnabled = true;
                                        } else {
                                          isButtonEnabled = false;
                                        }

                                        getDistricts();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 2.5,
                                    ),
                                    child: DropdownButtonFormField(
                                      key: _distKey,
                                      decoration: InputDecoration(
                                        enabled: (disDropDownLists.length != 0)
                                            ? true
                                            : false,
                                        label: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'District',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '*',
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 2.0),
                                        ),
                                      ),
                                      items: disDropDownLists,
                                      onChanged: (dynamic? value) {
                                        distId = value.toString();

                                        upaDropDownLists = [];
                                        ddId = "";
                                        _upaKey.currentState?.reset();

                                        unionDropDownLists = [];
                                        dduId = "";
                                        _uniKey.currentState?.reset();

                                        if (divId.isNotEmpty &&
                                            fysId.isNotEmpty &&
                                            fyeId.isNotEmpty &&
                                            distId.isNotEmpty) {
                                          isButtonEnabled = true;
                                        } else {
                                          isButtonEnabled = false;
                                        }

                                        getUpazila();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 8, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: 2.5,
                                    ),
                                    child: DropdownButtonFormField(
                                      key: _upaKey,
                                      decoration: InputDecoration(
                                        enabled: (upaDropDownLists.length != 0)
                                            ? true
                                            : false,
                                        label: Text(
                                          'Upazila',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 2.0),
                                        ),
                                      ),
                                      items: upaDropDownLists,
                                      onChanged: (dynamic? value) {
                                        ddId = value.toString();

                                        unionDropDownLists = [];
                                        dduId = "";
                                        _uniKey.currentState?.reset();

                                        getUnion();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 2.5,
                                    ),
                                    child: DropdownButtonFormField(
                                      key: _uniKey,
                                      decoration: InputDecoration(
                                        enabled:
                                            (unionDropDownLists.length != 0)
                                                ? true
                                                : false,
                                        label: Text(
                                          'Union',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: primaryVariant_spray,
                                              width: 2.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.black26,
                                              width: 2.0),
                                        ),
                                      ),
                                      items: unionDropDownLists,
                                      onChanged: (dynamic? value) {
                                        dduId = value.toString();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 8, right: 10),
                            child: DropdownButtonFormField(
                              key: _fundKey,
                              focusNode: FocusNode(canRequestFocus: true),
                              decoration: InputDecoration(
                                label: Text(
                                  'Source of fund',
                                  style: TextStyle(fontSize: 14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 2.0),
                                ),
                              ),
                              items: fundDropDownLists,
                              onChanged: (dynamic? value) {
                                fsmId = value.toString();
                                if (fsmId.isEmpty) {
                                  setState(() {
                                    _fundKey.currentState?.reset();
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 8, right: 10),
                            child: DropdownButtonFormField(
                              key: _ptmKey,
                              decoration: InputDecoration(
                                label: Text(
                                  'Project Type',
                                  style: TextStyle(fontSize: 14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                              ),
                              items: pTypeDropDownLists,
                              onChanged: (dynamic? value) {
                                ptmId = value.toString();

                                ptdDropDownLists = [];
                                ptdId = "";
                                _ptdKey.currentState?.reset();

                                if (ptmId.isEmpty) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _ptmKey.currentState?.reset();
                                  });
                                } else {
                                  getProjectSubType();
                                }
                              },
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 8, right: 10),
                            child: DropdownButtonFormField(
                              focusNode: FocusNode(canRequestFocus: false),
                              key: _ptdKey,
                              decoration: InputDecoration(
                                enabled: (ptdDropDownLists.length != 0)
                                    ? true
                                    : false,
                                label: Text(
                                  'Project Sub Type',
                                  style: TextStyle(fontSize: 14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: primaryVariant_spray, width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                              ),
                              items: ptdDropDownLists,
                              onChanged: (dynamic? value) {
                                ptdId = value.toString();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: searchOnPress,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 45),
                          ),
                          child: Text(
                            'SEARCH',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: searchMapVisibility,
                      child: Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: searchMapOnPress,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 45),
                              ),
                              child: Text(
                                'SEARCH WITH MAP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoCondensed',
                                ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _logOutDialogue() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'LOG OUT!',
            style: TextStyle(color: primaryVariant_spray),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text(
                  'Do you want to Log Out?',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                LoginScreen.userLists.clear();
                LoginScreen.userLists = [];
                Navigator.pop(context);
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
      barrierDismissible: false, // user must tap button!
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
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                if (widget.userType == "GUEST") {
                  Navigator.pop(context);
                } else if (widget.userType == "ADMIN") {
                  LoginScreen.userLists.clear();
                  LoginScreen.userLists = [];
                  Navigator.pop(context);
                }
              },
            ),
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                getFinancialYearData();
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

  //    --------------------------Updating UI with Necessary Data-----------------------------
  void getFinancialYearData() async {
    showLoaderDialog(context);
    fyStart = [];
    fyEnd = [];
    conn = false;
    String fyUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/fy_lists";
    NetworkHelper networkHelper = NetworkHelper(fyUrl);
    var userData = await networkHelper.getData();
    if (userData != null) {
      ApiResponse fyResponse = ApiResponse.fromJson(userData);
      int count = fyResponse.count;
      if (count != 0) {
        for (int i = 0; i < fyResponse.items.length; i++) {
          var p_fy_id = fyResponse.items[i]['p_fy_id'];
          var fy_financial_year_name =
              fyResponse.items[i]['fy_financial_year_name'];
          var fy_from_year = fyResponse.items[i]['fy_from_year'];
          var fy_to_year = fyResponse.items[i]['fy_to_year'];
          var fy_details = fyResponse.items[i]['fy_details'];
          var fy_active_flag = fyResponse.items[i]['fy_active_flag'];
          FinancialYears financialYears = FinancialYears(
              p_fy_id,
              fy_financial_year_name,
              fy_from_year,
              fy_to_year,
              fy_details,
              fy_active_flag);
          fyStart.add(financialYears);
          fyEnd.add(financialYears);
        }
        getDivisionData();
      } else {
        conn = false;
        updateInterface();
      }
    } else {
      conn = false;
      updateInterface();
    }
  }

  void getDivisionData() async {
    divisionLists = [];
    String divUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/division_lists";

    NetworkHelper networkHelper = NetworkHelper(divUrl);
    var divisionData = await networkHelper.getData();
    if (divisionData != null) {
      ApiResponse divResponse = ApiResponse.fromJson(divisionData);
      int count = divResponse.count;
      if (count != 0) {
        for (int i = 0; i < divResponse.items.length; i++) {
          var p_div_id = divResponse.items[i]['p_div_id'];
          var div_name = divResponse.items[i]['div_name'];
          Divisions divisions = Divisions(p_div_id, div_name);
          divisionLists.add(divisions);
        }
        getSourceOfFundData();
      } else {
        conn = false;
        updateInterface();
      }
    } else {
      conn = false;
      updateInterface();
    }
  }

  void getSourceOfFundData() async {
    fundLists = [];
    String fundUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/source_of_fund_lists";

    NetworkHelper networkHelper = NetworkHelper(fundUrl);
    var fundData = await networkHelper.getData();
    if (fundData != null) {
      ApiResponse fundResponse = ApiResponse.fromJson(fundData);
      int count = fundResponse.count;
      fundLists.add(SourceOfFund("", "..."));
      if (count != 0) {
        for (int i = 0; i < fundResponse.items.length; i++) {
          var p_fsm_id = fundResponse.items[i]['p_fsm_id'];
          var fsm_fund_name = fundResponse.items[i]['fsm_fund_name'];
          SourceOfFund sourceOfFund = SourceOfFund(p_fsm_id, fsm_fund_name);
          fundLists.add(sourceOfFund);
        }
        getProjectTypeData();
      } else {
        conn = false;
        updateInterface();
      }
    } else {
      conn = false;
      updateInterface();
    }
  }

  void getProjectTypeData() async {
    projectTypeLists = [];
    String pTypeUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/project_type_lists";
    NetworkHelper networkHelper = NetworkHelper(pTypeUrl);
    var pTypeData = await networkHelper.getData();
    if (pTypeData != null) {
      ApiResponse pTypeResponse = ApiResponse.fromJson(pTypeData);
      int count = pTypeResponse.count;
      projectTypeLists.add(ProjectType("", "..."));
      if (count != 0) {
        for (int i = 0; i < pTypeResponse.items.length; i++) {
          var p_ptm_id = pTypeResponse.items[i]['p_ptm_id'];
          var ptm_project_type_name =
              pTypeResponse.items[i]['ptm_project_type_name'];
          ProjectType projectType =
              ProjectType(p_ptm_id, ptm_project_type_name);
          projectTypeLists.add(projectType);
        }
        conn = true;
        updateInterface();
      } else {
        conn = false;
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
      fyStartDropDownLists = [];
      fyEndDropDownLists = [];
      divisionDropDownLists = [];
      fundDropDownLists = [];
      pTypeDropDownLists = [];

      for (int i = 0; i < fyStart.length; i++) {
        fyStartDropDownLists.add(DropdownMenuItem(
          value: fyStart[i].fyId,
          child: Text(
            fyStart[i].financialYearName,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ));
      }

      for (int i = 0; i < fyEnd.length; i++) {
        fyEndDropDownLists.add(DropdownMenuItem(
          value: fyEnd[i].fyId,
          child: Text(
            fyEnd[i].financialYearName,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ));
      }

      for (int i = 0; i < divisionLists.length; i++) {
        divisionDropDownLists.add(DropdownMenuItem(
          value: divisionLists[i].divId,
          child: Text(
            divisionLists[i].divName,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ));
      }

      for (int i = 0; i < fundLists.length; i++) {
        fundDropDownLists.add(DropdownMenuItem(
          value: fundLists[i].fsmId,
          child: Text(
            fundLists[i].fundName,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ));
      }

      for (int i = 0; i < projectTypeLists.length; i++) {
        pTypeDropDownLists.add(DropdownMenuItem(
          value: projectTypeLists[i].ptmId,
          child: Text(
            projectTypeLists[i].projectTypeName,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ));
      }
      conn = false;

      setState(() {});
    } else {
      _noConnectionDialogue();
    }
  }

  //    --------------------------Getting Districts and updating UI-----------------------------
  void getDistricts() async {
    showLoaderDialog(context);
    conn = false;
    districtLists = [];

    String distUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/dist_lists?div_id=" +
            divId;
    NetworkHelper networkHelper = NetworkHelper(distUrl);
    var distData = await networkHelper.getData();
    if (distData != null) {
      ApiResponse distResponse = ApiResponse.fromJson(distData);
      int count = distResponse.count;
      if (count != 0) {
        for (int i = 0; i < distResponse.items.length; i++) {
          var p_dist_id = distResponse.items[i]['p_dist_id'];
          var dist_name = distResponse.items[i]['dist_name'];
          District district = District(p_dist_id, dist_name);
          districtLists.add(district);
        }
      }
      conn = true;
      updateDistricts();
    } else {
      conn = false;
      updateDistricts();
    }
  }

  void updateDistricts() async {
    Navigator.pop(context);
    if (conn) {
      disDropDownLists = [];
      conn = false;
      setState(() {
        for (int i = 0; i < districtLists.length; i++) {
          disDropDownLists.add(DropdownMenuItem(
            value: districtLists[i].distId,
            child: Text(
              districtLists[i].distName,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ));
        }
      });
    } else {
      showDialog<void>(
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
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              TextButton(
                child: const Text('Retry'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  getDistricts();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //    --------------------------Getting Upazillas and updating UI-----------------------------
  void getUpazila() async {
    showLoaderDialog(context);
    conn = false;
    upazilaLists = [];
    String upazilaUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/upazila_lists?dist_id=" +
            distId;

    NetworkHelper networkHelper = NetworkHelper(upazilaUrl);
    var upaData = await networkHelper.getData();
    if (upaData != null) {
      ApiResponse upaResponse = ApiResponse.fromJson(upaData);
      int count = upaResponse.count;
      if (count != 0) {
        for (int i = 0; i < upaResponse.items.length; i++) {
          var pcu_dd_id = upaResponse.items[i]['pcu_dd_id'];
          var thana_upozilla = upaResponse.items[i]['thana_upozilla'];

          Upazila upazila = Upazila(pcu_dd_id, thana_upozilla);
          upazilaLists.add(upazila);
        }
      }
      conn = true;
      updateUpazila();
    } else {
      conn = false;
      updateUpazila();
    }
  }

  void updateUpazila() async {
    Navigator.pop(context);
    if (conn) {
      upaDropDownLists = [];
      conn = false;
      setState(() {
        for (int i = 0; i < upazilaLists.length; i++) {
          upaDropDownLists.add(DropdownMenuItem(
            value: upazilaLists[i].ddId,
            child: Text(
              upazilaLists[i].thanaName,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ));
        }
      });
    } else {
      showDialog<void>(
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
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              TextButton(
                child: const Text('Retry'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  getUpazila();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //    --------------------------Getting Unions and updating UI-----------------------------
  void getUnion() async {
    showLoaderDialog(context);
    conn = false;
    unionLists = [];

    String unionUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/union_lists?dd_id=" +
            ddId;

    NetworkHelper networkHelper = NetworkHelper(unionUrl);
    var uniData = await networkHelper.getData();
    if (uniData != null) {
      ApiResponse uniResponse = ApiResponse.fromJson(uniData);
      int count = uniResponse.count;
      if (count != 0) {
        for (int i = 0; i < uniResponse.items.length; i++) {
          var pcun_ddu_id = uniResponse.items[i]['pcun_ddu_id'];
          var ddu_union_name = uniResponse.items[i]['ddu_union_name'];

          Union union = Union(pcun_ddu_id, ddu_union_name);
          unionLists.add(union);
        }
      }
      conn = true;
      updateUnion();
    } else {
      conn = false;
      updateUnion();
    }
  }

  void updateUnion() async {
    Navigator.pop(context);
    if (conn) {
      unionDropDownLists = [];
      conn = false;
      setState(() {
        for (int i = 0; i < unionLists.length; i++) {
          unionDropDownLists.add(DropdownMenuItem(
            value: unionLists[i].dduId,
            child: Text(
              unionLists[i].unionName,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ));
        }
      });
    } else {
      showDialog<void>(
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
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              TextButton(
                child: const Text('Retry'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  getUnion();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //    --------------------------Getting Project Sub Types and updating UI-----------------------------
  void getProjectSubType() async {
    showLoaderDialog(context);
    conn = false;
    projectSubTypeLists = [];

    String prSubTypeUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/utility_data/project_sub_type_lists?ptm_id=" +
            ptmId;
    NetworkHelper networkHelper = NetworkHelper(prSubTypeUrl);
    var prSubData = await networkHelper.getData();

    if (prSubData != null) {
      ApiResponse prSubResponse = ApiResponse.fromJson(prSubData);
      int count = prSubResponse.count;
      if (count != 0) {
        for (int i = 0; i < prSubResponse.items.length; i++) {
          var p_ptd_id = prSubResponse.items[i]['p_ptd_id'];
          var ptd_project_subtype_name =
              prSubResponse.items[i]['ptd_project_subtype_name'];
          ProjectSubType projectSubType =
              ProjectSubType(p_ptd_id, ptd_project_subtype_name);
          projectSubTypeLists.add(projectSubType);
        }
      }
      conn = true;
      updatePrSubTYpe();
    } else {
      conn = false;
      updatePrSubTYpe();
    }
  }

  void updatePrSubTYpe() async {
    Navigator.pop(context);
    if (conn) {
      ptdDropDownLists = [];
      conn = false;
      setState(() {
        for (int i = 0; i < projectSubTypeLists.length; i++) {
          ptdDropDownLists.add(DropdownMenuItem(
            value: projectSubTypeLists[i].ptdId,
            child: Text(
              projectSubTypeLists[i].projectSubTypeName,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ));
        }
      });
    } else {
      showDialog<void>(
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
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              TextButton(
                child: const Text('Retry'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  getProjectSubType();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //    --------------------------Getting Project Data and going to project lists-----------------------------
  void getProjectData() async {
    showLoaderDialog(context);
    conn = false;
    HomePage.projectLists = [];
    String projectDataUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/projects/projectData?ptd_Id=$ptdId&ptm_id=$ptmId&fsm_id=$fsmId&ddu_id=$dduId&dd_id=$ddId&dist_id=$distId&div_id=$divId&fys_id=$fysId&fye_id=$fyeId";

    NetworkHelper networkHelper = NetworkHelper(projectDataUrl);
    var projectData = await networkHelper.getData();

    if (projectData != null) {
      ApiResponse prDataResponse = ApiResponse.fromJson(projectData);
      int count = prDataResponse.count;

      if (count != 0) {
        for (int i = 0; i < prDataResponse.items.length; i++) {
          var pcm_id = prDataResponse.items[i]['pcm_id'];
          var entry_date = prDataResponse.items[i]['entry_date'];
          var pcm_internal_no = prDataResponse.items[i]['pcm_internal_no'];
          var pcm_project_code = prDataResponse.items[i]['pcm_project_code'];
          var pcm_user = prDataResponse.items[i]['pcm_user'];
          var pcm_project_name = prDataResponse.items[i]['pcm_project_name'];
          var pcm_project_no = prDataResponse.items[i]['pcm_project_no'];
          var pcm_project_date = prDataResponse.items[i]['pcm_project_date'];
          var pcm_pic_chairman_name =
              prDataResponse.items[i]['pcm_pic_chairman_name'];
          var pcm_pic_chairman_details =
              prDataResponse.items[i]['pcm_pic_chairman_details'];
          var pcm_estimate_project_value =
              prDataResponse.items[i]['pcm_estimate_project_value'];
          var fy_financial_year_name =
              prDataResponse.items[i]['fy_financial_year_name'];
          var fsm_fund_name = prDataResponse.items[i]['fsm_fund_name'];
          var ptm_project_type_name =
              prDataResponse.items[i]['ptm_project_type_name'];
          var ptd_project_subtype_name =
              prDataResponse.items[i]['ptd_project_subtype_name'];
          var psc_sanction_cat_name =
              prDataResponse.items[i]['psc_sanction_cat_name'];
          var pcm_category_name = prDataResponse.items[i]['pcm_category_name'];
          var pcu_dd_id = prDataResponse.items[i]['pcu_dd_id'];

          var pcm_proj_evaluation_remarks =
              prDataResponse.items[i]['pcm_proj_evaluation_remarks'];
          var pcmgd_type_flag = prDataResponse.items[i]['pcmgd_type_flag'];
          var pcm_project_details =
              prDataResponse.items[i]['pcm_project_details'];
          var start_date = prDataResponse.items[i]['start_date'];
          var end_date = prDataResponse.items[i]['end_date'];
          var pcm_project_sanction_type =
              prDataResponse.items[i]['pcm_project_sanction_type'];
          var pcfd_project_physical_length =
              prDataResponse.items[i]['pcfd_project_physical_length'];
          var pcfd_project_physical_width =
              prDataResponse.items[i]['pcfd_project_physical_width'];
          var pcfd_distance_measure_unit =
              prDataResponse.items[i]['pcfd_distance_measure_unit'];
          var rownumber_ = prDataResponse.items[i]['rownumber_'];

          String stype = "";
          switch (pcm_project_sanction_type.toString()) {
            case "0":
              stype = "Taka(টাকা)";
              break;
            case "1":
              stype = "Rice(চাল) (MT)";
              break;
            case "2":
              stype = "Wheat(গম) (MT)";
              break;
          }

          String measureUnit = "";
          switch (pcfd_distance_measure_unit.toString()) {
            case "1":
              measureUnit = " Meter [MT]";
              break;
            case "2":
              measureUnit = " Feet [FT]";
              break;
          }

          String pCount = "#${i + 1}";
          String length = pcfd_project_physical_length.toString() + measureUnit;
          String width = pcfd_project_physical_width.toString() + measureUnit;

          ProjectLists projectLists = ProjectLists(
              pcm_id,
              entry_date,
              pcm_internal_no,
              pcm_project_code,
              pcm_user,
              pcm_project_name,
              pcm_project_no,
              pcm_project_date,
              pcm_pic_chairman_name,
              pcm_pic_chairman_details,
              pcm_estimate_project_value,
              fy_financial_year_name,
              fsm_fund_name,
              ptm_project_type_name,
              ptd_project_subtype_name,
              psc_sanction_cat_name,
              pcm_category_name,
              null,
              pcu_dd_id,
              pcm_proj_evaluation_remarks,
              pcmgd_type_flag,
              pcm_project_details,
              start_date,
              end_date,
              stype,
              length,
              width,
              rownumber_,
              pCount, []);

          HomePage.projectLists.add(projectLists);
        }
        getLocations();
      } else {
        conn = true;
        goToProjectList();
      }
    } else {
      conn = false;
      goToProjectList();
    }
  }

  void getLocations() async {
    String locationUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/all_locations/project_locations";

    NetworkHelper networkHelper = NetworkHelper(locationUrl);
    var locData = await networkHelper.getData();

    if (locData != null) {
      ApiResponse locResponse = ApiResponse.fromJson(locData);
      int count = locResponse.count;

      if (count != 0) {
        for (int i = 0; i < locResponse.items.length; i++) {
          var pcmgd_latitude = locResponse.items[i]['pcmgd_latitude'];
          var pcmgd_longitude = locResponse.items[i]['pcmgd_longitude'];
          var segment = locResponse.items[i]['segment'];
          var pcmgd_pcm_id = locResponse.items[i]['pcmgd_pcm_id'];

          for (int j = 0; j < HomePage.projectLists.length; j++) {
            if (pcmgd_pcm_id.toString() ==
                HomePage.projectLists[j].pcmId.toString()) {
              List<LocationLists> list = HomePage.projectLists[j].locationLists;
              list.add(LocationLists(pcmgd_latitude, pcmgd_longitude, segment));
              HomePage.projectLists[j].locationLists = list;
            }
          }
        }
      }
      conn = true;
      goToProjectList();
    } else {
      conn = false;
      goToProjectList();
    }
  }

  void goToProjectList() async {
    Navigator.pop(context);
    if (conn) {
      if (HomePage.projectLists.isNotEmpty) {
        Navigator.pushNamed(context, Projects.id);
      } else {
        Fluttertoast.showToast(
          msg: 'No Projects Found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      conn = false;
    } else {
      showDialog<void>(
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
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              TextButton(
                child: const Text('Retry'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  getProjectData();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //    --------------------------Getting Project Map Data and going to project lists-----------------------------
  void getProjectMapData() async {
    showLoaderDialog(context);
    conn = false;
    HomePage.projectMapLists = [];
    String projectMapDataUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/projects/projectMapData?ptd_Id=$ptdId&ptm_id=$ptmId&fsm_id=$fsmId&ddu_id=$dduId&dd_id=$ddId&dist_id=$distId&div_id=$divId&fys_id=$fysId&fye_id=$fyeId";

    NetworkHelper networkHelper = NetworkHelper(projectMapDataUrl);
    var projectMapData = await networkHelper.getData();

    if (projectMapData != null) {
      ApiResponse prMapDataResponse = ApiResponse.fromJson(projectMapData);
      int count = prMapDataResponse.count;

      if (count != 0) {
        for (int i = 0; i < prMapDataResponse.items.length; i++) {
          var pcm_id = prMapDataResponse.items[i]['pcm_id'];
          var entry_date = prMapDataResponse.items[i]['entry_date'];
          var pcm_internal_no = prMapDataResponse.items[i]['pcm_internal_no'];
          var pcm_project_code = prMapDataResponse.items[i]['pcm_project_code'];
          var pcm_user = prMapDataResponse.items[i]['pcm_user'];
          var pcm_project_name = prMapDataResponse.items[i]['pcm_project_name'];
          var pcm_project_no = prMapDataResponse.items[i]['pcm_project_no'];
          var pcm_project_date = prMapDataResponse.items[i]['pcm_project_date'];
          var pcm_pic_chairman_name =
              prMapDataResponse.items[i]['pcm_pic_chairman_name'];
          var pcm_pic_chairman_details =
              prMapDataResponse.items[i]['pcm_pic_chairman_details'];
          var pcm_estimate_project_value =
              prMapDataResponse.items[i]['pcm_estimate_project_value'];
          var fy_financial_year_name =
              prMapDataResponse.items[i]['fy_financial_year_name'];
          var fsm_fund_name = prMapDataResponse.items[i]['fsm_fund_name'];
          var ptm_project_type_name =
              prMapDataResponse.items[i]['ptm_project_type_name'];
          var ptd_project_subtype_name =
              prMapDataResponse.items[i]['ptd_project_subtype_name'];
          var psc_sanction_cat_name =
              prMapDataResponse.items[i]['psc_sanction_cat_name'];
          var pcm_category_name =
              prMapDataResponse.items[i]['pcm_category_name'];
          var pcu_dd_id = prMapDataResponse.items[i]['pcu_dd_id'];

          var pcm_proj_evaluation_remarks =
              prMapDataResponse.items[i]['pcm_proj_evaluation_remarks'];
          var pcmgd_type_flag = prMapDataResponse.items[i]['pcmgd_type_flag'];
          var pcm_project_details =
              prMapDataResponse.items[i]['pcm_project_details'];
          var start_date = prMapDataResponse.items[i]['start_date'];
          var end_date = prMapDataResponse.items[i]['end_date'];
          var pcm_project_sanction_type =
              prMapDataResponse.items[i]['pcm_project_sanction_type'];
          var pcfd_project_physical_length =
              prMapDataResponse.items[i]['pcfd_project_physical_length'];
          var pcfd_project_physical_width =
              prMapDataResponse.items[i]['pcfd_project_physical_width'];
          var pcfd_distance_measure_unit =
              prMapDataResponse.items[i]['pcfd_distance_measure_unit'];
          var rownumber_ = prMapDataResponse.items[i]['rownumber_'];

          String stype = "";
          switch (pcm_project_sanction_type.toString()) {
            case "0":
              stype = "Taka(টাকা)";
              break;
            case "1":
              stype = "Rice(চাল) (MT)";
              break;
            case "2":
              stype = "Wheat(গম) (MT)";
              break;
          }

          String measureUnit = "";
          switch (pcfd_distance_measure_unit.toString()) {
            case "1":
              measureUnit = " Meter [MT]";
              break;
            case "2":
              measureUnit = " Feet [FT]";
              break;
          }

          String pCount = "#${i + 1}";
          String length = pcfd_project_physical_length.toString() + measureUnit;
          String width = pcfd_project_physical_width.toString() + measureUnit;

          ProjectMapLists projectMapLists = ProjectMapLists(
              pcm_id,
              entry_date,
              pcm_internal_no,
              pcm_project_code,
              pcm_user,
              pcm_project_name,
              pcm_project_no,
              pcm_project_date,
              pcm_pic_chairman_name,
              pcm_pic_chairman_details,
              pcm_estimate_project_value,
              fy_financial_year_name,
              fsm_fund_name,
              ptm_project_type_name,
              ptd_project_subtype_name,
              psc_sanction_cat_name,
              pcm_category_name,
              null,
              pcu_dd_id,
              pcm_proj_evaluation_remarks,
              pcmgd_type_flag,
              pcm_project_details,
              start_date,
              end_date,
              stype,
              length,
              width,
              rownumber_,
              pCount, []);

          HomePage.projectMapLists.add(projectMapLists);
        }
        getMapLocations();
      } else {
        conn = true;
        goToProjectMapLists();
      }
    } else {
      conn = false;
      goToProjectMapLists();
    }
  }

  void getMapLocations() async {
    String locationUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/all_locations/project_locations";

    NetworkHelper networkHelper = NetworkHelper(locationUrl);
    var locData = await networkHelper.getData();

    if (locData != null) {
      ApiResponse locResponse = ApiResponse.fromJson(locData);
      int count = locResponse.count;

      if (count != 0) {
        for (int i = 0; i < locResponse.items.length; i++) {
          var pcmgd_latitude = locResponse.items[i]['pcmgd_latitude'];
          var pcmgd_longitude = locResponse.items[i]['pcmgd_longitude'];
          var segment = locResponse.items[i]['segment'];
          var pcmgd_pcm_id = locResponse.items[i]['pcmgd_pcm_id'];

          for (int j = 0; j < HomePage.projectMapLists.length; j++) {
            if (pcmgd_pcm_id.toString() ==
                HomePage.projectMapLists[j].pcmId.toString()) {
              List<LocationLists> list =
                  HomePage.projectMapLists[j].locationLists;
              list.add(LocationLists(pcmgd_latitude, pcmgd_longitude, segment));
              HomePage.projectMapLists[j].locationLists = list;
            }
          }
        }
      }
      conn = true;
      goToProjectMapLists();
    } else {
      conn = false;
      goToProjectMapLists();
    }
  }

  void goToProjectMapLists() async {
    Navigator.pop(context);
    if (conn) {
      if (HomePage.projectMapLists.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectsWithMap(distId, ddId, dduId)));
      } else {
        Fluttertoast.showToast(
          msg: 'No Projects Found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      conn = false;
    } else {
      showDialog<void>(
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
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              TextButton(
                child: const Text('Retry'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  getProjectMapData();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
