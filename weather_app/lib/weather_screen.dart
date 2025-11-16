import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          children: [
            //? Main Card
            SizedBox(
              width: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "300 F",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.cloud, size: 64),
                        Text("Rain", style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            //? Weather Forecase
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weather Forecast",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Card(
                          elevation: 6,
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "09:00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Icon(Icons.cloud, size: 32),
                                SizedBox(height: 8),
                                Text("301.17"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
