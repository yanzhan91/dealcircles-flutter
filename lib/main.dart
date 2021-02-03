import 'dart:io';

import 'package:dealcircles_flutter/deals_detail/deal_details.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_view.dart';
import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'deals_view/deals_view.dart';
import 'models/Deal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DealCirclesApp());
}

class DealCirclesApp extends StatefulWidget {
  @override
  _DealCirclesAppState createState() => _DealCirclesAppState();
}

class _DealCirclesAppState extends State<DealCirclesApp> {
  int _currentIndex = 0;
  DealsView _dealsView;
  PriceAlertView _priceAlertView;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    if (!kIsWeb) {
      _setupFirebaseMessage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DealCircles',
        theme: ThemeData(
            primaryColor: Color(0xFF632ade),
            fontFamily: GoogleFonts.openSans().fontFamily),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => buildScreen(settings),
          );
        },
        debugShowCheckedModeBanner: false);
  }

  Widget buildScreen(settings) {
    if ((Platform.isAndroid || Platform.isIOS)) {
      if (_currentIndex == 0 && _dealsView == null) {
        _dealsView = DealsView(id: settings.name.split('/').last);
      } else if (_currentIndex == 1 && _priceAlertView == null) {
        _priceAlertView = PriceAlertView();
      }

      return Scaffold(
        body: _currentIndex == 0 ? _dealsView : _priceAlertView,
        bottomNavigationBar: buildBottomNavigationBar(),
      );
    } else {
      return DealsView(id: settings.name.split('/').last);
    }
  }

  Container buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: (int index) => setState(() {
          _currentIndex = index;
        }), // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Daily Deals',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Price Alerts',
          ),
        ],
      ),
    );
  }

  void _setupFirebaseMessage() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      SharedPreferences.getInstance().then((prefs) => prefs.setString("fcm_token", token));
    });
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
}
