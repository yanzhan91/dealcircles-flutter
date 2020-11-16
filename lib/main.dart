import 'dart:io';

import 'package:dealcircles_flutter/price_alerts_view/price_alert_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deals_view/deals_view.dart';

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
  DealsView _dealsView = null;
  PriceAlertView _priceAlertView = null;

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

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }
}
