import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_monitoring/lists/location_lists.dart';
import 'package:e_monitoring/lists/multi_polygons_custom.dart';
import 'package:e_monitoring/lists/polygons_custom.dart';
import 'package:e_monitoring/screens/home_page.dart';
import 'package:e_monitoring/screens/project_details.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:e_monitoring/utilities/triangle_clipper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geojson/geojson.dart' as gson;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:latlong2/latlong.dart' as nLatLng;

class ProjectsWithMap extends StatefulWidget {
  static const String id = 'projects_with_map';

  final String distId;
  final String ddId;
  final String dduId;

  ProjectsWithMap(this.distId, this.ddId, this.dduId);

  @override
  State<ProjectsWithMap> createState() => _ProjectsWithMapState();
}

class _ProjectsWithMapState extends State<ProjectsWithMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  static const LatLng targetLocation = LatLng(23.6850, 90.3563);

  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  Set<Polygon> polygons = {};
  bool fullScreenOff = true;

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
  String selectedId = "";

  int selectedAdaptarPosition = -1;

  Random mRandom = Random(1351441456747);

  final ItemScrollController itemScrollController = ItemScrollController();
  List<gson.GeoJsonFeature> features = [];
  List<PolygonsCustom> polyCust = [];
  List<MultiPolygonsCustom> multiPolyCust = [];
  late LatLng zoomLatlng;

  final geo = gson.GeoJson();

  double targetZoom() {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return 6;
    } else {
      return 10;
    }
  }

  void mapStyleSetup() async {
    if (selectedValue == "NORMAL") {
      mapType = MapType.normal;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        dev.log(error.toString());
      });
    } else if (selectedValue == "SATELLITE") {
      mapType = MapType.satellite;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        dev.log(error.toString());
      });
    } else if (selectedValue == "TERRAIN") {
      mapType = MapType.terrain;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        dev.log(error.toString());
      });
    } else if (selectedValue == "HYBRID") {
      mapType = MapType.hybrid;
      rootBundle.loadString('raw/normal.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        dev.log(error.toString());
      });
    } else if (selectedValue == "NO LANDMARK") {
      mapType = MapType.normal;
      rootBundle.loadString('raw/no_landmark.json').then((string) async {
        _mapStyle = string;
        GoogleMapController ccc = await _controller.future;
        ccc.setMapStyle(_mapStyle);
      }).catchError((error) {
        dev.log(error.toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue = categories[0];
    mapType = MapType.normal;

    Future.delayed(Duration.zero, () {
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        getLayer();
      } else {
        buildUp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('markers ${markers.length}');
    // print('polylines ${polyLines.length}');
    // print('polygons ${polygons.length}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
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
                      initialCameraPosition: CameraPosition(
                          target: targetLocation, zoom: targetZoom()),
                      markers: markers,
                      mapType: mapType,
                      polygons: polygons,
                      polylines: polyLines,
                      onMapCreated: (controller) async {
                        _controller.complete(controller);
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                        selectedId = "";
                        selectedAdaptarPosition = -1;
                        buildUp();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      width: 300,
                      height: 220,
                      offset: 30,
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
                      margin: const EdgeInsets.only(left: 5, bottom: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          items: categories
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(
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
                flex: 5,
                child: Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                'PROJECTS:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'CantoraOne'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.topRight,
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                'Total ${HomePage.projectMapLists.length} Projects',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CantoraOne'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ScrollablePositionedList.builder(
                              itemCount: HomePage.projectMapLists.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemScrollController: itemScrollController,
                              itemBuilder: (context, position) {
                                return GestureDetector(
                                  onTap: () async {
                                    selectedId = HomePage
                                        .projectMapLists[position].pcmId
                                        .toString();
                                    selectedAdaptarPosition = position;
                                    LatLng? latLng;
                                    for (int i = 0; i < markers.length; i++) {
                                      if (markers.toList()[i].markerId.value ==
                                          selectedId) {
                                        latLng = markers.toList()[i].position;

                                        break;
                                      } else if (markers
                                          .toList()[i]
                                          .markerId
                                          .value
                                          .contains('PolyMark1$selectedId')) {
                                        latLng = markers.toList()[i].position;

                                        break;
                                      }
                                    }
                                    CameraPosition cameraPosition =
                                        CameraPosition(
                                            target: latLng!, zoom: 15);
                                    GoogleMapController controller =
                                        await _controller.future;
                                    controller.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            cameraPosition));
                                    addInfoWindow(position, latLng);
                                    buildUp();
                                  },
                                  child: Container(
                                    color: selectedAdaptarPosition == position
                                        ? const Color(0xffdfe6e9)
                                        : Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            HomePage
                                                .projectMapLists[position].count
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: primaryVariant_spray,
                                                fontFamily: 'Roboto-Medium'),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            HomePage.projectMapLists[position]
                                                .pcmProjectName
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: primaryVariant_spray,
                                                fontFamily: 'Roboto-Medium'),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            HomePage.projectMapLists[position]
                                                .pcmInternalNo
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Colors.black54,
                                                fontFamily: 'Roboto-Medium'),
                                          ),
                                        ),
                                        Visibility(
                                          visible: selectedAdaptarPosition ==
                                                  position
                                              ? true
                                              : false,
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            alignment: Alignment.topRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                String projectType = HomePage
                                                    .projectMapLists[position]
                                                    .projectTypeName
                                                    .toString();
                                                String projectSubType = HomePage
                                                    .projectMapLists[position]
                                                    .projectSubTypeName
                                                    .toString();
                                                String projectFundName =
                                                    HomePage
                                                        .projectMapLists[
                                                            position]
                                                        .fsmFundName
                                                        .toString();
                                                String sType = HomePage
                                                    .projectMapLists[position]
                                                    .sanctionType
                                                    .toString();
                                                String projectValue = HomePage
                                                    .projectMapLists[position]
                                                    .pcmEstimateProjectValue
                                                    .toString();
                                                String numbering() {
                                                  if (sType.contains("Taka")) {
                                                    final formatter = NumberFormat
                                                            .decimalPattern(Intl
                                                                .defaultLocale)
                                                        .format(int.parse(
                                                            projectValue));
                                                    return formatter;
                                                  } else {
                                                    return projectValue;
                                                  }
                                                }

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProjectDetails(
                                                      INTERNAL_NO: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmInternalNo,
                                                      P_NO: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmProjectNo,
                                                      P_CODE: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmProjectCode,
                                                      P_NAME: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmProjectName,
                                                      P_DETAILS: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .projectDetails,
                                                      ENTRY_DATE: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmEntryDate,
                                                      START_DATE: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .projectStartDate,
                                                      END_DATE: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .projectEndDate,
                                                      SUBMITTER: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmUser,
                                                      P_DATE: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmProjectDate,
                                                      F_YEAR: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .fyFinancialYearName,
                                                      ES_VAL: numbering(),
                                                      CATEGORY: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmCategoryName,
                                                      P_TYPE:
                                                          '$projectType > $projectSubType',
                                                      F_NAME: projectFundName,
                                                      SANC_CAT: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .PscSanctionCatName,
                                                      PIC_DET:
                                                          '${HomePage.projectMapLists[position].pcmPicChairmanName}\n${HomePage.projectMapLists[position].pcmPicChairmanDetails}',
                                                      EVAL: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .projEvaluationRem,
                                                      PCM_ID: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .pcmId,
                                                      LENGTH: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .length,
                                                      WIDTH: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .width,
                                                      FROM_MAP: false,
                                                      locationLists: HomePage
                                                          .projectMapLists[
                                                              position]
                                                          .locationLists,
                                                      S_TYPE: sType,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'DETAILS',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void buildUp() async {
    markers = {};
    polyLines = {};
    var androidIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(36, 36),
        ),
        'images/marker_micro_56_unselect.png');
    var androidSelectedIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(36, 36),
        ),
        'images/marker_micro_76_select.png');
    var iosIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(36, 36),
        ),
        'images/marker_micro_18.png');
    var iosSelectedIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(36, 36),
        ),
        'images/marker_micro_24_select.png');
    var transparent = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(36, 36)),
        'images/transparent_circle.png');

    for (int i = 0; i < HomePage.projectMapLists.length; i++) {
      List<LocationLists> locationLists =
          HomePage.projectMapLists[i].locationLists;
      String proName = HomePage.projectMapLists[i].pcmProjectName.toString();
      String proNo = HomePage.projectMapLists[i].pcmProjectNo.toString();
      String projectCode =
          HomePage.projectMapLists[i].pcmProjectCode.toString();
      String pcmId = HomePage.projectMapLists[i].pcmId.toString();
      String length = HomePage.projectMapLists[i].length.toString();
      String width = HomePage.projectMapLists[i].width.toString();
      String sType = HomePage.projectMapLists[i].sanctionType.toString();
      String projectValue =
          HomePage.projectMapLists[i].pcmEstimateProjectValue.toString();
      String totalVal = "";
      if (sType.contains("Taka")) {
        final formatter = NumberFormat.decimalPattern(Intl.defaultLocale)
            .format(int.parse(projectValue));
        totalVal = "$formatter $sType";
      } else {
        totalVal = "$projectValue $sType";
      }

      String finYear =
          HomePage.projectMapLists[i].fyFinancialYearName.toString();
      String proDate = HomePage.projectMapLists[i].pcmProjectDate.toString();

      if (locationLists.isNotEmpty) {
        String snippet =
            "Project No (প্রকল্প নং): $proNo\nProject Code (প্রকল্প কোড) [জিও]: $projectCode\nProject Date: $proDate\nLength: $length\nWidth: $width\nEstimated Value: $totalVal\nFinancial Year: $finYear";
        String snippetWeb = "<div style="
            "color:black;"
            ">Project No (প্রকল্প নং): $proNo<br>Project Code (প্রকল্প কোড) [জিও]: $projectCode<br>Project Date: $proDate<br>Length: $length<br>Width: $width<br>Estimated Value: $totalVal<br>Financial Year: $finYear</div>";
        if (locationLists.length == 1) {
          // print('Selected Id $selectedId');
          LatLng latLng = LatLng(double.parse(locationLists[0].latitude),
              double.parse(locationLists[0].longitude));
          Marker marker = Marker(
              markerId: MarkerId(pcmId),
              position: latLng,
              infoWindow: defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS
                  ? InfoWindow.noText
                  : InfoWindow(title: proName, snippet: snippetWeb),
              icon: defaultTargetPlatform == TargetPlatform.android
                  ? (selectedId == pcmId ? androidSelectedIcon : androidIcon)
                  : (selectedId == pcmId ? iosSelectedIcon : iosIcon),
              onTap: () async {
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
                                      proName,
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
                                            top: 2,
                                            left: 4,
                                            right: 4,
                                            bottom: 4),
                                        child: Text(
                                          snippet,
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
                CameraPosition cameraPosition =
                    CameraPosition(target: latLng, zoom: 15);
                GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));

                for (int a = 0; a < markers.length; a++) {
                  if (pcmId == markers.toList()[a].markerId.value) {
                    // print('PCM ID $pcmId');
                    selectedId = pcmId;
                    buildUp();
                    break;
                  }
                }
                for (int j = 0; j < HomePage.projectMapLists.length; j++) {
                  String pId = HomePage.projectMapLists[j].pcmId.toString();
                  if (pcmId == pId) {
                    selectedAdaptarPosition = j;
                  }
                }
                itemScrollController.scrollTo(
                    index: selectedAdaptarPosition,
                    duration: const Duration(seconds: 1),
                    alignment: 0.3);
              });

          markers.add(marker);
        } else {
          Color color = generateRandomColor();
          // Colors.primaries[Random().nextInt(Colors.primaries.length)];
          int segment = 0;
          for (int j = 0; j < locationLists.length; j++) {
            if (locationLists[j].segment > segment) {
              segment = locationLists[j].segment;
            }
          }
          for (int s = 0; s <= segment; s++) {
            int pointNumber = 0;
            LatLng? point;
            Polyline polyline1;
            Polyline polyline2;
            List<LatLng> listLL = [];

            for (int j = 0; j < locationLists.length; j++) {
              if (s == locationLists[j].segment) {
                pointNumber++;
                point = LatLng(double.parse(locationLists[j].latitude),
                    double.parse(locationLists[j].longitude));
                listLL.add(point);
              }
            }

            if (pointNumber == 1) {
              // print('Selected Id point 1: $selectedId');
              Marker marker = Marker(
                  markerId: MarkerId(pcmId),
                  position: point!,
                  icon: defaultTargetPlatform == TargetPlatform.android
                      ? (selectedId == pcmId
                          ? androidSelectedIcon
                          : androidIcon)
                      : (selectedId == pcmId ? iosSelectedIcon : iosIcon),
                  infoWindow: defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS
                      ? InfoWindow.noText
                      : InfoWindow(title: proName, snippet: snippetWeb),
                  onTap: () async {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(4),
                                        child: Text(
                                          proName,
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
                                                top: 2,
                                                left: 4,
                                                right: 4,
                                                bottom: 4),
                                            child: Text(
                                              snippet,
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
                    CameraPosition cameraPosition =
                        CameraPosition(target: point, zoom: 15);
                    GoogleMapController controller = await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition));

                    for (int a = 0; a < markers.length; a++) {
                      if (pcmId == markers.toList()[a].markerId.value) {
                        // print('PCM ID $pcmId');
                        selectedId = pcmId;
                        buildUp();
                        break;
                      }
                    }
                    for (int j = 0; j < HomePage.projectMapLists.length; j++) {
                      String pId = HomePage.projectMapLists[j].pcmId.toString();
                      if (pcmId == pId) {
                        selectedAdaptarPosition = j;
                      }
                    }
                    itemScrollController.scrollTo(
                        index: selectedAdaptarPosition,
                        duration: const Duration(seconds: 1),
                        alignment: 0.3);
                  });
              markers.add(marker);
            } else if (pointNumber > 1) {
              polyline1 = Polyline(
                  polylineId: PolylineId("s${s}Poly1$pcmId"),
                  color: selectedId == pcmId
                      ? const Color(0xff0984e3)
                      : Colors.black,
                  width: selectedId == pcmId ? 15 : 10,
                  geodesic: true,
                  zIndex: int.parse(pcmId),
                  points: listLL);
              polyline2 = Polyline(
                  polylineId: PolylineId("s${s}Poly2$pcmId"),
                  color: color,
                  width: 6,
                  geodesic: true,
                  zIndex: int.parse(pcmId),
                  points: listLL);

              polyLines.add(polyline1);
              polyLines.add(polyline2);

              int a = (listLL.length / 2).round();
              LatLng latLng = LatLng(listLL[a].latitude, listLL[a].longitude);
              // print('Selected Id line $selectedId');
              Marker marker = Marker(
                  markerId: MarkerId("s${s}PolyMark1$pcmId"),
                  position: latLng,
                  icon: transparent,
                  infoWindow: defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS
                      ? InfoWindow.noText
                      : InfoWindow(title: proName, snippet: snippetWeb),
                  onTap: () async {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(4),
                                        child: Text(
                                          proName,
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
                                                top: 2,
                                                left: 4,
                                                right: 4,
                                                bottom: 4),
                                            child: Text(
                                              snippet,
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
                    CameraPosition cameraPosition =
                        CameraPosition(target: latLng, zoom: 15);
                    GoogleMapController controller = await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition));

                    for (int a = 0; a < markers.length; a++) {
                      if (markers.toList()[a].markerId.value.contains(pcmId)) {
                        // print('PCM ID $pcmId');
                        selectedId = pcmId;
                        buildUp();
                        break;
                      }
                    }
                    for (int j = 0; j < HomePage.projectMapLists.length; j++) {
                      String pId = HomePage.projectMapLists[j].pcmId.toString();
                      if (pcmId == pId) {
                        selectedAdaptarPosition = j;
                      }
                    }
                    itemScrollController.scrollTo(
                        index: selectedAdaptarPosition,
                        duration: const Duration(seconds: 1),
                        alignment: 0.3);
                  });

              markers.add(marker);
            }
          }
        }
      }
    }

    setState(() {});
  }

  Color generateRandomColor() {
    // This is the base color which will be mixed with the generated one
    final int baseRed = Colors.white.red;
    final int baseGreen = Colors.white.green;
    final int baseBlue = Colors.white.blue;

    final int red = ((baseRed + mRandom.nextInt(256)) / 2).round();
    final int green = ((baseGreen + mRandom.nextInt(256)) / 2).round();
    final int blue = ((baseBlue + mRandom.nextInt(256)) / 2).round();

    return Color.fromRGBO(red, green, blue, 1);
  }

  void addInfoWindow(int position, LatLng latLng) {
    String proName =
        HomePage.projectMapLists[position].pcmProjectName.toString();
    String proNo = HomePage.projectMapLists[position].pcmProjectNo.toString();
    String projectCode =
        HomePage.projectMapLists[position].pcmProjectCode.toString();
    String length = HomePage.projectMapLists[position].length.toString();
    String width = HomePage.projectMapLists[position].width.toString();
    String sType = HomePage.projectMapLists[position].sanctionType.toString();
    String projectValue =
        HomePage.projectMapLists[position].pcmEstimateProjectValue.toString();
    String totalVal = "";
    if (sType.contains("Taka")) {
      final formatter = NumberFormat.decimalPattern(Intl.defaultLocale)
          .format(int.parse(projectValue));
      totalVal = "$formatter $sType";
    } else {
      totalVal = "$projectValue $sType";
    }

    String finYear =
        HomePage.projectMapLists[position].fyFinancialYearName.toString();
    String proDate =
        HomePage.projectMapLists[position].pcmProjectDate.toString();
    String snippet =
        "Project No (প্রকল্প নং): $proNo\nProject Code (প্রকল্প কোড) [জিও]: $projectCode\nProject Date: $proDate\nLength: $length\nWidth: $width\nEstimated Value: $totalVal\nFinancial Year: $finYear";

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
                          proName,
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
                              snippet,
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

  Future<void> getLayer() async {
    showLoaderDialog(context);

    geo.processedFeatures.listen((event) {
      features.add(event);
      // var id = event.properties!['id'];
      // dev.log('features: ${features.length} + id: $id');
    }).onError((e) {
      dev.log("Error: $e");
    });

    geo.processedPolygons.listen((event) {
      polyCust.add(PolygonsCustom('', event));
      // dev.log('polygon: ${polyCust.length}+ name: ${event.name}');
    }).onError((e) {
      dev.log("Error: $e");
    });

    geo.processedMultiPolygons.listen((event) {
      multiPolyCust.add(MultiPolygonsCustom('', event));
    }).onError((e) {
      dev.log("Error: $e");
    });

    geo.endSignal.listen((event) async {
      // dev.log('finished: ${event}');
      // dev.log('features: ${features.length}');
      // dev.log('polygon: ${polyCust.length}');
      // dev.log('Multipolygon: ${multiPolyCust.length}');
      Navigator.pop(context);
      if (event) {
        newFu();
      }
    });

    if (widget.dduId.isEmpty) {
      if (widget.ddId.isEmpty) {
        final data = await rootBundle
            .loadString('raw/small_bangladesh_districts_zillas_flutter.json');
        await geo.parse(data);
      } else {
        final data = await rootBundle
            .loadString('raw/small_bangladesh_upozila_flutter.json');
        await geo.parse(data);
      }
    } else {
      final data = await rootBundle
          .loadString('raw/small_bangladesh_5160_unions_flutter.json');
      await geo.parse(data);
    }
  }

  void newFu() async {
    int a = 0;
    int b = 0;
    for (int i = 0; i < features.length; i++) {
      String id = '';
      id = features[i].properties!['id'].toString();
      // dev.log("checking ID: $id");
      String type = features[i].type.toString();
      if (!type.contains('multipolygon')) {
        polyCust[a].id = id;
        // dev.log("poly id: " + a.toString());
        a++;
      } else if (type.contains('multipolygon')) {
        multiPolyCust[b].id = id;
        b++;
        // dev.log("Not Accepted id: " + id);
      }
    }

    String mainId = '';
    double zoomQuantity = 15;
    if (widget.dduId.isEmpty) {
      if (widget.ddId.isEmpty) {
        mainId = widget.distId;
        zoomQuantity = 9.5;
      } else {
        mainId = widget.ddId;
        zoomQuantity = 10.5;
      }
    } else {
      mainId = widget.dduId;
      zoomQuantity = 12;
    }

    for (int i = 0; i < polyCust.length; i++) {
      String id = polyCust[i].id;
      if (id == mainId) {
        List<LatLng> gonList = [];
        for (int j = 0; j < polyCust[i].geoJsonPolygon.geoSeries.length; j++) {
          List<nLatLng.LatLng> llll =
              polyCust[i].geoJsonPolygon.geoSeries[j].toLatLng();
          for (int k = 0; k < llll.length; k++) {
            gonList.add(LatLng(llll[k].latitude, llll[k].longitude));
          }
        }
        Color color = const Color(0xffc8d6e5).withAlpha(100);
        Polygon polygon = Polygon(
          polygonId: PolygonId(id),
          points: gonList,
          fillColor: color,
          strokeColor: Colors.red.shade300,
          strokeWidth: 2,
        );
        polygons.add(polygon);
      }
    }

    for (int i = 0; i < multiPolyCust.length; i++) {
      String id = multiPolyCust[i].id;
      if (id == mainId) {
        List<LatLng> gonList = [];
        List<gson.GeoJsonPolygon> gsonPoly =
            multiPolyCust[i].geoJsonMultiPolygon.polygons;
        for (int j = 0; j < gsonPoly.length; j++) {
          for (int k = 0; k < gsonPoly[j].geoSeries.length; k++) {
            List<nLatLng.LatLng> llll = gsonPoly[j].geoSeries[k].toLatLng();
            for (int m = 0; m < llll.length; m++) {
              gonList.add(LatLng(llll[m].latitude, llll[m].longitude));
            }
          }
        }
        Color color = const Color(0xffc8d6e5).withAlpha(100);
        Polygon polygon = Polygon(
          polygonId: PolygonId(id),
          points: gonList,
          fillColor: color,
          strokeColor: Colors.red.shade300,
          strokeWidth: 2,
        );
        polygons.add(polygon);
      }
    }

    for (int i = 0; i < features.length; i++) {
      String id = '';
      id = features[i].properties!['id'].toString();
      if (id.isNotEmpty) {
        if (mainId == id) {
          // dev.log("Accepted id for lat lng: $id");
          zoomLatlng = LatLng(
              double.parse(features[i].properties!['Lat'].toString()),
              double.parse(features[i].properties!['Long'].toString()));
        }
      }
    }
    CameraPosition cameraPosition =
        CameraPosition(target: zoomLatlng, zoom: zoomQuantity);
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    buildUp();
  }
}
