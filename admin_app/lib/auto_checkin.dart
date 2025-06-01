import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonEncode

class LocationListenerWidget extends StatefulWidget {
  @override
  _LocationListenerWidgetState createState() => _LocationListenerWidgetState();
}

class _LocationListenerWidgetState extends State<LocationListenerWidget> {
  StreamSubscription<Position>? _positionStream;
  bool isCheckedIn = false;
  double curLat = -1.0;

  double curLon = -1.0;
  String? uuid;
  final String BASE_URL = "https://sih-geo-attendance.onrender.com";
  // Define GeoFence center (latitude, longitude) and radius (meters)
  final double geoFenceLat = 30.3456;
  final double geoFenceLng = 78.0322;
  final double geoFenceRadius = 100.0; // in meters

  @override
  void initState() {
    super.initState();
    _startListeningToLocation();
    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uuid = prefs.getString('uuid'); // This can still be null
    });
  }

  void _startListeningToLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check permissions
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        print('Location permission not granted.');
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _handleLocationChange(position);
    });
  }

  void _handleLocationChange(Position position) {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      geoFenceLat,
      geoFenceLng,
    );

    print('Current Distance: $distance meters');

    if (distance <= geoFenceRadius && !isCheckedIn) {
      _checkInUser(position);
    } else if (distance > geoFenceRadius && isCheckedIn) {
      _checkOutUser();
    }
  }

  Future<void> _checkInUser(Position position) async {
    setState(() {
      curLon = position.longitude;

      curLat = position.latitude;
      isCheckedIn = true;
    });
    print('✅ Checked In');
    // TODO: Update server or local DB
    try {
      String timestamp = DateTime.now().toIso8601String();

      // Prepare payload
      Map<String, dynamic> payload = {
        "entered": isCheckedIn,
        "currentTime": timestamp,
        "latitude": position.latitude,
        "longitude": position.longitude,
      };

      // Send POST request
      final response = await http.post(
        Uri.parse("$BASE_URL/users/$uuid/timestamp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("✅ Check-in recorded successfully.");
      } else {
        print(
            "❌ Failed to record check-in. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("❌ Error during check-in: $e");
    }
  }

  void _checkOutUser() {
    setState(() {
      isCheckedIn = false;
    });
    print('🚪 Checked Out');
    // TODO: Update server or local DB
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(isCheckedIn
            ? "🟢 Inside GeoFence $curLon $curLat"
            : "🔴 Outside GeoFence  $curLon $curLat"),
      ),
    );
  }
}
