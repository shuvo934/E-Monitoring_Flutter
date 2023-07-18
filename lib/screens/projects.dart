import 'package:e_monitoring/lists/location_lists.dart';
import 'package:e_monitoring/screens/home_page.dart';
import 'package:e_monitoring/screens/project_details.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Projects extends StatefulWidget {
  static const String id = 'projects';
  static int _previousPos = -1;

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  String projectsNumber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectsNumber = HomePage.projectLists.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Projects._previousPos = -1;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset('images/bd_icon.png')),
          title: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'E-MONITORING',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RussoOne'),
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              alignment: Alignment.centerRight,
              child: Text(
                'Total $projectsNumber Projects',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontFamily: 'CantoraOne'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      height: 1,
                      width: 960,
                      color: Colors.grey,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      color: primary_dupain,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 1,
                            color: Colors.grey,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 200,
                            alignment: Alignment.center,
                            child: const Text(
                              'Project Name / প্রকল্পের নাম',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 100,
                            alignment: Alignment.center,
                            child: const Text(
                              'Project No / প্রকল্প নং',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 100,
                            alignment: Alignment.center,
                            child: const Text(
                              'Project Code [GEO] / প্রকল্প কোড [জিও]',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text(
                              'Project Date / প্রকল্প অনুমোদনের তারিখ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text(
                              'Estimated value / বরাদ্দের পরিমান',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text(
                              'Project Type / প্রকল্পের প্রকারভেদ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text(
                              'Fund name / তহবিলের উৎস',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text(
                              'Financial Year / অর্থ বছর',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 100,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 60,
                            alignment: Alignment.center,
                            child: const Text(
                              'Map Data',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.grey,
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      height: 1,
                      width: 960,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                        child: SizedBox(
                          width: 960,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, position) {
                              return ListLayout(
                                HomePage.projectLists[position].count,
                                HomePage.projectLists[position].pcmInternalNo,
                                HomePage.projectLists[position].pcmProjectName,
                                HomePage.projectLists[position].pcmProjectNo,
                                HomePage.projectLists[position].pcmProjectCode,
                                HomePage.projectLists[position].pcmProjectDate,
                                HomePage.projectLists[position]
                                    .pcmEstimateProjectValue
                                    .toString(),
                                HomePage.projectLists[position].projectTypeName,
                                HomePage
                                    .projectLists[position].projectSubTypeName,
                                HomePage.projectLists[position].fsmFundName,
                                HomePage
                                    .projectLists[position].fyFinancialYearName,
                                HomePage.projectLists[position].sanctionType,
                                HomePage.projectLists[position].locationLists,
                                position,
                                callBack,
                              );
                            },
                            itemCount: HomePage.projectLists.length,
                          ),
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

  void callBack() {
    setState(() {
      print(10);
    });
  }
}

class ListLayout extends StatelessWidget {
  String counting;
  String projectInternalNo;
  String projectName;
  String projectNo;
  String projectCode;
  String projectDate;
  String projectValue;
  String projectType;
  String projectSubType;
  String projectFundName;
  String projectFinYear;
  String sType;
  List<LocationLists> projectMapData;
  int pos;
  Function callback;

  ListLayout(
      this.counting,
      this.projectInternalNo,
      this.projectName,
      this.projectNo,
      this.projectCode,
      this.projectDate,
      this.projectValue,
      this.projectType,
      this.projectSubType,
      this.projectFundName,
      this.projectFinYear,
      this.sType,
      this.projectMapData,
      this.pos,
      this.callback);

  String numbering() {
    if (sType.contains("Taka")) {
      final formatter = NumberFormat.decimalPattern(Intl.defaultLocale)
          .format(int.parse(projectValue));
      return formatter;
    } else {
      return projectValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Projects._previousPos = pos;
            // print(projectName);
            print(Projects._previousPos);
            callback();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetails(
                  INTERNAL_NO: projectInternalNo,
                  P_NO: projectNo,
                  P_CODE: projectCode,
                  P_NAME: projectName,
                  P_DETAILS: HomePage.projectLists[pos].projectDetails,
                  ENTRY_DATE: HomePage.projectLists[pos].pcmEntryDate,
                  START_DATE: HomePage.projectLists[pos].projectStartDate,
                  END_DATE: HomePage.projectLists[pos].projectEndDate,
                  SUBMITTER: HomePage.projectLists[pos].pcmUser,
                  P_DATE: projectDate,
                  F_YEAR: projectFinYear,
                  ES_VAL: numbering(),
                  CATEGORY: HomePage.projectLists[pos].pcmCategoryName,
                  P_TYPE: '$projectType > $projectSubType',
                  F_NAME: projectFundName,
                  SANC_CAT: HomePage.projectLists[pos].pscSanctionCatName,
                  PIC_DET:
                      '${HomePage.projectLists[pos].pcmPicChairmanName}\n${HomePage.projectLists[pos].pcmPicChairmanDetails}',
                  EVAL: HomePage.projectLists[pos].projEvaluationRem,
                  PCM_ID: HomePage.projectLists[pos].pcmId,
                  LENGTH: HomePage.projectLists[pos].length,
                  WIDTH: HomePage.projectLists[pos].width,
                  FROM_MAP: false,
                  locationLists: projectMapData,
                  S_TYPE: sType,
                ),
              ),
            );
          },
          child: Container(
            color: pos == Projects._previousPos
                ? const Color(0xffdfe6e9)
                : Colors.white,
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 5),
                    width: 200,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          counting,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: primary_dupain,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          projectName,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: primary_dupain,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          projectInternalNo,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      projectNo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      projectCode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      projectDate,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '${numbering()} $sType',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '$projectType > $projectSubType',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      projectFundName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      projectFinYear,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: primary_dupain,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: 60,
                    alignment: Alignment.center,
                    child: projectMapData.isNotEmpty
                        ? const Icon(
                            Icons.done,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.horizontal_rule,
                            color: Colors.grey,
                          ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: 960,
          color: Colors.black,
        ),
      ],
    );
  }
}
