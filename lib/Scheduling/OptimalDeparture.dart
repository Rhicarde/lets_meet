import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class OptimalDeparture extends StatefulWidget {
  final QueryDocumentSnapshot event;
  const OptimalDeparture({Key? key, required this.event}) : super(key: key);


  @override
  State<OptimalDeparture> createState() => _OptimalDeparture();
}

class _OptimalDeparture extends State<OptimalDeparture> {
  String? _currentAddress;
  Position? _currentPosition;

  // Request Location Service Permission from User
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

  // Get Current User Position
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

  // Convert Lat and Lang to Readable Address
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

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    // current time
    DateTime _currentTime = DateTime.now();

    // getting time of event
    String _eventTime = widget.event.get('time') ?? 'N/A';
    Timestamp _eventDate = widget.event.get('date') ?? 'N/A';
    DateTime _eventDateTime = (_eventDate != 'N/A' && _eventTime != 'N/A')
    // converting eventtime and eventdate to one datetime for calculation
        ? DateTime(_eventDate.toDate().year, _eventDate.toDate().month, _eventDate.toDate().day, int.parse(_eventTime.split(':')[0]), int.parse(_eventTime.split(':')[1])) : DateTime.now(); // or any default value you want

    // get location of event
    String _dbEventLocation = widget.event.get('location');

    // get placeid of events
    String _dbplaceID = widget.event.get("placeid");

    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Current Time: $_currentTime' "\n", style: TextStyle(fontSize: 18)),
              Text('Event Date and Time: $_eventDateTime' "\n", style: TextStyle(fontSize: 18)),
              Text('Event Location as String: $_dbEventLocation' "\n", style: TextStyle(fontSize: 18)),
              Text('Event Location as PlaceID: $_dbplaceID' '\n', style: TextStyle(fontSize: 18)),
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Text("Get Current Location"),
              )
            ],
          ),
        ),
      ),
    );
  }
}