import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/weather_subheading.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      String appId = "f172851d598fb92b2755ba28e81dfa71";
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$appId",
        ),
      );
      final data = jsonDecode(res.body);

      if (data["cod"] != "200") {
        throw "An unexpected error occured";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

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
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, asyncSnapshot) {
          // Loading State
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          // Error State
          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error.toString()));
          }

          // Data Flow
          final data = asyncSnapshot.data;
          final currentTemp = data?["list"][0]["main"]["temp"];

          return Padding(
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
                              "$currentTemp K",
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
                      WeatherSubheading(title: "Weather Forecast"),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            HourlyForecastItem(
                              time: "09:00",
                              icon: Icons.cloud,
                              temperature: "301.17",
                            ),
                            HourlyForecastItem(
                              time: "09:00",
                              icon: Icons.cloud,
                              temperature: "301.17",
                            ),
                            HourlyForecastItem(
                              time: "09:00",
                              icon: Icons.cloud,
                              temperature: "301.17",
                            ),
                            HourlyForecastItem(
                              time: "09:00",
                              icon: Icons.cloud,
                              temperature: "301.17",
                            ),
                            HourlyForecastItem(
                              time: "09:00",
                              icon: Icons.cloud,
                              temperature: "301.17",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                //? Additional Info
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherSubheading(title: "Additional Information"),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: "Humidity",
                            value: "94",
                          ),
                          AdditionalInfoItem(
                            icon: Icons.air,
                            label: "Wind Speed",
                            value: "7.67",
                          ),
                          AdditionalInfoItem(
                            icon: Icons.beach_access,
                            label: "Pressure",
                            value: "1006",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
