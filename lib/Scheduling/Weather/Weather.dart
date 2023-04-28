import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lets_meet/Scheduling/Weather/data_service.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/Scheduling/Weather/get_location.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

// Creates WeatherPage class
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPage createState() => _WeatherPage();
}


class _WeatherPage extends State<WeatherPage> {

  // Variables for getting user position
  String? _currentAddress;
  Position? _currentPosition;

  // API information / variables for getting weather from user location
  var domain = 'https://api.openweathermap.org/data/2.5/weather?';
  var weatherAPIKey = '3199aa90be7e6cdf53f25ea0565568e5';
  bool isLoaded = false;
  num temp = 0;
  //num press;
  //num hum;
  //num cover;
  String cityName = '';

  // Asks user for permission to get location from phone
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

  // If permitted, gets the position of the user in terms of latitude, longitude
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
    getCurrentCityWeather(_currentPosition!);
  }

  // Using latitude, longitude, retrieves address data on where the user is specifically
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

  // Makes an API request to the OpenWeather API, and retreives weather data
  // at the user's location
  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri = '${domain}lat=${_currentPosition?.latitude}&lon=${_currentPosition?.longitude}&appid=${weatherAPIKey}&units=imperial';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if(response.statusCode==200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    }
    else {
      print(response.statusCode);
    }
  }

  // Updates the UI variables based on the API request
  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        cityName = 'Not available';
      } else {
        temp = decodedData['main']['temp'];
        // press = decodedData['main']['pressure'];
        // hum = decodedData['main']['humidity'];
        // cover = decodedData['clouds']['all'];
        cityName = decodedData['name'];
      }
    });
  }

  // Retrieves user position on page load
  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }


  // Creates the editable search bar
  //final _cityTextController = TextEditingController();

  // Creates a reference to the DataService class to interact with the weather API
  //final _dataService = DataService();

  //final _location = Location();

  // Creates a new nullable WeatherResponse object
  //WeatherResponse? _response;

  // Builds a scrolling column which displays search bar
  // and related weather/temperature information
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(
              child: SingleChildScrollView(
                // Displays the user's city and the temperature data of that city
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cityName),
                    Text(temp.toInt().toString() + '°F'),
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