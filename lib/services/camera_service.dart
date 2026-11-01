import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> capture() => _select(ImageSource.camera);
  Future<File?> selectFromGallery() => _select(ImageSource.gallery);

  Future<File?> _select(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();
    if (status.isPermanentlyDenied || status.isRestricted) {
      throw PermissionException('Permiso denegado. Actívalo desde los ajustes.');
    }
    if (!status.isGranted && !status.isLimited) {
      throw PermissionException('No se concedió el permiso solicitado.');
    }

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (picked == null) return null;

    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 82,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Ajustar imagen',
          toolbarColor: const Color.fromARGB(255, 17, 25, 41),
          toolbarWidgetColor: const Color(0xFFFFFFFF),
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Ajustar imagen'),
      ],
    );
    return File(cropped?.path ?? picked.path);
  }
}

class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);
  @override
  String toString() => message;
}
