import 'dart:async';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:cunning_document_scanner/ios_options.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ElevatedButton(onPressed: onPressed, child: const Text("Add Pictures")),
            for (var picture in _pictures) Image.file(File(picture))
          ],
        )),
      ),
    );
  }

  void onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures(
            noOfPages: 1,
            isGalleryImportAllowed: true,
            androidOptions: const AndroidScannerOptions(
              scannerMode: AndroidScannerMode.scannerModeBase,
            ),
            iosScannerOptions: const IosScannerOptions(
              isFlashAllowed: true,
              isAutoScanAllowed: true,
              isAutoScanEnabled: true,
              useWeScan: true,
              noOfPages: 1,
              imageFormat: IosImageFormat.jpg,
            ),
          ) ??
          [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
      print("Pictures: $_pictures");
    } catch (exception) {
      // Handle exception here
    }
  }
}
