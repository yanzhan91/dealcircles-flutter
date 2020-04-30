import 'dart:convert';
import 'dart:math';

import 'package:dealcircles_flutter/deal_details.dart';
import 'package:dealcircles_flutter/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Deal.dart';

class DealsView extends StatefulWidget {
  @override
  _DealsViewState createState() => _DealsViewState();
}

class _DealsViewState extends State<DealsView> {
  List deals;
  String sort = "popular";
  String category;
  String search;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  Random random = Random.secure();

  @override
  void initState() {
    deals = [];
    loadDeals();
//    _scrollController
//      ..addListener(() {
//        if (_scrollController.position.pixels >
//            0.8 * _scrollController.position.maxScrollExtent) {
//          loadDeals();
//        }
//      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.1,
        title: Text(
          'DealCircles',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        leading: Image.asset("assets/test.png"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.tune,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
          )
        ],
      ),
      endDrawer: Drawer(
        child: new ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: TextField(
                controller: _textEditingController,
                onSubmitted: (String str) => search = str,
                decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      search = _textEditingController.text;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            addDrawerListTileHeader("Sort"),
            addDrawerListTile(
                "Most Popular", sort == "popular", () => sort = "popular"),
            addDrawerListTile(
                "Discount", sort == "discount", () => sort = "discount"),
            addDrawerListTile("Price Low to High", sort == "low_high",
                () => sort = "low_high"),
            addDrawerListTile("Price High to Low", sort == "high_low",
                () => sort = "high_low"),
            addDrawerListTileHeader("Categories"),
            addDrawerListTile("Women's Apparel", category == "Women's Apparel",
                () => category = "Women's Apparel"),
            addDrawerListTile(
                "Shoes", category == "Shoes", () => category = "Shoes"),
            addDrawerListTile(
                "Beauty", category == "Beauty", () => category = "Beauty"),
            addDrawerListTile("Kids", category == "Kids", () => category = "Kids"),
          ],
        ),
      ),
      body: generateListview(context),
    );
  }

  ListTile addDrawerListTileHeader(String name) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      enabled: false,
    );
  }

  ListTile addDrawerListTile(String name, bool selected, Function setValue) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontSize: 18),
      ),
      selected: selected,
      onTap: () {
        deals.clear();
        setValue();
        loadDeals();
        Navigator.pop(context);
      },
    );
  }

  Widget generateListview(BuildContext context) {
    if (deals.length > 0) {
      return ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: deals.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(deals[index]);
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    }
  }

  GestureDetector makeCard(Deal deal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DealDetails(deal)));
      },
      child: Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: makeListTile(deal),
        ),
      ),
    );
  }

  Container makeListTile(Deal deal) {
//    if (random.nextInt(6) % 5 == 0) {
//      return makeBigListTile(deal);
//    } else {
    return makeSmallListTile(deal);
//    }
  }

  Container makeBigListTile(Deal deal) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Image.network(
                deal.img,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    deal.brand,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    deal.name,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        deal.salePrice,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        " | ${deal.discount.toInt()}% Off",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container makeSmallListTile(Deal deal) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          children: <Widget>[
            Image.network(
              deal.img,
              fit: BoxFit.contain,
              height: 80,
              width: 80,
            ),
            SizedBox(width: 15),
            new Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        deal.brand,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        deal.name,
                        style: TextStyle(color: Colors.black87, fontSize: 20),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        deal.salePrice,
                        style: TextStyle(
                          color: ThemeColors.primary_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " | ${deal.discount.toInt()}% Off",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadDeals() async {
    String url =
        "https://vv1uocmtb7.execute-api.us-east-1.amazonaws.com/deals?offset=${deals.length}";

    List queryParam = [];
    if (sort != null) {
      queryParam.add("sort=$sort");
    }
    if (category != null) {
      queryParam.add("filter=$category");
    }
    if (search != null) {
      queryParam.add("search=$search");
    }
    if (queryParam.length > 0) {
      url += ("&" + queryParam.join("&"));
    }

    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => data.forEach((r) => deals.add(Deal.fromJson(r))));
    } else {
      throw Exception(
          'Failed to load deals ${response.statusCode}: ${response.body}');
    }
  }
}
