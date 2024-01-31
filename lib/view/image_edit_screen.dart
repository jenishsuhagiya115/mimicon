import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../const/app_color.dart';
import '../const/app_icon.dart';
import '../main.dart';
import 'green_ponter_screen.dart';

class ImageEditingScreen extends StatefulWidget {
  final String imagePath;

  const ImageEditingScreen({required this.imagePath});

  @override
  _ImageEditingScreenState createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  late File _imageFile;
  late List<Face> _faces;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.imagePath);
    _faces = [];

    // Detect faces when the screen is initialized
    _detectFaces();
  }

  void _detectFaces() async {
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);

    setState(() {
      _faces = faces;
    });

    if (_faces.length > 2) {
      Fluttertoast.showToast(msg: 'More than 2 faces detected');
    }
  }

  void _onCanvasTap(double x, double y) {
    // Assuming you want to place a green square at the tapped location
    final newFace = Face(
      boundingBox: Rect.fromPoints(
        Offset(x - 50, y - 50), // Adjust the size and position as needed
        Offset(x + 50, y + 50),
      ),
      headEulerAngleY: 0,
      headEulerAngleZ: 0,
      leftEyeOpenProbability: 1.0,
      rightEyeOpenProbability: 1.0,
      smilingProbability: 1.0, landmarks: {}, contours: {},
    );

    setState(() {
      _faces = [..._faces, newFace];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackColor,
      appBar: AppBar(backgroundColor: AppColor.blackColor,
        actions: [
          AppIcon.moreIcon,
          SizedBox(width: width/22)
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: width/22),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: AppIcon.closeIcon),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Image.file(_imageFile, fit: BoxFit.cover)),
                GestureDetector(
                  onPanUpdate: (details) {
                    _onCanvasTap(details.globalPosition.dx, details.globalPosition.dy);
                  },
                  child: CustomPaint(
                    painter: GreenPainter(_faces),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width/20),
              child: Column(
                children: [
                  SizedBox(height: height/30),
                  Row(
                    children: [
                      Icon(Icons.arrow_back,color: AppColor.whiteColor),
                      SizedBox(width: width/40),
                      Text("다시찍기",style: TextStyle(color: AppColor.whiteColor,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  SizedBox(height: height/30),
                  Row(
                    children: [
                      FloatingActionButton(
                          backgroundColor: AppColor.whiteColor,
                          onPressed: () {
                          },
                          child: const Text("눈")
                      ),
                      SizedBox(width: width/50),
                      FloatingActionButton(
                          backgroundColor: AppColor.whiteColor,
                          onPressed: () {
                          },
                          child: const Text("입")
                      ),
                    ],
                  ),
                  SizedBox(height: height/20),
                  SizedBox(
                    width: width,
                    height: height/15,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.purpleColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Face detection successfully");
                        }, child: Text("저장하기",style: TextStyle(color: AppColor.whiteColor),)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}