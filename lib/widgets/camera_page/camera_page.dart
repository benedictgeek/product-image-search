import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras;
  CameraController cameraController;
  int curentlySelectedOption = 0;
  bool isBackCamera = true;
  String _selectedFilePath = "";
  @override
  void initState() {
    super.initState();
    initCamera();
    // setGalleryThumbnail();
  }

  void initCamera() async {
    cameras = await availableCameras();
    if (isBackCamera) {
      cameraController = CameraController(cameras[0], ResolutionPreset.high);
    } else {
      cameraController = CameraController(cameras[1], ResolutionPreset.high);
    }
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<String> takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);

    final String filePath = '$dirPath/${DateTime.now().toString()}.jpg';

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await cameraController.takePicture(filePath);
    } on CameraException catch (e) {
      print(e.toString());
      return null;
    }
    return filePath;
  }

  void onGetImageFromGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    _selectedFilePath = pickedImage.path;
    setState(() {});
  }

  void onTakePicture() {
    takePicture().then((filePath) {
      _selectedFilePath = filePath;
      setState(() {});
    });
  }

  // void setGalleryThumbnail() async {
  //   // final Directory = await Directory(path)
  //   final Directory appDir = await getExternalStorageDirectory();
  //   final String picturesDir = "${appDir.path}/Camera/";
  //   Directory(picturesDir).list().forEach((FileSystemEntity fileEntity) {
  //     print(fileEntity.path);
  //   });
  // }

  Widget buildOptionText({String title, int index}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: index != curentlySelectedOption
                ? Colors.transparent
                : Theme.of(context).primaryColor,
            width: 2.5,
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.body1.copyWith(
            color: Colors.white,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized)
      return Container();
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: <Widget>[
        AspectRatio(
          aspectRatio: cameraController.value.aspectRatio,
          child: CameraPreview(cameraController),
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: onGetImageFromGallery,
                child: FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.white,
                ),
              ),
              if (cameras.length > 1)
                InkWell(
                  onTap: () {
                    isBackCamera = !isBackCamera;
                    initCamera();
                  },
                  child: SizedBox(
                    height: 35,
                    child: Image.asset(
                      "public/images/switch-camera.png",
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: Row(
            children: <Widget>[
              buildOptionText(
                title: "SEARCH",
                index: 0,
              ),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    InkWell(
                      onTap: onTakePicture,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 25,
                      ),
                    )
                  ],
                ),
              ),
              buildOptionText(
                title: "PRIVATE",
                index: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
