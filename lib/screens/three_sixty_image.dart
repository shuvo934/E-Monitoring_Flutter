import 'package:e_monitoring/screens/project_details.dart';
import 'package:e_monitoring/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panorama/panorama.dart';

class ThreeSixtyIMage extends StatefulWidget {
  static const String id = 'three_sixty_image';

  @override
  State<ThreeSixtyIMage> createState() => _ThreeSixtyIMageState();
}

class _ThreeSixtyIMageState extends State<ThreeSixtyIMage> {
  // List<ImageProvider> imageList = <ImageProvider>[];
  // bool autoRotate = true;
  // int rotationCount = 2;
  // int swipeSensitivity = 2;
  // bool allowSwipeToRotate = true;
  // RotationDirection rotationDirection = RotationDirection.anticlockwise;
  // Duration frameChangeDuration = Duration(milliseconds: 50);
  // bool imagePrecached = false;

  @override
  void initState() {
    // TODO: implement initState
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => updateImageList(context));
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Center(
  //         child: Padding(
  //           padding: const EdgeInsets.only(top: 72.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               (imagePrecached == true)
  //                   ? ImageView360(
  //                       key: UniqueKey(),
  //                       imageList: imageList,
  //                       autoRotate: autoRotate,
  //                       rotationCount: rotationCount,
  //                       rotationDirection: RotationDirection.anticlockwise,
  //                       frameChangeDuration: Duration(milliseconds: 30),
  //                       swipeSensitivity: swipeSensitivity,
  //                       allowSwipeToRotate: allowSwipeToRotate,
  //                       onImageIndexChanged: (currentImageIndex) {
  //                         print("currentImageIndex: $currentImageIndex");
  //                       },
  //                     )
  //                   : Text("Pre-Caching images..."),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   "Optional features:",
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.green,
  //                       fontSize: 24),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child: Text("Auto rotate: $autoRotate"),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child: Text("Rotation count: $rotationCount"),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child: Text("Rotation direction: $rotationDirection"),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child: Text(
  //                     "Frame change duration: ${frameChangeDuration.inMilliseconds} milliseconds"),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child:
  //                     Text("Allow swipe to rotate image: $allowSwipeToRotate"),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child: Text("Swipe sensitivity: $swipeSensitivity"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Container(
        color: Colors.black,
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: Panorama(
                sensitivity: 2.0,
                child: Image.network(ProjectDetails.URL_360),
              ),
            ),
            // Expanded(
            //   flex: 4,
            //   child: Container(
            //     color: primaryVariant_spray,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // void updateImageList(BuildContext context) async {
  //   for (int i = 1; i <= 52; i++) {
  //     imageList.add(Image.network(ProjectDetails.URL_360).image);
  //     //* To precache images so that when required they are loaded faster.
  //     await precacheImage(Image.network(ProjectDetails.URL_360).image, context);
  //   }
  //   setState(() {
  //     imagePrecached = true;
  //   });
  // }
}
