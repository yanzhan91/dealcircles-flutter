import 'package:dealcircles_flutter/theme_colors.dart';
import 'package:flutter/material.dart';

import 'Deal.dart';

class DealsView extends StatefulWidget {
  @override
  _DealsViewState createState() => _DealsViewState();
}

class _DealsViewState extends State<DealsView> {
  List deals;

  @override
  void initState() {
    deals = loadDeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text('DealCircles'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: deals.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(deals[index]);
        },
      ),
    );
  }

  Card makeCard(Deal deal) {
    return Card(
      elevation: 4.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTile(deal),
      ),
    );
  }

  ListTile makeListTile(Deal deal) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        color: Colors.lightBlue,
        child: Image.network(
          "https://image.s5a.com/is/image/saks/0400012131789_247x329.jpg",
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        deal.name,
        style: TextStyle(color: Colors.black87, fontSize: 20),
      ),
      subtitle: Row(
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
      ),
      onTap: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => DetailPage(lesson: lesson)));
      },
    );
  }

  List loadDeals() {
    return [
      new Deal("Chiara Boni La Petite Robe La Petite Robe", 456.0, 123.00, 60.0),
      new Deal("test2", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3 test3 test3test3 test3 test3 test3 test3 test3", 456.0,
          123.0, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
      new Deal("test3", 456.0, 123.00, 60.0),
    ];
//    String url = ApiConstants.BASE_URL +
//        ApiConstants.RESTAURANT_WITH_CHAIN_ID +
//        '?chainId=${widget.chainId}';
//    final response = await http.get(url);
//
//    if (response.statusCode == 200) {
//      final data = json.decode(response.body);
//      setState(() => data.forEach((r) => addresses.add(r['address'])));
//    }
  }
}
