import 'package:dealcircles_flutter/theme_colors.dart';
import 'package:flutter/material.dart';

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
      title: 'Planti App',
      theme: ThemeData(
        primarySwatch: ThemeColors.primary_color,
      ),
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
