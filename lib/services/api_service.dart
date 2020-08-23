import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/Deal.dart';

class ApiService {
  static const String BASE_URL = "https://api.dealcircles.com";
  static String deviceId;
  static String deviceName;

  static void addClicks(Deal deal) async {
    Map<String, String> deviceInfo = await _getDeviceId();
    String url = "$BASE_URL/clicks";
    _printUrl(url);
    http.post(
      url,
      body: jsonEncode(
          <String, String>{
            'id': deal.id,
            'deviceId': deviceInfo['deviceId'],
            'deviceName': deviceInfo['deviceName']
          }),
    );
  }

  static Future<List<Deal>> loadDeals(String id, String sort, String category, String search,
      int length) async {

    Map<String, String> deviceInfo = await _getDeviceId();
    String url = "$BASE_URL/deals?"
        "deviceId=${deviceInfo['deviceId']}&deviceName=${deviceInfo['deviceName']}&offset=$length";

    List queryParam = [];
    if (id != null) {
      queryParam.add("id=$id");
    }
    if (sort != null) {
      queryParam.add("sort=$sort");
    }
    if (category != null) {
      queryParam.add("category=$category");
    }
    if (search != null) {
      queryParam.add("search=$search");
    }
    if (queryParam.length > 0) {
      url += ("&" + queryParam.join("&"));
      url = Uri.encodeFull(url);
    }

    _printUrl(url);

//    return [
//      Deal('', 'sort = $sort', [], 'category = $category', '', 'search = $search', 0, '', [], '', '', DateTime.now(), false, {}),
//    ];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Deal.fromJson(e)).toList();
    } else {
      _printUrl('Failed to load deals ${response.statusCode}: ${response.body}');
      return [];
    }
  }

  static Future<List> loadCategories() async {
    String url = "$BASE_URL/categories";
    _printUrl(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _printUrl('Failed to load deals ${response.statusCode}: ${response.body}');
      return [];
    }
  }

  static Future<void> contactUs(String email, String message) async {
    String url = "$BASE_URL/contact";
    _printUrl(url);
    String body = '$email\n\n$message';
    http.post(url, body: body);
  }

  static Future<Map<String, String>> _getDeviceId() async {
    if (deviceId == null || deviceName == null) {
      try {
        if (kIsWeb) {
          deviceId = 'web';
          deviceName = 'web';
        } else if (Platform.isAndroid) {
          AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
          deviceId = androidDeviceInfo.androidId;
          deviceName = androidDeviceInfo.isPhysicalDevice ? androidDeviceInfo.device : 'virtual';
        } else if (Platform.isIOS) {
          IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
          deviceId = iosDeviceInfo.identifierForVendor;
          deviceName = iosDeviceInfo.isPhysicalDevice ? iosDeviceInfo.name : 'virtual';
        } else if (kIsWeb) {
          deviceId = 'web';
          deviceName = 'web';
        }
      } on Exception {
        deviceId = '';
        deviceName = '';
      }
    }

    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
    };
  }

  static void _printUrl(String url) {
    if (!kIsWeb) {
      print(url);
    }
  }
}
