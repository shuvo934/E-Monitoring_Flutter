import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_monitoring/lists/comments.dart';
import 'package:e_monitoring/lists/location_lists.dart';
import 'package:e_monitoring/response/api_response.dart';
import 'package:e_monitoring/screens/post_comment.dart';
import 'package:e_monitoring/screens/project_pictures.dart';
import 'package:e_monitoring/screens/three_sixty_image.dart';
import 'package:e_monitoring/services/networking.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:e_monitoring/utilities/triangle_clipper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';

class ProjectDetails extends StatefulWidget {
  static const String id = 'project_details';

  final INTERNAL_NO;
  final P_NO;
  final P_CODE;
  final P_NAME;
  final P_DETAILS;
  final ENTRY_DATE;
  final START_DATE;
  final END_DATE;
  final SUBMITTER;
  final P_DATE;
  final F_YEAR;
  final ES_VAL;
  final CATEGORY;
  final P_TYPE;
  final F_NAME;
  final SANC_CAT;
  final PIC_DET;
  final EVAL;
  final PCM_ID;
  final LENGTH;
  final WIDTH;
  final bool FROM_MAP;
  final List<LocationLists> locationLists;
  final S_TYPE;

  ProjectDetails(
      {required this.INTERNAL_NO,
      required this.P_NO,
      required this.P_CODE,
      required this.P_NAME,
      required this.P_DETAILS,
      required this.ENTRY_DATE,
      required this.START_DATE,
      required this.END_DATE,
      required this.SUBMITTER,
      required this.P_DATE,
      required this.F_YEAR,
      required this.ES_VAL,
      required this.CATEGORY,
      required this.P_TYPE,
      required this.F_NAME,
      required this.SANC_CAT,
      required this.PIC_DET,
      required this.EVAL,
      required this.PCM_ID,
      required this.LENGTH,
      required this.WIDTH,
      required this.FROM_MAP,
      required this.locationLists,
      required this.S_TYPE});

  static String URL_360 = "";

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool fullScreenOff = true;
  static const LatLng targetLocation = LatLng(23.6850, 90.3563);
  late BitmapDescriptor singleMarker;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  bool conn = false;

  double devPro = 0.0;
  String devProgress = "";

  double finPro = 0.0;
  String finProgress = "";

  bool available360 = false;
  bool noCommentVisible = false;
  bool commLay = false;
  bool showAllComm = false;

  String nameOfCommentator = "";
  String timeOfCommentator = "";
  String msgOfCommentator = "";

  List<Comments> comments = [];

  late NetworkHelper networkHelper;

  final List<String> categories = [
    "NORMAL",
    "SATELLITE",
    "TERRAIN",
    "HYBRID",
    "NO LANDMARK"
  ];

  String? selectedValue;
  late MapType mapType;
  late String _mapStyle;

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  void initState() {
    // TODO: implement initState
    // getMarkerIcon();
    super.initState();
    print(widget.PCM_ID);
    selectedValue = categories[0];
    mapType = MapType.normal;

    Future.delayed(Duration.zero, () {
      getDevProData();
    });
  }

