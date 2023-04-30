import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lets_meet/Scheduling/Weather/data_service.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Scheduling/Weather/get_location.dart';

import 'models.dart';

// Creates WeatherPage class
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPage createState() => _WeatherPage();
}


class _WeatherPage extends State<WeatherPage> {
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  // Creates the editable search bar
  //final _cityTextController = TextEditingController();

  // Creates a reference to the DataService class to interact with the weather API
  final _dataService = DataService();

  //final _location = Location();

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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(_response!.iconUrl),
                            Text(
                              '${_response!.tempInfo.temperature}°',
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(_response!.weatherInfo.description)
                          ]
                      ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            child: SizedBox(
                              // width: 150,
                              // child: TextField(
                              //     controller: _cityTextController,
                              //     decoration: InputDecoration(labelText: 'City'),
                              //     textAlign: TextAlign.center),
                            ),
                          ),
                          // Creates the search button
                          // Text("Longitude ${_currentPosition?.longitude} Latitude ${_currentPosition?.latitude}"),
                          //ElevatedButton(onPressed: _search, child: Text('Search'))
                          ElevatedButton(
                            onPressed: _getCurrentPosition,
                            child: const Text("Get Current Location"),
                          )
                        ]
                    ),
                  ],
                ),
              )
          ),
        ));
  }

  // Creates the search function which requests information related to a specific city
  // and changes the page based on the information gathered
  // void _search() async {
  //   final posResponse = await _location.getCurrentLocation();
  //   final response = await _dataService.getWeather(posResponse.latitude, posResponse.longitude);
  //   setState(() => _response = response);
  // }
}