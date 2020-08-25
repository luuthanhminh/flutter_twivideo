
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SampleInfo {
  SampleInfo({this.title, this.breadCrumb});

  factory SampleInfo.fromJson(Map<String, dynamic> json) => SampleInfo(
      title: json['title'] as String,
      breadCrumb: List<String>.from(
          (json['breadCrumb'] as Iterable<String>).map<String>((String x) => x)));

  final String title;
  final List<String> breadCrumb;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'breadCrumb': List<dynamic>.from(breadCrumb.map<String>((String x) => x)),
  };
}

class LocalStorage {

  final String _headerInfoKey = 'header_info';
  final String _isSelectedGenderKey = 'is_selected_gender';
  final String _genderKey = 'gender_key';
  final String _userIdKey = 'user_id_key';
  final String _token = 'token';
  final String _avatar = 'avatar';
  final String _isAcceptAgreementKey = 'is_accept_agreement';
  final String _isGuestUserKey = 'is_guest_user_key';
  final String _trialContainSeconds = 'trial_contain_seconds';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> isSelectedGender() async {
    return (await _prefs).getBool(_isSelectedGenderKey) ?? false;
  }

  // Header
  Future<bool> saveHeaderInfo(SampleInfo headerInfo) async {
    final SharedPreferences prefs = await _prefs;
    final String headerInfoJson = jsonEncode(headerInfo.toJson());
    return prefs.setString(_headerInfoKey, headerInfoJson);
  }

  Future<SampleInfo> getHeaderInfo() async {
    final SharedPreferences prefs = await _prefs;
    final String headerInfoJson = prefs.getString(_headerInfoKey);
    if (headerInfoJson != null) {
      return SampleInfo.fromJson(
          jsonDecode(headerInfoJson) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> saveSelectedGender() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(_isSelectedGenderKey, true);
  }

  Future<void> setGender({int gender}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(_genderKey, gender);
  }

  Future<int> getGender() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(_genderKey);
  }

  Future<void> setUserId({String id}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_userIdKey, id);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_userIdKey);
  }

  Future<void> setToken({String token}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_token, token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_token);
  }

  Future<void> setAvatar({String avatar}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_avatar, avatar);
  }

  Future<String> getAvatar() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_avatar);
  }

  Future<void> saveAcceptAgreementStatus({bool isAccept}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(_isAcceptAgreementKey, isAccept);
  }

  Future<bool> getAcceptAgreementStatus() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(_isAcceptAgreementKey) ?? false;
  }

  Future<void> saveGuestUserStatus({bool isGuestUser}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(_isGuestUserKey, isGuestUser);
  }

  Future<bool> isGuestUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(_isGuestUserKey) ?? false;
  }

  Future<void> saveTrialContainSeconds({int seconds}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(_trialContainSeconds, seconds);
  }

  Future<int> getTrialContainSeconds() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(_trialContainSeconds) ?? 0;
  }
}
