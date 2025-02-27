import 'dart:async';
import 'package:bus_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isOnline = false;

  LatLng? currentlatLng;

  void getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen(
      (LocationData event) {
        if (event.latitude != null && event.longitude != null) {
          currentlatLng = LatLng(event.latitude!, event.longitude!);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    getLocation();
  }

  Future<void> _requestLocationPermission() async {
    permission.PermissionStatus status =
        await permission.Permission.location.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    isOnline ? "If you go offline" : "Go online",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width / 30),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    !isOnline
                        ? Icons.toggle_on_rounded
                        : Icons.toggle_off_rounded,
                    color: !isOnline ? AppColors.primaryColor : null,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    isOnline
                        ? "you don't share the location."
                        : "to share location.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width / 30),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isOnline ? "Online" : "offline",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isOnline) {
                        setState(() {
                          isOnline = false;
                        });
                      } else {
                        setState(() {
                          isOnline = true;
                        });
                      }
                    },
                    child: Icon(
                      isOnline
                          ? Icons.toggle_on_rounded
                          : Icons.toggle_off_rounded,
                      size: 50,
                      color: isOnline ? AppColors.primaryColor : null,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
