import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userid;
  Timer authtimer;

  Future<void> authenticate(
      String email, String password, String urlsegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyDcccGqwMHowCPs_NimO-bSViZ40L4OhBk";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userid = responsedata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));

      autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userid': _userid,
        'expirydata': _expirydate.toIso8601String()
      });
      prefs.setString('userdata', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  bool get isauth {
    return token != null;
  }

  String get userid {
    return _userid;
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> logout() async {
    _token = null;
    _expirydate = null;
    _userid = null;
    if (authtimer != null) {
      authtimer.cancel();
      authtimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autologout() {
    if (authtimer != null) {
      authtimer.cancel();
    }
    final timerdifference = _expirydate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timerdifference), logout);
  }

  Future<bool> autologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final userdata =
        json.decode(prefs.getString('userdata')) as Map<String, Object>;
    final expiraydata = DateTime.parse(userdata['expirydate']);
    if (expiraydata.isBefore(DateTime.now())) {
      return false;
    }
    _token = userdata['token'];
    _userid = userdata['userid'];
    _expirydate = expiraydata;
    notifyListeners();
    autologout();
    return true;
  }
}
