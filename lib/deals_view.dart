import 'dart:ui';

import 'package:dealcircles_flutter/deal_details.dart';
import 'package:dealcircles_flutter/theme_colors.dart';
import 'package:flutter/material.dart';

import 'Deal.dart';
import 'api_service.dart';

class DealsView extends StatefulWidget {
  @override
  _DealsViewState createState() => _DealsViewState();
}

class _DealsViewState extends State<DealsView> {
  List deals;
  bool loading = false;
  bool ableToLoadMore = true;
  String sort = "popular";
  String category;
  String search;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    deals = [];
    loadDeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.1,
        title: GestureDetector(
          onTap: () => _scrollController.animateTo(0,
              duration: Duration(seconds: 1), curve: Curves.ease),
          child: Text(
            'DealCircles',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        leading: Image.asset("assets/logo.png"),
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
                    onPressed: searchFilter,
                  ),
                ),
                onEditingComplete: searchFilter,
              ),
            ),
            addDrawerListTileHeader("Sort"),
            addDrawerListTile(
                "Most Popular",
                sort == "popular",
                () => setFilters(
                    sort: "popular", category: category, search: search)),
            addDrawerListTile(
                "Discount",
                sort == "discount",
                () => setFilters(
                    sort: "discount", category: category, search: search)),
            addDrawerListTile(
                "Price Low to High",
                sort == "low_high",
                () => setFilters(
                    sort: "low_high", category: category, search: search)),
            addDrawerListTile(
                "Price High to Low",
                sort == "high_low",
                () => setFilters(
                    sort: "high_low", category: category, search: search)),
            addDrawerListTileHeader("Categories"),
            addDrawerListTile("All", category == null,
                () => setFilters(category: null, search: null, sort: sort)),
            addDrawerListTile(
                "Women's Apparel",
                category == "Women%27%27s%20Apparel",
                () => setFilters(
                    category: "Women%27%27s%20Apparel",
                    search: null,
                    sort: sort)),
            addDrawerListTile("Shoes", category == "Shoes",
                () => setFilters(category: "Shoes", search: null, sort: sort)),
            addDrawerListTile("Beauty", category == "Beauty",
                () => setFilters(category: "Beauty", search: null, sort: sort)),
            addDrawerListTile(
                "Accessories",
                category == "Accessories",
                () => setFilters(
                    category: "Accessories", search: null, sort: sort)),
            addDrawerListTile("Home", category == "Home",
                () => setFilters(category: "Home", search: null, sort: sort)),
            addDrawerListTile(
                "Handbags",
                category == "Handbags",
                () =>
                    setFilters(category: "Handbags", search: null, sort: sort)),
          ],
        ),
      ),
      body: generateListview(context),
    );
  }

  void setFilters({String sort, String category, String search}) {
    this.sort = sort;
    this.category = category;
    this.search = search;

    if (search == null) {
      _textEditingController.clear();
    }
  }

  ListTile addDrawerListTileHeader(String name) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
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

  void searchFilter() {
    search = _textEditingController.text;
    if (search != null && search != '') {
      category = null;
      deals.clear();
      loadDeals();
      Navigator.pop(context);
    }
  }

  Widget generateListview(BuildContext context) {
    if (deals.length > 0) {
      return ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: deals.length + (ableToLoadMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < deals.length) {
            return makeCard(deals[index]);
          } else {
            return Card(
              elevation: 4.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              color: Theme.of(context).primaryColor,
              child: FlatButton(
                child: Text(
                  "Load More",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => loadDeals(),
              ),
            );
          }
        },
      );
    } else if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.remove_circle_outline,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                "No Results Found",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Check out popular deals"),
                ),
                textColor: Colors.white,
                onPressed: () {
                  setFilters();
                  loadDeals();
                },
              ),
            ],
          ),
        )
      );
    }
  }

  GestureDetector makeCard(Deal deal) {
    return GestureDetector(
      onTap: () {
        ApiService.addClicks(deal);
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
    return makeSmallListTile(deal);
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        deal.name,
                        style: TextStyle(color: Colors.black87, fontSize: 18),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " | ${deal.discount.toInt()}% Off",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
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
    setState(() {
      loading = true;
    });

    List newDeals =
        await ApiService.loadDeals(sort, category, search, deals.length);

    if (newDeals.length == 0) {
      setState(() {
        ableToLoadMore = false;
        loading = false;
      });
    } else {
      setState(() {
        ableToLoadMore = newDeals.length == 30;
        deals.addAll(newDeals);
        loading = false;
      });
    }
  }
}
