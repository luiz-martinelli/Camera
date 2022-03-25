import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final picker = ImagePicker();
  late File _selectedImage;
  bool _inProcess = false;

  getImage(ImageSource src) async {
    setState(() {
      _inProcess = true;
    });
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      File cropped = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Camera',
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Camera',
        ),
      );
      setState(() {
        _selectedImage = cropped;
        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: (_inProcess)
          ? Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ignore: unnecessary_null_comparison
                _selectedImage != null
                    ? Image.file(
                        _selectedImage,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(
                        width: 250,
                        height: 250,
                        child: Icon(
                          Icons.camera_alt,
                          size: 200,
                          color: Colors.grey,
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      child: const Text('Camera'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      child: const Text('Galeria'),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
