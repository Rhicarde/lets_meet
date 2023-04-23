import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class OptimalDeparture extends StatefulWidget {
  // change file to DocumentReference
  final DocumentReference event;
  const OptimalDeparture({Key? key, required this.event}) : super(key: key);


  @override
  State<OptimalDeparture> createState() => _OptimalDeparture();
}

class _OptimalDeparture extends State<OptimalDeparture> {
  String? _currentAddress;
  Position? _currentPosition;
  int? duration;
  DateTime? oDT;
  String? formattedoDT;
  String _eventTime = '00:00 AM';
  DateTime _eventDate = DateTime.now();
  String _eventLocation = 'No location';
  //current time
  DateTime _currentTime = DateTime.now();


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

  // travel disatnce and time between user and event location
  Future<void> getDistance(String originAddress, String destinationAddress) async {
    final apiKey = 'AIzaSyDtcUVpzGuSUjmH9q-sA2LJSrbwTYVeeNs';
    final apiUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$originAddress&destinations=$destinationAddress&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      duration = data['rows'][0]['elements'][0]['duration']['value'];
    } else {
      throw Exception('Failed to load distance data');
    }
  }

   Future<void> calculateODT(String _eventAddress, DateTime _eventTime) async {
    // Wait for the current position to be obtained
    await _getCurrentPosition();

    // Get the distance and time between the user's current position and the event location
    await getDistance(_currentAddress!, _eventAddress);
    oDT = _eventTime.subtract(Duration(seconds: duration!));
    formattedoDT = DateFormat("HH:mm 'on' EEEE, MMMM d y").format(oDT!);
  }

  // convert AM/PM to 24 Hour
  String convertTo24HourFormat(String time) {
    final format = DateFormat('hh:mm a');
    final dateTime = format.parse(time);
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    widget.event.get().then((value) {
      _eventTime = value.get('time');
      _eventDate = value.get('date').toDate();
      _eventLocation = value.get('location');
    });
    // getting time of event
    // if _eventTime is not in the correct format HH:MM then convert
    String _convertedTime = convertTo24HourFormat(_eventTime);

    DateTime _eventDateTime = (_eventDate != 'N/A' && _eventTime != 'N/A')
    // converting eventtime and eventdate to one datetime for calculation
        ? DateTime(_eventDate.year, _eventDate.month, _eventDate.day, int.parse(_convertedTime.split(':')[0]), int.parse(_convertedTime.split(':')[1])) : DateTime.now(); // or any default value you want

    // calculate how long it takes to get from current address to event address
    // subtract that time from the event time to get ODT
    calculateODT(_eventLocation, _eventDateTime);

    return Scaffold(
      appBar: AppBar(title: const Text("Optimal Departure Time")),
      body: Center(
          child: Text(
              'To Arrive on Time Depart at: \n ${formattedoDT ?? ""}', style: TextStyle(fontSize: 25)),
      ),
    );
  }
}