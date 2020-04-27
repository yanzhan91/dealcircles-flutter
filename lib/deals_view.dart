import 'package:dealcircles_flutter/deal_details.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 28,
            ),
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
                Text(
                  deal.name,
                  style: TextStyle(color: Colors.black87, fontSize: 20),
                  maxLines: 3,
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
    )
//      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//      leading: CircleAvatar(
//        radius: 40,
//        backgroundImage: NetworkImage(
//          deal.img,
//        ), // no matter how big it is, it won't overflow
//      ),
//      leading: Container(
//        color: Colors.lightBlue,
//        child: Image.network(
//          deal.img,
//          fit: BoxFit.contain,
//        ),
//      ),
//      title: Text(
//        deal.name,
//        style: TextStyle(color: Colors.black87, fontSize: 20),
//      ),
//      subtitle: Row(
//        children: <Widget>[
//          Text(
//            "\$${deal.salePrice.toStringAsFixed(2)} ",
//            style: TextStyle(
//              color: ThemeColors.primary_color,
//              fontSize: 20,
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//          Text(
//            "| ${deal.discount}% Off",
//            style: TextStyle(color: Colors.black54, fontSize: 18),
//          ),
//        ],
//      ),
//      onTap: () {
////        Navigator.push(
////            context,
////            MaterialPageRoute(
////                builder: (context) => DetailPage(lesson: lesson)));
//      },
        );
  }

  List loadDeals() {
    return [
      new Deal("Chiara Boni La Petite Robe La Petite Robe", 456.0, 123.00, 60.0,
          "https://image.s5a.com/is/image/saks/0400097493761_247x329.jpg", "Saks Fifth Avenue"),
      new Deal("test2", 456.0, 123.00, 60.0,
          "https://image.s5a.com/is/image/saks/0400097493761_247x329.jpg", "Saks Fifth Avenue"),
      new Deal(
          "test3 test3 test3test3 test3 test3 test3 test3 test3",
          456.0,
          123.0,
          60.0,
          "https://image.s5a.com/is/image/saks/0400097493761_247x329.jpg", "Saks Fifth Avenue"),
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
