import 'dart:ui';

import 'package:dealcircles_flutter/deals_detail/deal_details.dart';
import 'package:dealcircles_flutter/deals_view/web_footer.dart';
import 'package:dealcircles_flutter/deals_view/zero_deal_view.dart';
import 'package:dealcircles_flutter/models/screen_size.dart';
import 'package:dealcircles_flutter/services/screen_size_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Deal.dart';
import '../services/api_service.dart';
import 'custom_sliver_appbar.dart';
import 'deal_card.dart';
import 'filter_drawer.dart';

class DealsView extends StatefulWidget {
  final String id;

  const DealsView({this.id});

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
    } else {
      if (widget.id != null && widget.id.isNotEmpty) {
        ApiService.loadDeals(widget.id, null, null, null, 0).then((value) => {
          if (value != null && value.length > 0) {
            if (ScreenSizeService.compareSize(context, ScreenSize.SMALL)) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => DealDetails(value[0])))
            } else {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 1.75,
                    child: DealDetails(value[0]),
                  ),
                );
              })
            }
          }
        });
      }
    }
    deals = [];
    categories = [];
    loadDeals();
    _loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => _scrollController.animateTo(0,
              duration: Duration(seconds: 1), curve: Curves.ease),
          child: Text(
            'DealCircles',
            overflow: TextOverflow.visible,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        leading: Image.asset("assets/logo.png"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          if (kIsWeb && ScreenSizeService.compareSize(context, ScreenSize.SMALL))
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                    child: ListTile(
                      leading: ImageIcon(
                        AssetImage('assets/app_store.png'),
                      ),
                      title: Text('App Store'),
                    )
                ),
                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: ImageIcon(
                      AssetImage('assets/google_play.png'),
                    ),
                    title: Text('Google Play'),
                  )
                ),
              ],
              icon: Icon(
                Icons.file_download,
                color: Colors.white,
                size: 26,
              ),
              onSelected: (value) {
                if (value == 1) {
                  openLink('https://apps.apple.com/us/app/apple-store/id1511193296');
                } else {
                  openLink('https://play.google.com/store/apps/details?id=com.dealcircles.dealcircles_flutter');
                }
              },
              offset: Offset.fromDirection(90, 50),
            ),
          if (kIsWeb && !ScreenSizeService.compareSize(context, ScreenSize.SMALL))
            RaisedButton(
              color: Theme.of(context).primaryColor,
              elevation: 0,
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('assets/app_store.png'),
                    color: Colors.white,
                  ),
                  SizedBox(width: 10,),
                  Text('App Store', style: TextStyle(color: Colors.white),),
                ],
              ),
              onPressed: () => openLink('https://apps.apple.com/us/app/apple-store/id1511193296'),
            ),
          if (kIsWeb && !ScreenSizeService.compareSize(context, ScreenSize.SMALL))
            RaisedButton(
              color: Theme.of(context).primaryColor,
              elevation: 0,
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('assets/google_play.png'),
                    color: Colors.white,
                  ),
                  SizedBox(width: 10,),
                  Text('Google Play', style: TextStyle(color: Colors.white),),
                ],
              ),
              onPressed: () => openLink('https://play.google.com/store/apps/details?id=com.dealcircles.dealcircles_flutter'),
            ),
          if (ScreenSizeService.compareSize(context, ScreenSize.SMALL))
            IconButton(
              icon: Icon(
                Icons.tune,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
            ),
        ],
      ),
      endDrawer: ScreenSizeService.compareSize(context, ScreenSize.SMALL)
          ? FilterDrawer(categories: categories, setFilters: setFilters,
          sort: sort, category: category, search: search) : null,
      body: _generateListview(context),
    );
  }

  Widget _generateListview(BuildContext context) {
    if (deals.length > 0) {
      return ScreenSizeService.compareSize(context, ScreenSize.SMALL)
          ? _appView(context) : _webView(context);
    } else if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      sort = 'newest';
      return ZeroDealView(setFilters);
    }
  }

  Widget _appView(BuildContext context) {
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
            return DealsCard(deals[index]);
          } else {
            return _loadMoreCard(context);
          }
        },
      ),
      onRefresh: loadDealsRefresh,
    );
  }

  Widget _loadMoreCard(BuildContext context) {
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

  Widget _webView(BuildContext context) {
    int crossCount = 1;
    if (ScreenSizeService.compareSize(context, ScreenSize.FULL)) {
      crossCount = 7;
    } else if (ScreenSizeService.compareSize(context, ScreenSize.HIGH)) {
      crossCount = 4;
    } else if (ScreenSizeService.compareSize(context, ScreenSize.MEDIUM)) {
      crossCount = 4;
    }

    double ratio = MediaQuery.of(context).size.width / crossCount / 380;

    List<Widget> widgets = List();
    widgets.addAll(deals.map((deal) => DealsCard(deal)).toList());
    if (ableToLoadMore) {
      widgets.add(_loadMoreCard(context));
    }
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
              left: ScreenSizeService.compareSize(context, ScreenSize.MEDIUM) ? 15 : 115,
              right: ScreenSizeService.compareSize(context, ScreenSize.MEDIUM) ? 15 : 115,
              top: 15,
              bottom: 0,
          ),
          sliver: SliverPersistentHeader(
            delegate: CustomSliverAppBar(
                expandedHeight: 200,
                setFilters: setFilters,
                sort: sort,
                category: category,
                search: search,
                categories: categories
            ),
            pinned: true,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(
            left: ScreenSizeService.compareSize(context, ScreenSize.MEDIUM) ? 0 : 100,
            right: ScreenSizeService.compareSize(context, ScreenSize.MEDIUM) ? 0 : 100,
            top: 0,
            bottom: 50,
          ),
          sliver: SliverGrid.count(
            crossAxisCount: crossCount,
            mainAxisSpacing: 2.0,
            childAspectRatio: ratio,
            children: widgets,
          ),
        ),
        SliverToBoxAdapter(
          child: WebFooter(),
        )
      ],
    );
  }

  void setFilters({String sort, String category, String search}) {
    deals.clear();
    this.sort = sort;
    this.category = category;
    this.search = search;
    loadDeals();
  }

  void _loadCategories() async {
    List temp = await ApiService.loadCategories();
    setState(() {
      categories = temp;
    });
  }

  void loadDeals() async {

    setState(() {
      loading = true;
    });

    List newDeals =
    await ApiService.loadDeals(null, sort, category, search, deals.length);

    setState(() {
      ableToLoadMore = newDeals.length == 30;
      deals.addAll(newDeals);
      loading = false;
    });
  }

  Future<void> loadDealsRefresh() async {
    deals.clear();
    loadDeals();
  }

  void openLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link, forceSafariVC: false);
    }
  }
}
