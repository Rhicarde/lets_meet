import 'package:geolocator/geolocator.dart';
class Location {
  late double latitude;
  late double longitide;
  String apiKey = '1972ec47e75df023b0cc7eab1518ba93';
  late int status;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitide = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}