  void mapStyleSetup() async {
    if (selectedValue == "NORMAL") {
      mapType = MapType.normal;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        log(error.toString());
      });
    } else if (selectedValue == "SATELLITE") {
      mapType = MapType.satellite;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        log(error.toString());
      });
    } else if (selectedValue == "TERRAIN") {
      mapType = MapType.terrain;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        log(error.toString());
      });
    } else if (selectedValue == "HYBRID") {
      mapType = MapType.hybrid;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        log(error.toString());
      });
    } else if (selectedValue == "NO LANDMARK") {
      mapType = MapType.normal;
      rootBundle.loadString('raw/no_landmark.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        log(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build markers: ${markers.length}');
    print('build polys: ${polyLines.length}');
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Card(
                margin: const EdgeInsets.all(5),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: false,
                      initialCameraPosition:
                          const CameraPosition(target: targetLocation, zoom: 8),
                      markers: markers,
                      mapType: mapType,
                      polylines: polyLines,
                      onMapCreated: (controller) async {
                        _controller.complete(controller);
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      width: 300,
                      height: 220,
                      offset: 35,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(
                        right: 5,
                        top: 5,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (fullScreenOff) {
                              fullScreenOff = false;
                            } else {
                              fullScreenOff = true;
                            }
                          });
                        },
                        child: Icon(
                          fullScreenOff
                              ? Icons.fullscreen
                              : Icons.fullscreen_exit,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 5, bottom: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          items: categories
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                              mapStyleSetup();
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: 160,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: primary_dupain,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: Colors.yellow,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              padding: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: primaryVariant_spray,
                              ),
                              elevation: 8,
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              )),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: fullScreenOff,
              child: Expanded(
                flex: 6,
                child: Card(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    margin: const EdgeInsets.only(bottom: 3),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 3, left: 3, right: 5),
                                    child: const Text(
                                      'Internal No (ক্রমিক নং):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.INTERNAL_NO,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Project No (প্রকল্প নং):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.P_NO,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Project Code (প্রকল্প কোড) [জিও]:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.P_CODE,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: const Text(
                                  'Project Name (প্রকল্পের নাম):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Text(
                                  widget.P_NAME,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: const Text(
                                  'Project Measurement:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Text(
                                  'Length: ${widget.LENGTH} / Width: ${widget.WIDTH}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: const Text(
                                  'Project Details (প্রকল্পের বিস্তারিত বিবরণ):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Text(
                                  widget.P_DETAILS,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Entry date (তথ্য প্রদানের তারিখ):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.ENTRY_DATE,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Start Date (প্রকল্প শুরুর তারিখ):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.START_DATE,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'End Date (প্রকল্প শেষের তারিখ):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.END_DATE,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Submitted By:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.SUBMITTER,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Project Date (প্রকল্প অনুমোদনের তারিখ):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.P_DATE,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Financial Year(অর্থ বছর):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.F_YEAR,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Estimated Value (বরাদ্দের পরিমান):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    '${widget.ES_VAL} ${widget.S_TYPE}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Category:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.CATEGORY,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Project Type (প্রকল্পের প্রকারভেদ):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.P_TYPE,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Fund name (তহবিলের উৎস):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.F_NAME,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 3, right: 5),
                                    child: const Text(
                                      'Sanction category (বরাদ্দের ধরন):',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Medium',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Text(
                                    widget.SANC_CAT,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: const Text(
                                  'PIC/Contractor/Others Details (পিআইসি / ঠিকাদার / অন্যান্য বিস্তারিত তথ্য):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Text(
                                  _parseHtmlString(widget.PIC_DET),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: const Text(
                                  'Development Progress:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: LinearProgressIndicator(
                                          value: devPro,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 4,
                                        ),
                                        child: Text(
                                          devProgress,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: const Text(
                                  'Financial Progress:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: LinearProgressIndicator(
                                          value: finPro,
                                          minHeight: 10,
                                          backgroundColor: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 4,
                                        ),
                                        child: Text(
                                          finProgress,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5, left: 3, right: 3),
                                child: const Text(
                                  'Evaluation Notes:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                child: Text(
                                  widget.EVAL,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectPictures(
                                      pcmId: widget.PCM_ID,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'SEE PROJECT PICTURE',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: available360,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ThreeSixtyIMage.id);
                                },
                                child: const Text(
                                  '360° IMAGE',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: noCommentVisible,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 5, left: 3, right: 3, bottom: 5),
                              child: const Text(
                                'No Comments Submitted',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto-Medium',
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: commLay,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, left: 3, right: 3),
                                  child: const Text(
                                    'Last Comment:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Roboto-Medium',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 3),
                                  child: Card(
                                    color: Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.account_circle,
                                          color: Colors.blue.shade800,
                                        ),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 3),
                                          child: Text(
                                            nameOfCommentator,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 75,
                                        child: Text(
                                          msgOfCommentator,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 25,
                                        child: Text(
                                          timeOfCommentator,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: showAllComm,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 5, bottom: 10, left: 10, right: 10),
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  _commentsDialogue();
                                },
                                child: const Text(
                                  'SEE ALL COMMENTS',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostComment(widget.PCM_ID),
                                  ),
                                );
                              },
                              child: const Text(
                                'POST NEW COMMENT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getSingleMarker() async {
    LatLng latLng = LatLng(double.parse(widget.locationLists[0].latitude),
        double.parse(widget.locationLists[0].longitude));

    Marker marker = Marker(
        markerId: const MarkerId("1"),
        position: latLng,
        icon: defaultTargetPlatform == TargetPlatform.android
            ? await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(
                  size: Size(36, 36),
                ),
                'images/marker_micro_76_unselect.png')
            : await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(
                  size: Size(36, 36),
                ),
                'images/marker_micro_36_2.png'),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              Column(
                children: [
                  Expanded(
                    flex: 96,
                    child: Material(
                      elevation: 1.0,
                      shadowColor: Colors.grey,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              child: Text(
                                widget.P_NAME,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 2, left: 4, right: 4, bottom: 4),
                                  child: Text(
                                    "Project No (প্রকল্প নং): " +
                                        widget.P_NO +
                                        "\nProject Code (প্রকল্প কোড) [জিও]: " +
                                        widget.P_CODE +
                                        "\nProject Date: " +
                                        widget.P_DATE +
                                        "\nLength: " +
                                        widget.LENGTH +
                                        "\nWidth: " +
                                        widget.WIDTH +
                                        "\nEstimated Value: " +
                                        widget.ES_VAL +
                                        " " +
                                        widget.S_TYPE +
                                        "\nFinancial Year: " +
                                        widget.F_YEAR,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        color: Colors.white,
                        width: 20.0,
                        height: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
              latLng);
        });

    markers.add(marker);
    CameraPosition cameraPosition =
        CameraPosition(target: marker.position, zoom: 17);
    GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      print('setstate Single: ${markers.length}');
    });
  }

  void getMapMarkerAndPoly() {
    if (widget.locationLists.isNotEmpty) {
      if (widget.locationLists.length == 1) {
        getSingleMarker();
      } else {
        getMultiMarkerAndPoly();
      }
    }
  }

  void getMultiMarkerAndPoly() async {
    int segment = 0;
    for (int j = 0; j < widget.locationLists.length; j++) {
      if (widget.locationLists[j].segment > segment) {
        segment = widget.locationLists[j].segment;
      }
    }
    // print('Segment Number: $segment');
    for (int s = 0; s <= segment; s++) {
      int pointNumber = 0;
      LatLng? point = null;
      // print("segment running: $s");
      Polyline polyline1;
      Polyline polyline2;
      List<LatLng> listLL = [];
      for (int j = 0; j < widget.locationLists.length; j++) {
        if (s == widget.locationLists[j].segment) {
          pointNumber++;
          point = LatLng(double.parse(widget.locationLists[j].latitude),
              double.parse(widget.locationLists[j].longitude));
          listLL.add(point);
        }
      }

      if (pointNumber == 1) {
        Marker marker = Marker(
            markerId: MarkerId("segment${s}Point1"),
            position: point!,
            icon: defaultTargetPlatform == TargetPlatform.android
                ? await BitmapDescriptor.fromAssetImage(
                    const ImageConfiguration(
                      size: Size(36, 36),
                    ),
                    'images/marker_micro_76_unselect.png')
                : await BitmapDescriptor.fromAssetImage(
                    const ImageConfiguration(
                      size: Size(36, 36),
                    ),
                    'images/marker_micro_36_2.png'),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Column(
                    children: [
                      Expanded(
                        flex: 96,
                        child: Material(
                          elevation: 1.0,
                          shadowColor: Colors.grey,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  child: Text(
                                    widget.P_NAME,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 2, left: 4, right: 4, bottom: 4),
                                      child: Text(
                                        "Project No (প্রকল্প নং): " +
                                            widget.P_NO +
                                            "\nProject Code (প্রকল্প কোড) [জিও]: " +
                                            widget.P_CODE +
                                            "\nProject Date: " +
                                            widget.P_DATE +
                                            "\nLength: " +
                                            widget.LENGTH +
                                            "\nWidth: " +
                                            widget.WIDTH +
                                            "\nEstimated Value: " +
                                            widget.ES_VAL +
                                            " " +
                                            widget.S_TYPE +
                                            "\nFinancial Year: " +
                                            widget.F_YEAR,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            color: Colors.white,
                            width: 20.0,
                            height: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  point!);
            });

        markers.add(marker);
        CameraPosition cameraPosition =
            CameraPosition(target: marker.position, zoom: 17);
        GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
        // setState(() {
        //   print('setstate : ${markers.length}');
        // });
      } else if (pointNumber > 1) {
        polyline1 = Polyline(
            polylineId: PolylineId("segment${s}Poly1"),
            color: Colors.black,
            width: 10,
            geodesic: true,
            points: listLL);
        polyline2 = Polyline(
            polylineId: PolylineId("segment${s}Poly2"),
            color: Colors.cyanAccent,
            width: 6,
            geodesic: true,
            points: listLL);

        int a = (listLL.length / 2).round();

        polyLines.add(polyline1);
        polyLines.add(polyline2);
        LatLng latLng = LatLng(listLL[a].latitude, listLL[a].longitude);

        Marker marker = Marker(
            markerId: MarkerId("segment${s}PolyMark1"),
            position: latLng,
            icon: await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(size: Size(36, 36)),
                'images/transparent_circle.png'),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Column(
                    children: [
                      Expanded(
                        flex: 96,
                        child: Material(
                          elevation: 1.0,
                          shadowColor: Colors.grey,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  child: Text(
                                    widget.P_NAME,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 2, left: 4, right: 4, bottom: 4),
                                      child: Text(
                                        "Project No (প্রকল্প নং): " +
                                            widget.P_NO +
                                            "\nProject Code (প্রকল্প কোড) [জিও]: " +
                                            widget.P_CODE +
                                            "\nProject Date: " +
                                            widget.P_DATE +
                                            "\nLength: " +
                                            widget.LENGTH +
                                            "\nWidth: " +
                                            widget.WIDTH +
                                            "\nEstimated Value: " +
                                            widget.ES_VAL +
                                            " " +
                                            widget.S_TYPE +
                                            "\nFinancial Year: " +
                                            widget.F_YEAR,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            color: Colors.white,
                            width: 20.0,
                            height: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  latLng);
            });

        markers.add(marker);
        CameraPosition cameraPosition =
            CameraPosition(target: marker.position, zoom: 15);
        GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
        // setState(() {
        //   print('setstate : ${markers.length}');
        // });
      }
    }

    setState(() {
      // print('setstate markers : ${markers.length}');
      // print('setstate polys : ${polyLines.length}');
    });
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
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                getDevProData();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _commentsDialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'COMMENTS:',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
              fontFamily: 'CantoraOne',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: comments.length,
                  itemBuilder: (context, position) {
                    return CommentWidget(
                        commentator: comments[position].commentator,
                        timeOfComment: comments[position].comment_time,
                        comments: comments[position].comment);
                  }),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getDevProData() async {
    showLoaderDialog(context);
    conn = false;
    devPro = 0.0;
    devProgress = "";
    String devProgressUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/progress/gerDevelopmentProgress?pcm_id=${widget.PCM_ID}";
    networkHelper = NetworkHelper(devProgressUrl);
    var devProgData = await networkHelper.getData();
    if (devProgData != null) {
      ApiResponse devProResponse = ApiResponse.fromJson(devProgData);
      int count = devProResponse.count;
      if (count != 0) {
        for (int i = 0; i < devProResponse.items.length; i++) {
          var ppdm_total_progress_mark =
              devProResponse.items[i]['ppdm_total_progress_mark'];
          devProgress = ppdm_total_progress_mark.toString();
          devPro = double.parse(devProgress);
        }
      } else {
        devPro = 0.0;
        devProgress = "";
      }
      getFinProData();
    } else {
      conn = false;
      updateInterface();
    }
  }

  void getFinProData() async {
    finPro = 0.0;
    finProgress = "";
    String finProgressUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/progress/getFinancialProgress?pcm_id=${widget.PCM_ID}";
    networkHelper = NetworkHelper(finProgressUrl);
    var finProgData = await networkHelper.getData();
    if (finProgData != null) {
      ApiResponse finProResponse = ApiResponse.fromJson(finProgData);
      int count = finProResponse.count;
      if (count != 0) {
        for (int i = 0; i < finProResponse.items.length; i++) {
          var pfd_disbursement_amt =
              finProResponse.items[i]['pfd_disbursement_amt'];
          finProgress = pfd_disbursement_amt.toString();
          finPro = finPro + double.parse(finProgress);
        }
      } else {
        finPro = 0.0;
        finProgress = "";
      }
      getThreeSixtyImageData();
    } else {
      conn = false;
      updateInterface();
    }
  }

  void getThreeSixtyImageData() async {
    available360 = false;
    String threeSixtyImageUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/images/get_three_sixty?pcm_id=${widget.PCM_ID}";
    networkHelper = NetworkHelper(threeSixtyImageUrl);
    var threeSixtyData = await networkHelper.getData();
    if (threeSixtyData != null) {
      ApiResponse threeSixtyResponse = ApiResponse.fromJson(threeSixtyData);
      int count = threeSixtyResponse.count;
      if (count != 0) {
        for (int i = 0; i < threeSixtyResponse.items.length; i++) {
          var ud_db_generated_file_name =
              threeSixtyResponse.items[i]['ud_db_generated_file_name'];
          ProjectDetails.URL_360 =
              "http://103.56.208.123:8863/assets/project_image/" +
                  ud_db_generated_file_name.toString();
          available360 = true;
        }
      } else {
        available360 = false;
      }
      getComments();
    } else {
      conn = false;
      updateInterface();
    }
  }

  void getComments() async {
    comments = [];
    String commentsUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/comments/getComments?pcm_id=${widget.PCM_ID}";

    networkHelper = NetworkHelper(commentsUrl);
    var commentsData = await networkHelper.getData();
    if (commentsData != null) {
      ApiResponse commentsResponse = ApiResponse.fromJson(commentsData);
      int count = commentsResponse.count;
      if (count != 0) {
        for (int i = 0; i < commentsResponse.items.length; i++) {
          var pcof_id = commentsResponse.items[i]['pcof_id'];
          var pcof_pcm_id = commentsResponse.items[i]['pcof_pcm_id'];
          var pcof_submitter_name =
              commentsResponse.items[i]['pcof_submitter_name'];
          var pcof_submitter_email =
              commentsResponse.items[i]['pcof_submitter_email'];
          var pcof_submitter_message =
              commentsResponse.items[i]['pcof_submitter_message'];
          var c_date = commentsResponse.items[i]['c_date'];

          comments.add(Comments(pcof_id, pcof_pcm_id, pcof_submitter_name,
              pcof_submitter_email, pcof_submitter_message, c_date));
        }
      }
      conn = true;
      updateInterface();
    } else {
      conn = false;
      updateInterface();
    }
  }

  void updateInterface() {
    Navigator.pop(context);
    if (conn) {
      if (devProgress.isEmpty) {
        devProgress = "0";
      }
      devProgress = "$devProgress%";
      devPro = devPro / 100;

      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        available360 = available360;
      } else {
        available360 = false;
      }

      String val = widget.ES_VAL.toString().replaceAll(",", "");

      if (finProgress.isEmpty) {
        finProgress = "0";
      }

      finPro = finPro / double.parse(val);
      int fin = finPro.round();
      fin = fin * 100;
      finProgress = "$fin%";

      if (comments.isEmpty) {
        noCommentVisible = true;
        commLay = false;
        showAllComm = false;
      } else if (comments.length == 1) {
        noCommentVisible = false;
        commLay = true;
        showAllComm = false;
        int index = comments.length - 1;
        nameOfCommentator = comments[index].commentator.toString();
        msgOfCommentator = comments[index].comment.toString();
        timeOfCommentator = comments[index].comment_time.toString();
      } else {
        noCommentVisible = false;
        commLay = true;
        showAllComm = true;
        int index = comments.length - 1;
        nameOfCommentator = comments[index].commentator.toString();
        msgOfCommentator = comments[index].comment.toString();
        timeOfCommentator = comments[index].comment_time.toString();
      }

      conn = false;
      getMapMarkerAndPoly();
    } else {
      _noConnectionDialogue();
    }
  }
}

class CommentWidget extends StatelessWidget {
  String commentator;
  String timeOfComment;
  String comments;

  CommentWidget(
      {required this.commentator,
      required this.timeOfComment,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4, left: 5, right: 3),
          child: Card(
            color: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.blue.shade800,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(left: 5, right: 3),
                  child: Text(
                    commentator,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 3),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                flex: 75,
                child: Text(
                  comments,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              Expanded(
                flex: 25,
                child: Text(
                  timeOfComment,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
