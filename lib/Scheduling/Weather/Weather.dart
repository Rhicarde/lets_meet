import 'package:lets_meet/Scheduling/Weather/data_service.dart';
import 'package:flutter/material.dart';

import 'models.dart';

// Creates WeatherPage class
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPage createState() => _WeatherPage();
}


class _WeatherPage extends State<WeatherPage> {
  // Creates the editable search bar
  final _cityTextController = TextEditingController();

  // Creates a reference to the DataService class to interact with the weather API
  final _dataService = DataService();

  // Creates a new nullable WeatherResponse object
  WeatherResponse? _response;

  // Builds a scrolling column which displays search bar
  // and related weather/temperature information
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_response != null)
                    Column(
                      children: [
                        Image.network(_response!.iconUrl),
                        Text(
                          '${_response!.tempInfo.temperature}°',
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(_response!.weatherInfo.description)
                      ],
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: SizedBox(
                      width: 150,
                      child: TextField(
                          controller: _cityTextController,
                          decoration: InputDecoration(labelText: 'City'),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  // Creates the search button
                  ElevatedButton(onPressed: _search, child: Text('Search'))
                ],
              ),
            )
          ),
        ));
  }

  // Creates the search function which requests information related to a specific city
  // and changes the page based on the information gathered
  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
  }
}