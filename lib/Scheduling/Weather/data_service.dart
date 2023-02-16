import 'dart:convert';

import 'package:lets_meet/Scheduling/Weather/models.dart';
import 'package:http/http.dart' as http;

// Interacts with the OpenWeather API to gather weather data
class DataService {
  Future<WeatherResponse> getWeather(String city) async {

    // Lists parameters for types of data retrieved, as well as our API key
    final queryParameters = {
      'q': city,
      'appid': '3199aa90be7e6cdf53f25ea0565568e5',
      'units': 'imperial'
    };

    final uri = Uri.https(
      'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    // Stores response saved from the API
    final response = await http.get(uri);

    // Converts the API response into a JSON file
    final json = jsonDecode(response.body);

    return WeatherResponse.fromJson(json);
  }
}