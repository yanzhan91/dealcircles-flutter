import 'package:dealcircles_flutter/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deals_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DealsCircleApp(new DealsView()));
}

class DealsCircleApp extends StatelessWidget {
  final Widget home;

  DealsCircleApp(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DealCircles',
      theme: ThemeData(
        primarySwatch: ThemeColors.primary_color,
        fontFamily: GoogleFonts.openSans().fontFamily
      ),
      home: home,
      debugShowCheckedModeBanner: false
    );
  }
}
