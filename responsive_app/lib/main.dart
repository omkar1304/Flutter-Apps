import 'package:flutter/material.dart';
import 'package:responsive_app/responsive/desktop_layout.dart';
import 'package:responsive_app/responsive/mobile_layout.dart';
import 'package:responsive_app/responsive/responsive_layout.dart';
import 'package:responsive_app/responsive/tablet_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ResponsiveLayout(
        mobileLayout: MobileLayout(),
        tabletLayout: TabletLayout(),
        desktopLayout: DesktopLayout(),
      ),
    );
  }
}
