import 'dart:ui';

import 'package:dealcircles_flutter/deals_detail/deal_details.dart';
import 'package:dealcircles_flutter/deals_view/deals_list_view.dart';
import 'package:dealcircles_flutter/deals_view/zero_deal_view.dart';
import 'package:dealcircles_flutter/models/screen_size.dart';
import 'package:dealcircles_flutter/services/screen_size_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/Deal.dart';
import '../services/api_service.dart';

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
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _textEditingController =
      new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _setupFirebaseMessage() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((value) => print(value));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('AppPushs onMessage : $message');
        if (message.containsKey('id')) {
          _showItemDialog(message['id'], message['image'], message['name'],
              message['price'], message['discount']);
        } else if (message.containsKey('data')) {
          Map<dynamic, dynamic> data = message['data'];
          if (data.containsKey('id')) {
            _showItemDialog(data['id'], data['image'], data['name'],
                data['price'], data['discount']);
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('AppPushs onResume : $message');
        if (message.containsKey('id')) {
          _navigateWithId(message['id']);
        } else if (message.containsKey('data')) {
          Map<dynamic, dynamic> data = message['data'];
          if (data.containsKey('id')) {
            _navigateWithId(data['id']);
          }
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('AppPushs onLaunch : $message');
        if (message.containsKey('id')) {
          _navigateWithId(message['id']);
        } else if (message.containsKey('data')) {
          Map<dynamic, dynamic> data = message['data'];
          if (data.containsKey('id')) {
            _navigateWithId(data['id']);
          }
        }
      },
    );
  }

  void _navigateWithId(String id) async {
    if (id != null && id.length > 0) {
      List<Deal> deals = await ApiService.loadDeals(id, null, null, null, null);
      if (deals.length > 0) {
        Navigator.popUntil(context, (route) => route is PageRoute);
        Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => DealDetails(deals[0])));
      }
    }
  }

  void _showItemDialog(
      String id, String image, String name, String price, String discount) {
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (image != null)
                  Image.network(
                    image,
                    fit: BoxFit.fill,
                  ),
                Text(name,
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "$price",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " | $discount% Off",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Close'),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: const Text('Show'),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        }).then((bool shouldNavigate) {
      if (shouldNavigate != null && shouldNavigate) {
        _navigateWithId(id);
      }
    });
  }

  @override
  void initState() {
    if (!kIsWeb) {
      _setupFirebaseMessage();
    }
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
        width: MediaQuery.of(context).size.width *
            (ScreenSizeService.compareSize(context, ScreenSize.SMALL)
                ? 0.6 : 0.25),
        child: Drawer(
          child: generateFilterListView(context),
        ),
      ),
      body: generateListview(context),
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

  void setFilters({String sort, String category, String search}) {
    this.sort = sort;
    this.category = category;
    this.search = search;

    if (search == null) {
      _textEditingController.clear();
    }
  }

  Widget generateListview(BuildContext context) {
    if (deals.length > 0) {
      return DealsListView(
          _scrollController, deals, ableToLoadMore, loadDeals, loadDealsFuture);
    } else if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      setFilters(sort: 'newest');
      return ZeroDealView(loadDeals);
    }
  }

  void loadDeals() async {
    setState(() {
      loading = true;
    });

    List newDeals =
        await ApiService.loadDeals(null, sort, category, search, deals.length);

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
