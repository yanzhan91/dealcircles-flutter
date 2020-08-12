import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deals_view/deals_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DealsCircleApp());
}

class DealsCircleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DealCircles',
      theme: ThemeData(
        primaryColor: Color(0xFF632ade),
        fontFamily: GoogleFonts.openSans().fontFamily
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => DealsView(id: settings.name.split('/').last)
        );
      },
      debugShowCheckedModeBanner: false
    );
  }
}
