import 'dart:ui';

import 'package:dealcircles_flutter/deal_details.dart';
import 'package:dealcircles_flutter/theme_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Deal.dart';
import 'api_service.dart';

class DealsView extends StatefulWidget {
  @override
  _DealsViewState createState() => _DealsViewState();
}

class _DealsViewState extends State<DealsView> {
  List deals;
  List categories;
  bool loading = false;
  bool ableToLoadMore = true;
  String sort = "newest";
  String category;
  String search;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _setupFirebaseMessage() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('AppPushs onMessage : $message');
        if (message.containsKey('id')) {
          _showItemDialog(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('AppPushs onResume : $message');
        if (message.containsKey('id')) {
          _navigateWithId(message['id']);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('AppPushs onLaunch : $message');
        if (message.containsKey('id')) {
          _navigateWithId(message['id']);
        }
      },
    );
  }

  void _navigateWithId(String id) async {
    Deal deal = await ApiService.loadSingleDeal(id);
    Navigator.popUntil(context, (route) => route is PageRoute);
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => DealDetails(deal)));
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Deal of the Day',
                  style: TextStyle(
                    color: ThemeColors.primary_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20,),
                Image.network(
                  'https://m.media-amazon.com/images/I/41ijWyIC02L.jpg',
                  fit: BoxFit.contain,
                ),
                Text('Ravensburger Snail\'s Pace Race Game for Age 3 & Up - Quick Children\'s Racing Game Where Everyone Wins!',
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '\$100.00',
                      style: TextStyle(
                        color: ThemeColors.primary_color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " | 50% Off",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Close'),
                textColor: ThemeColors.primary_color,
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: const Text('Show'),
                textColor: ThemeColors.primary_color,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        }).then((bool shouldNavigate) {
          if (shouldNavigate != null && shouldNavigate) {
            _navigateWithId(message['id']);
          }
        });
  }

  @override
  void initState() {
    _setupFirebaseMessage();
    deals = [];
    categories = [];
    loadDeals();
    loadCategories();
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
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: generateFilterListView(context),
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
          fontSize: 18,
        ),
      ),
      enabled: false,
    );
  }

  ListTile addDrawerListTile(String name, bool selected, Function setValue) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontSize: 16),
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

  Widget generateFilterListView(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: TextField(
          controller: _textEditingController,
          onChanged: (text) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: _textEditingController.text.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _textEditingController.clear();
                        search = null;
                      });
                    },
                  )
                : null,
          ),
          onEditingComplete: () {
            search = _textEditingController.text;
            if (search == null || search == '') {
              search = null;
              _textEditingController.clear();
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            } else {
              category = null;
              deals.clear();
              loadDeals();
              Navigator.pop(context);
            }
          },
        ),
      ),
    );

    if ((sort != null && sort.isNotEmpty && sort != "newest") ||
        (category != null && category.isNotEmpty && category != "All") ||
        (search != null && search.isNotEmpty)) {
      widgets.add(
        ListTile(
          title: Text(
            "Clear",
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            deals.clear();
            setFilters(sort: "newest", category: null, search: null);
            loadDeals();
            Navigator.pop(context);
          },
        ),
      );
    }

    widgets.add(addDrawerListTileHeader("Sort"));
    widgets.add(addDrawerListTile("Newest", sort == "newest",
        () => setFilters(sort: "newest", category: category, search: search)));
    widgets.add(addDrawerListTile("Most Popular", sort == "popular",
        () => setFilters(sort: "popular", category: category, search: search)));
    widgets.add(addDrawerListTile(
        "Discount",
        sort == "discount",
        () =>
            setFilters(sort: "discount", category: category, search: search)));
    widgets.add(addDrawerListTile(
        "Price Low to High",
        sort == "low_high",
        () =>
            setFilters(sort: "low_high", category: category, search: search)));
    widgets.add(addDrawerListTile(
        "Price High to Low",
        sort == "high_low",
        () =>
            setFilters(sort: "high_low", category: category, search: search)));

    widgets.add(addDrawerListTileHeader("Categories"));
    widgets.add(addDrawerListTile("All", category == null,
        () => setFilters(category: null, search: null, sort: sort)));

    for (String c in categories) {
      widgets.add(addDrawerListTile(c, category == c,
          () => setFilters(category: c, search: null, sort: sort)));
    }

    return new ListView(children: widgets);
  }

  Widget generateListview(BuildContext context) {
    if (deals.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView.builder(
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
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
        ),
        onRefresh: loadDealsFuture,
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
                  child: Text("Check out latest deals"),
                ),
                textColor: Colors.white,
                onPressed: () {
                  setFilters(sort: "newest");
                  loadDeals();
                },
              ),
            ],
          ),
        ),
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
        child: Stack(
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: makeListTile(deal),
              ),
            ),
            addNewFlag(deal)
          ],
        ));
  }

  Widget addNewFlag(Deal deal) {
    DateTime now = DateTime.now().toUtc();
    if (now.year == deal.createDate.year &&
        now.month == deal.createDate.month &&
        now.day == deal.createDate.day) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.fiber_new,
            color: ThemeColors.primary_color,
          ),
        ),
      );
    } else {
      return new Container();
    }
  }

  Container makeListTile(Deal deal) {
    return makeSmallListTile(deal);
  }

  Container makeSmallListTile(Deal deal) {
    List<Widget> priceItems = [];
    priceItems.add(Text(
      deal.salePrice,
      style: TextStyle(
        color: deal.valid ? ThemeColors.primary_color : Colors.black54,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ));
    priceItems.add(Text(
      " | ${deal.discount}% Off" + (deal.valid ? "" : " | "),
      style: TextStyle(color: Colors.black54, fontSize: 16),
    ));
    if (!deal.valid) {
      priceItems.add(Text(
        "Expired",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ));
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.network(
                  deal.images.length > 0 ? deal.images[0] : deal.img,
                  fit: BoxFit.contain,
                  height: 80,
                  width: 80,
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          deal.brand,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(deal.name,
                            style: TextStyle(color: Colors.black87, fontSize: 18),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        Row(
                          children: priceItems,
                        )
                      ]
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      height: 152,
                      child: Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.whatshot,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Top Brand', style: TextStyle(color: Theme.of(context).primaryColor,),),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 10,),
                                  Text('4+ Stars', style: TextStyle(color: Theme.of(context).primaryColor,),),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Deal of the Day', style: TextStyle(color: Theme.of(context).primaryColor,),),
                                ],
                              )
                            ],
                          ),
                          Positioned(
                            top: -90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/icon_120.jpg",
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(40, 50, 40, 0),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 60,
                  height: 40,
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (deal.themes.contains("TopBrand"))
                          Icon(
                            Icons.whatshot,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        if (deal.themes.contains("FourStars"))
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        if (deal.themes.contains("DealOfTheDay"))
                          Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          )
                      ],
                    ),
                  ),
                )
              )
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

  Future<void> loadDealsFuture() async {
    deals.clear();
    loadDeals();
  }

  void loadCategories() async {
    List temp = await ApiService.loadCategories();
    setState(() {
      categories = temp;
    });
  }
}
