import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flirtbees/models/remote/base_response.dart';
import 'package:flirtbees/models/remote/user_response.dart';
import 'package:flirtbees/services/local_storage.dart';
import 'package:flirtbees/services/remote/api.dart';
import 'package:flirtbees/services/remote/user_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider(this.userApi, this.localStorage);

  final UserApi userApi;
  final LocalStorage localStorage;
  String imagePath;
  String networkAvatar;
  List<String> ages = <String>['from 18 to 24', 'from 25 to 34', 'from 35 to 44', 'from 45+'];
  String currentChoosingAge;
  String userName;
  String email;
  int ageIndex;

  Future<User> updateUserInfo(
      {String uid, int gender, Function onAuthorizationDioError}) async {
    try {
      final bool isValidateForm = await _validateForm();
      if (!isValidateForm) {
        return null;
      }
      final String avatar = await localStorage.getAvatar();
      final Response<dynamic> result = await userApi
          .updateUserInfo(User(ages: ageIndex, gender: gender, uid: uid, name: userName, avatar: avatar, email: email))
          .timeout(const Duration(seconds: 30));
      final UserResponse userResponse = UserResponse(result.data as Map<String, dynamic>);
      return userResponse.data;
    } on AuthorizationDioError {
      onAuthorizationDioError();
      return null;
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
      return null;
    }

  }

  Future<User> getUserInfo({Function onAuthorizationDioError}) async {
    try {
      final Response<dynamic> result = await userApi
          .getUserInfo()
          .timeout(const Duration(seconds: 30));
      final UserResponse userResponse = UserResponse(result.data as Map<String, dynamic>);
      userName = userResponse.data.name;
      email = userResponse.data.email;
      if (userResponse.data.ages != -1) {
        currentChoosingAge = ages[userResponse.data.ages];
      }
      await localStorage.setAvatar(avatar: userResponse.data.avatar);
      final String avatar = await localStorage.getAvatar();
      if (avatar != null) {
        if (avatar.contains('http') || avatar.contains('https')) {
          networkAvatar = avatar;
        } else {
          networkAvatar = '${Api.apiBaseUrl}/api/users/avatar/$avatar';
        }
      }
      notifyListeners();
      return userResponse.data;
    } on AuthorizationDioError {
      onAuthorizationDioError();
      return null;
    } catch (e) {
      if (e is BaseError) {
        Fluttertoast.showToast(msg: e.message);
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
      return null;
    }
  }

  Future<void> getImage(BuildContext context, {ImgSource source}) async {
    final dynamic file = await ImagePickerGC.pickImage(
        context: context,
        source: source ?? ImgSource.Both,
        cameraText: const Text('From Camera',style: TextStyle(color: Colors.red),),
        galleryText: const Text('From Gallery',style: TextStyle(color: Colors.blue),),
        barrierDismissible: true
    );
    if (file is File) {
      imagePath = await _resizeImage(file.path);
      notifyListeners();
      final Response<dynamic> result = await userApi.updateAvatar(imagePath);
      final Map<String, dynamic> map = result.data as Map<String, dynamic>;
      final String avatarId = map['data'] as String;
      await localStorage.setAvatar(avatar: avatarId);
    }
  }

  Future<String> _resizeImage(String path) async {
    final String targetPath = '${path.substring(0, path.length - 4)}_compressed.${path.substring(path.length - 3, path.length)}';
    await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 60,
        minHeight: 400,
        minWidth: 400,
        format: path.endsWith('png') ? CompressFormat.png : CompressFormat.jpeg
    );
    return targetPath;
  }

  void clearData() {
    userName = null;
    ageIndex = null;
    email = null;
    imagePath = null;
    networkAvatar = null;
    notifyListeners();
  }

  Future<bool> _validateForm() async {
    ageIndex = ages.indexOf(currentChoosingAge);

    if (userName == null || userName == '') {
      Fluttertoast.showToast(msg: 'Please enter user name');
      return false;
    }
    if (email == null) {
      Fluttertoast.showToast(msg: 'Please enter email');
      return false;
    }
    if (!email.isValidEmail()) {
      Fluttertoast.showToast(msg: 'Please enter valid email');
      return false;
    }

    return true;
  }


}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}