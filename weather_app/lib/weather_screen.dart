import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      String cityName = "Mumbai";
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
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
          final currentWeatherData = data?["list"][0];
          final currentTemp = currentWeatherData["main"]["temp"];
          final currentSky = currentWeatherData["weather"][0]["main"];
          final currentPressure = currentWeatherData["main"]["pressure"];
          final currentWindSpeed = currentWeatherData["wind"]["speed"];
          final currentHumidity = currentWeatherData["main"]["humidity"];

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
                            Icon(
                              currentSky == "Clouds" || currentSky == "Rain"
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            Text(currentSky, style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //? Weather Forecast
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherSubheading(title: "Weather Forecast"),
                      SizedBox(height: 16),
                      // Creates a all items at once -> not good for performance

                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       HourlyForecastItem(
                      //         time: "09:00",
                      //         icon: Icons.cloud,
                      //         temperature: "301.17",
                      //       ),
                      //       HourlyForecastItem(
                      //         time: "09:00",
                      //         icon: Icons.cloud,
                      //         temperature: "301.17",
                      //       ),
                      //       HourlyForecastItem(
                      //         time: "09:00",
                      //         icon: Icons.cloud,
                      //         temperature: "301.17",
                      //       ),
                      //       HourlyForecastItem(
                      //         time: "09:00",
                      //         icon: Icons.cloud,
                      //         temperature: "301.17",
                      //       ),
                      //       HourlyForecastItem(
                      //         time: "09:00",
                      //         icon: Icons.cloud,
                      //         temperature: "301.17",
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Creates items on demand - better for performance
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final hourlyForecast = data?["list"][index + 1];
                            final hourlySky =
                                hourlyForecast["weather"][0]["main"];
                            final hourlyTemp = hourlyForecast["main"]["temp"]
                                .toString();
                            final hourlyTime = DateTime.parse(
                              hourlyForecast["dt_txt"],
                            );
                            return HourlyForecastItem(
                              time: DateFormat.j().format(hourlyTime),
                              icon: hourlySky == "Clouds" || hourlySky == "Rain"
                                  ? Icons.cloud
                                  : Icons.sunny,
                              temperature: hourlyTemp,
                            );
                          },
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
                            value: currentHumidity.toString(),
                          ),
                          AdditionalInfoItem(
                            icon: Icons.air,
                            label: "Wind Speed",
                            value: currentWindSpeed.toString(),
                          ),
                          AdditionalInfoItem(
                            icon: Icons.beach_access,
                            label: "Pressure",
                            value: currentPressure.toString(),
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
