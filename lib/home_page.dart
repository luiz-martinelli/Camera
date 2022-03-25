import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:cameraacesso/preview_page.dart';
import 'package:cameraacesso/widgets/anexo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? arquivo;
  final picker = ImagePicker();

  Future getFileFromGallery() async {
    PickedFile? file =
        (await picker.pickImage(source: ImageSource.gallery)) as PickedFile?;

    if (file != null) {
      setState(() => arquivo = File(file.path));
    }
  }

  showPreview(file) async {
    File? arq = await Get.to(() => PreviewPage(file: file));

    if (arq != null) {
      setState(() => arquivo = arq);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envie seu Comprovante'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (arquivo != null) Anexo(arquivo: arquivo!),
                ElevatedButton.icon(
                  onPressed: () => Get.to(
                    () => CameraCamera(onFile: (file) => showPreview(file)),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tire uma foto'),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      textStyle: const TextStyle(
                        fontSize: 18,
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('ou'),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Selecione um arquivo'),
                  onPressed: () => getFileFromGallery(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
