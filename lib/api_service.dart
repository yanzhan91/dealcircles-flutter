import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Deal.dart';

class ApiService {
  static const String BASE_URL =
      "https://vv1uocmtb7.execute-api.us-east-1.amazonaws.com";

  static void addClicks(Deal deal) async {
    String url = "$BASE_URL/clicks?id=${deal.id}";
    print(url);
    http.post(url);
  }

  static Future<List> loadDeals(
      String sort, String category, String search, int length) async {
    String url = "$BASE_URL/deals?offset=$length";

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
}
