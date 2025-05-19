import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationListenerWidget extends StatefulWidget {
  @override
  _LocationListenerWidgetState createState() => _LocationListenerWidgetState();
}

class _LocationListenerWidgetState extends State<LocationListenerWidget> {
  StreamSubscription<Position>? _positionStream;
  bool isCheckedIn = false;

  // Define GeoFence center (latitude, longitude) and radius (meters)
  final double geoFenceLat = 30.3456;
  final double geoFenceLng = 78.0322;
  final double geoFenceRadius = 100.0; // in meters

  @override
  void initState() {
    super.initState();
    _startListeningToLocation();
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
      _checkInUser();
    } else if (distance > geoFenceRadius && isCheckedIn) {
      _checkOutUser();
    }
  }

  void _checkInUser() {
    setState(() {
      isCheckedIn = true;
    });
    print('✅ Checked In');
    // TODO: Update server or local DB
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
        child: Text(isCheckedIn ? "🟢 Inside GeoFence" : "🔴 Outside GeoFence"),
      ),
    );
  }
}
