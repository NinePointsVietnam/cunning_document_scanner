import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'android_options.dart';
import 'ios_options.dart';

export 'android_options.dart';
export 'ios_options.dart';

class CunningDocumentScanner {
  static const _defaultAndroidOptions = AndroidScannerOptions();
  static const _defaultIOSOptions = IosScannerOptions();

  static const MethodChannel _channel = MethodChannel('cunning_document_scanner');

  /// Call this to start get Picture workflow.
  static Future<List<String>?> getPictures({
    noOfPages = 100,
    isGalleryImportAllowed = false,
    AndroidScannerOptions androidOptions = _defaultAndroidOptions,
    IosScannerOptions iosScannerOptions = _defaultIOSOptions,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied) || statuses.containsValue(PermissionStatus.permanentlyDenied)) {
      throw Exception("Permission not granted");
    }

    List<dynamic>? pictures;
    if (Platform.isAndroid) {
      pictures = await _channel.invokeMethod('getPictures', {
        'noOfPages': noOfPages,
        'isGalleryImportAllowed': isGalleryImportAllowed,
        'scannerMode': androidOptions.scannerMode.value,
      });
    } else if (Platform.isIOS) {
      pictures = await _channel.invokeMethod('getPictures', {
        'isGalleryImportAllowed': isGalleryImportAllowed,
        'isAutoScanAllowed': iosScannerOptions.isAutoScanAllowed,
        'isAutoScanEnabled': iosScannerOptions.isAutoScanEnabled,
        'isFlashAllowed': iosScannerOptions.isFlashAllowed,
        'backgroundColor': iosScannerOptions.backgroundColor ?? Color(0xFF333333).toARGB32(),
        'tintColor': iosScannerOptions.tintColor ?? Colors.white.toARGB32(),
        'noOfPages': noOfPages,
        'useWeScan': iosScannerOptions.useWeScan,
      });
    } else {
      pictures = await _channel.invokeMethod('getPictures', {
        'noOfPages': noOfPages,
        'isGalleryImportAllowed': isGalleryImportAllowed,
      });
    }

    return pictures?.map((e) => e as String).toList();
  }
}
