import 'dart:async';
import 'dart:convert';
import 'package:bus_tracker_app/core/assets/app_img.dart';
import 'package:bus_tracker_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:bus_tracker_app/core/theme/app_colors.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:web_socket_channel/web_socket_channel.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isOnline = false;
  LatLng? currentlatLng;
  late WebSocketChannel _channel;
  late Location _location;
  late StreamSubscription<LocationData> _locationSubscription;
  late GoogleMapController _mapController;
  BitmapDescriptor? busIcon;

  // Connect to WebSocket server
  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.199.215:3000"),
    );
  }

  // Send location data to WebSocket server
  void _sendLocationUpdate() {
    if (currentlatLng != null) {
      final message = jsonEncode({
        'busId': context
            .read<AppUserCubit>()
            .driverUser!
            .busNo, // Replace with actual bus ID
        'lat': currentlatLng!.latitude,
        'lng': currentlatLng!.longitude,
      });
      _channel.sink.add(message); // Send message to WebSocket server
    }
  }

  void disconnectWebSocket() {
    _channel.sink.close(); // Close the WebSocket connection
    print("WebSocket connection closed");
  }

  // Get and listen for location updates
  void getLocation() async {
    _location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _location.onLocationChanged.listen(
      (LocationData event) {
        if (event.latitude != null && event.longitude != null) {
          setState(() {
            currentlatLng = LatLng(event.latitude!, event.longitude!);
            // If the map controller is initialized, move camera to the new location
            _mapController.animateCamera(
              CameraUpdate.newLatLng(currentlatLng!),
            );
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getIcon();
    _requestLocationPermission();
    getLocation();
    _connectToWebSocket(); // Connect to the WebSocket server
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
  void dispose() {
    _locationSubscription.cancel(); // Cancel location subscription
    _channel.sink.close(); // Close the WebSocket connection
    super.dispose();
  }

  getIcon() async {
    final icon = AssetMapBitmap(AppImg.busIcon);
    setState(() {
      busIcon = icon;
    });
  }

  // Google Maps widget to show bus location
  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentlatLng ?? LatLng(0, 0), // Default location if no data
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      markers: currentlatLng != null
          ? {
              Marker(
                icon: AssetMapBitmap(AppImg.busIcon, imagePixelRatio: 1.9),
                markerId: MarkerId(
                    "bus${context.read<AppUserCubit>().driverUser!.busNo}"), // Marker ID
                position: currentlatLng!, // Bus current location
                infoWindow: InfoWindow(
                    title:
                        "Bus ${context.read<AppUserCubit>().driverUser!.busNo}"),
              ),
            }
          : {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Tracker",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthUserLogout());
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          isOnline ? "If you go offline" : "Go online",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 30),
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
                              fontWeight: FontWeight.bold,
                              fontSize: width / 30),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isOnline ? "Online" : "Offline",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isOnline) {
                              setState(() {
                                isOnline = false;
                              });

                              _mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            } else {
                              setState(() {
                                isOnline = true;
                              });
                              _mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(currentlatLng!, 18),
                              );
                              // Send initial location when the driver goes online
                              _sendLocationUpdate();

                              // Periodically update location every 5 seconds
                              Timer.periodic(Duration(seconds: 5), (timer) {
                                if (isOnline) {
                                  _sendLocationUpdate();
                                } else {
                                  timer.cancel();
                                }
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
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: _buildGoogleMap()), // Show the Google Map here
            ),
          ],
        ),
      ),
    );
  }
}
