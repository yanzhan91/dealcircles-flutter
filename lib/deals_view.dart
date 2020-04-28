import 'dart:convert';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    deals = [];
    loadDeals();
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels >
            0.8 * _scrollController.position.maxScrollExtent) {
          loadDeals();
        }
      });
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
        leading: Icon(
          Icons.cloud_circle,
          color: Colors.white,
          size: 28,
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
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
                  decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
//                      onPressed: () => _controller.clear(),
                    ),
                  ),
                )),
            ListTile(
              title: Text(
                "Sort",
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              enabled: false,
            ),
            ListTile(
              title: Text("Discount"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Price Low to High"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Price High to Low"),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Categories",
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              enabled: false,
            ),
            ListTile(
              title: Text("Women's Apparel"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Shoes"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Beauty"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Kids"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: generateListview(context),
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
          AlwaysStoppedAnimation<Color>(Theme
              .of(context)
              .primaryColor),
//          backgroundColor: Theme.of(context).primaryColor,
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
                        "\$${deal.salePrice.toStringAsFixed(2)} ",
                        style: TextStyle(
                          color: ThemeColors.primary_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "| ${deal.discount}% Off",
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
    String key = "";
    if (deals.length > 0) {
      key = "/" + deals[deals.length - 1].id;
    }
    final response = await http.get(
        "https://vv1uocmtb7.execute-api.us-east-1.amazonaws.com/dc_fetch_deals" +
            key);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => data.forEach((r) => deals.add(Deal.fromJson(r))));
    } else {
      throw Exception('Failed to load deals');
    }
  }
}
