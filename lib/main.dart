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
    return new Scaffold(
      body: DealsView(id: settings.name.split('/').last),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
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
