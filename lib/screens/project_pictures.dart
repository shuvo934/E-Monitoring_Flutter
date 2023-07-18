import 'package:e_monitoring/lists/photos.dart';
import 'package:e_monitoring/response/api_response.dart';
import 'package:e_monitoring/screens/picture_zoom.dart';
import 'package:e_monitoring/services/networking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ProjectPictures extends StatefulWidget {
  static const String id = 'project_pictures';

  final pcmId;

  ProjectPictures({this.pcmId});

  @override
  State<ProjectPictures> createState() => _ProjectPicturesState();
}

class _ProjectPicturesState extends State<ProjectPictures> {
  bool conn = false;
  List<Photos> photos = [];
  bool noPhotos = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
              child: const Text(
                'PROJECT PHOTOS:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  fontFamily: 'CantoraOne',
                ),
              ),
            ),
            Visibility(
              visible: noPhotos,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 5, right: 5, top: 5, bottom: 10),
                alignment: Alignment.center,
                child: const Text(
                  'No Photos Found',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto-Medium',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return PhotoWidget(photos[index].photoName.toString(),
                          photos[index].stage.toString(), imageDialCallback);
                    }),
              ),
            )
          ],
        ),
      ),
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
                getImage();
              },
            ),
          ],
        );
      },
    );
  }

  void getImage() async {
    showLoaderDialog(context);
    conn = false;
    photos = [];

    String imageUrl =
        "http://103.56.208.123:8086/terrain/bridge_culvert/images/getImages?pcm_id=${widget.pcmId}";

    NetworkHelper networkHelper = NetworkHelper(imageUrl);
    var imageData = await networkHelper.getData();

    if (imageData != null) {
      ApiResponse imageResponse = ApiResponse.fromJson(imageData);
      int count = imageResponse.count;
      if (count != 0) {
        for (int i = 0; i < imageResponse.items.length; i++) {
          var ud_db_generated_file_name =
              imageResponse.items[i]['ud_db_generated_file_name'];
          var ud_date = imageResponse.items[i]['ud_date'];
          var ud_doc_upload_stage =
              imageResponse.items[i]['ud_doc_upload_stage'];

          String stype = "";
          switch (ud_doc_upload_stage.toString()) {
            case "1":
              stype = "Before Construction";
              break;
            case "2":
              stype = "During Construction";
              break;
            case "3":
              stype = "After Construction";
              break;
          }
          String url = "";
          url = "http://103.56.208.123:8863/assets/project_image/" +
              ud_db_generated_file_name.toString();

          photos.add(Photos(url, ud_date, stype));
        }
      }
      conn = true;
      updatePicUi();
    } else {
      conn = false;
      updatePicUi();
    }
  }

  void updatePicUi() async {
    Navigator.pop(context);
    if (conn) {
      if (photos.isEmpty) {
        noPhotos = true;
      } else {
        noPhotos = false;
      }
      setState(() {});
    } else {
      _noConnectionDialogue();
    }
  }

  void imageDialCallback(String url) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PictureZoom(url)));
  }
}

class PhotoWidget extends StatelessWidget {
  String imageUrl;
  String status;
  Function imageDial;

  PhotoWidget(this.imageUrl, this.status, this.imageDial);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () => imageDial(imageUrl),
        child: Card(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                height: 350,
                child: (defaultTargetPlatform == TargetPlatform.android ||
                        defaultTargetPlatform == TargetPlatform.iOS)
                    ? OptimizedCacheImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image.network(imageUrl),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.topLeft,
                child: const Text(
                  'Status:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(5),
                child: Text(
                  status,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
