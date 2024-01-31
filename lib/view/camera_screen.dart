import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../const/app_color.dart';
import '../const/app_icon.dart';
import '../main.dart';
import 'image_edit_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool isLoadInitialize = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  void _initializeCamera() async {
    setState(() {
      isLoadInitialize = true;
    });
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);

    // Ensure that the camera is initialized
    await _cameraController.initialize();

    if (mounted) {
      setState(() {});
    }
    setState(() {
      isLoadInitialize = false;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    final image = await _cameraController.takePicture();
    _navigateToImageEditingScreen(image.path);
  }
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile?  pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _navigateToImageEditingScreen(pickedFile.path);
    }
  }

  void _navigateToImageEditingScreen(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditingScreen(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColor.blackColor,
      appBar: AppBar(backgroundColor: AppColor.blackColor,
        actions: [
          AppIcon.moreIcon,
          SizedBox(width: width/22)
        ],
      ),
      body: _cameraController == null || !_cameraController.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: height/1.8,
                width: double.infinity,
                child: CameraPreview(_cameraController)),
            SizedBox(height: height/45),
            GestureDetector(
                onTap: () => _captureImage(),
                child: customCameraClickIcon()),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width/20),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () => _pickImage(),
                      child: AppIcon.gelleryIcon),
                  const Spacer(),
                  AppIcon.refreshIcon
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget customCameraClickIcon(){
    return CircleAvatar(
      radius: height/22,
      backgroundColor: AppColor.whiteColor,
      child: CircleAvatar(
        radius: height/24,
        backgroundColor: AppColor.blackColor,
        child: CircleAvatar(radius: height/26,backgroundColor: AppColor.whiteColor,),
      ),
    );
  }
}