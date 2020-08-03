import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'Deal.dart';

class ApiService {
  static const String BASE_URL = "https://api.dealcircles.com";
  static String deviceId;
  static String deviceName;

  static void addClicks(Deal deal) async {
    Map<String, String> deviceInfo = await _getDeviceId();
    String url = "$BASE_URL/clicks";
    print(url);
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

  static Future<List> loadDeals(String sort, String category, String search,
      int length) async {
    Map<String, String> deviceInfo = await _getDeviceId();
    String url = "$BASE_URL/deals?"
        "deviceId=${deviceInfo['deviceId']}&deviceName=${deviceInfo['deviceName']}&offset=$length";

    List queryParam = [];
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

    print(url);
    final response = await http.get(url);
    List deals = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      data.forEach((r) => deals.add(Deal.fromJson(r)));
      return deals;
    } else {
      print('Failed to load deals ${response.statusCode}: ${response.body}');
      return [];
    }
  }

  static Future<Deal> loadSingleDeal(String id) async {
//    Map<String, String> deviceInfo = await _getDeviceId();
//    String url = "$BASE_URL/deals?id=$id&deviceId=${deviceInfo['deviceId']}&deviceName=${deviceInfo['deviceName']}";
//    print(url);
//    final response = await http.get(url);
//    if (response.statusCode == 200) {
//      final data = json.decode(response.body);
//      return Deal.fromJson(data);
//    } else {
//      print('Failed to load deals ${response.statusCode}: ${response.body}');
//      return null;
//    }
      final data = json.decode('{"id":"amzn-B012UTR2E0","brand":"Briarpatch","name":"Test Item","store":"Amazon","category":"2-4 Years","original":"\$26.99","new":"\$11.67","discount":57,"img":"https://m.media-amazon.com/images/I/61qQz6sZcHL.jpg","link":"https://www.amazon.com/dp/B012UTR2E0?tag=dealcircles-20&linkCode=osi&th=1&psc=1","clicks":8,"created_date":"2020-08-03 06:44:09.851727","valid":true,"source":"api","theme_id":null,"images":["https://m.media-amazon.com/images/I/51KOOhnGJoL.jpg"],"descriptions":["Test"],"themes":null}');
      return Deal.fromJson(data);
  }

  static Future<List> loadCategories() async {
    String url = "$BASE_URL/categories";
    print(url);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load deals ${response.statusCode}: ${response.body}');
      return [];
    }
  }

  static Future<Map<String, String>> _getDeviceId() async {
    if (deviceId == null || deviceName == null) {
      try {
        if (Platform.isAndroid) {
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
}
