import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ios_options.dart';

class AndroidScannerOptions {
  const AndroidScannerOptions({
    this.isGalleryImportAllowed = false,
    this.scannerMode = AndroidScannerMode.scannerModeFull,
    this.noOfPages = 100,
  });

  final bool isGalleryImportAllowed;
  final AndroidScannerMode scannerMode;
  final int noOfPages;
}

enum AndroidScannerMode {
  scannerModeFull(
      1), // adds ML-enabled image cleaning capabilities (erase stains, fingers, etc…) to the SCANNER_MODE_BASE_WITH_FILTER mode.
  scannerModeBaseWithFilter(
      2), // Adds image filters (grayscale, auto image enhancement, etc…) to the SCANNER_MODE_BASE mode.
  scannerModeBase(3); // basic editing capabilities (crop, rotate, reorder pages, etc…).

  const AndroidScannerMode(this.value);
  final int value;
}

class CunningDocumentScanner {
  static const _defaultAndroidOptions = AndroidScannerOptions();
  static const _defaultIOSOptions = IosScannerOptions();

  static const MethodChannel _channel = MethodChannel('cunning_document_scanner');

  /// Call this to start get Picture workflow.
  static Future<List<String>?> getPictures({
    AndroidScannerOptions androidOptions = _defaultAndroidOptions,
    IosScannerOptions iosScannerOptions = _defaultIOSOptions,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) || statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    print('Options: $androidOptions, ${iosScannerOptions.useWeScan}');

    List<dynamic>? pictures;
    if (Platform.isAndroid) {
      pictures = await _channel.invokeMethod('getPictures', {
        'noOfPages': androidOptions.noOfPages,
        'isGalleryImportAllowed': androidOptions.isGalleryImportAllowed,
        'scannerMode': androidOptions.scannerMode.value,
      });
    } else if (Platform.isIOS) {
      pictures = await _channel.invokeMethod('getPictures', {
        'isGalleryImportAllowed': iosScannerOptions.isGalleryImportAllowed,
        'isAutoScanAllowed': iosScannerOptions.isAutoScanAllowed,
        'isAutoScanEnabled': iosScannerOptions.isAutoScanEnabled,
        'isFlashAllowed': iosScannerOptions.isFlashAllowed,
        'backgroundColor': iosScannerOptions.backgroundColor,
        'tintColor': iosScannerOptions.tintColor,
        'noOfPages': iosScannerOptions.noOfPages,
        'useWeScan': iosScannerOptions.useWeScan,
      });
    }
    return pictures?.map((e) => e as String).toList();
  }
}
