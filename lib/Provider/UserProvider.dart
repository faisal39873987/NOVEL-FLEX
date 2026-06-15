import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;

  UserProvider(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  String? get UserEmail => _sharedPreferences.getString("emailu");
  String? get SelectedLanguage => _sharedPreferences.getString("lngu");

  String? get UserName => _sharedPreferences.getString("nameu");

  String? get UserToken => _sharedPreferences.getString("tok");

  String? get UserImage => _sharedPreferences.getString("img");

  String? get UserID => _sharedPreferences.getString("user_id");

  String? get GetApple => _sharedPreferences.getString("apple");

  String? get GetReferral => _sharedPreferences.getString("referral_code");

  bool get IsGuest => _sharedPreferences.getBool("guest_mode") ?? false;

  int? get GetSavedTime => _sharedPreferences.getInt("day_time");

  int? get getNotificationCount => _sharedPreferences.getInt("notifications");

  void setUserEmail(String email) async {
    _sharedPreferences.setString("emailu", email);
    notifyListeners();
  }

  void setLanguage(String lang) async {
    _sharedPreferences.setString("lngu", lang);
    notifyListeners();
  }

  void setUserName(String name) async {
    _sharedPreferences.setString("nameu", name);
    notifyListeners();
  }

  void setUserToken(String token) async {
    _sharedPreferences.setString("tok", token);
    notifyListeners();
  }

  void setUserImage(String token) async {
    _sharedPreferences.setString("img", token);
    notifyListeners();
  }

  void setApple(String appleEmail) async {
    _sharedPreferences.setString("apple", appleEmail);
    notifyListeners();
  }

  void setReferral(String referralCode) async {
    _sharedPreferences.setString("referral_code", referralCode);
    notifyListeners();
  }

  void setUserID(String id) async {
    _sharedPreferences.setString("user_id", id);
    notifyListeners();
  }

  void setSavedDate(int time) async {
    _sharedPreferences.setInt("day_time", time);
    notifyListeners();
  }

  void setNotificationsCount(int notifications) async {
    _sharedPreferences.setInt("notifications", notifications);
    notifyListeners();
  }

  void setGuestMode(bool isGuest) async {
    _sharedPreferences.setBool("guest_mode", isGuest);
    notifyListeners();
  }

  void clearUserSession({bool preserveLanguage = true}) async {
    _sharedPreferences.setString("emailu", "");
    _sharedPreferences.setString("nameu", "");
    _sharedPreferences.setString("tok", "");
    _sharedPreferences.setString("img", "");
    _sharedPreferences.setString("user_id", "");
    _sharedPreferences.setString("apple", "");
    _sharedPreferences.setString("referral_code", "");
    _sharedPreferences.setInt("day_time", 0);
    _sharedPreferences.setBool("guest_mode", false);
    if (!preserveLanguage) {
      _sharedPreferences.setString("lngu", "");
    }
    notifyListeners();
  }

  void startGuestSession() async {
    clearUserSession();
    _sharedPreferences.setBool("guest_mode", true);
    notifyListeners();
  }
}
