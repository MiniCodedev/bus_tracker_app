import 'dart:async';
import 'dart:convert';
import 'package:bus_tracker_app/core/assets/app_img.dart';
import 'package:bus_tracker_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:bus_tracker_app/core/secret/app_secret.dart';
import 'package:bus_tracker_app/core/theme/app_colors.dart';
import 'package:bus_tracker_app/core/utils/loader.dart';
import 'package:bus_tracker_app/core/utils/show_snackbar.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as locationService;
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:web_socket_channel/web_socket_channel.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isOnline = false;
  LatLng? currentLatLng;
  late WebSocketChannel _channel;
  StreamSubscription<Position>? _positionStream;
  GoogleMapController? _mapController;
  bool isPermissionGranted = true;
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _channel.sink.close();
    super.dispose();
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    permission.PermissionStatus status =
        await permission.Permission.location.request();
    if (status.isDenied) {
      showSnackBar(context: context, text: "Location permission denied!");
      return;
    }
    getLocationUpdates();
  }

  // Connect to WebSocket
  void _connectToWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(AppSecret.webSocketLink));
      _channel.stream.listen((data) {
        print("WebSocket Response: $data");
      }, onError: (error) {
        print("WebSocket Error: $error");
      });
    } catch (e) {
      print("WebSocket Connection Failed: $e");
    }
  }

  // Send location updates to WebSocket
  void _sendLocationUpdate(LatLng location) {
    final message = jsonEncode({
      'busId': context.read<AppUserCubit>().driverUser!.busNo,
      'lat': location.latitude,
      'lng': location.longitude,
    });
    _channel.sink.add(message);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: AppSecret.googleApiKey,
        request: PolylineRequest(
            destination: PointLatLng(12.866431981114607, 80.22047084231708),
            origin:
                PointLatLng(currentLatLng!.latitude, currentLatLng!.longitude),
            mode: TravelMode.driving));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }

    setState(() {});
  }

  // Get real-time location updates
  void getLocationUpdates() async {
    final location = locationService.Location();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          isPermissionGranted = false;
        });
        showSnackBar(context: context, text: "Enable location services!");
        return;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isPermissionGranted = false;
        });
        showSnackBar(context: context, text: "Location permission required!");
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    ).listen((Position position) {
      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
      });

      if (isOnline) {
        print("Location Update: ${position.latitude}, ${position.longitude}");
        _sendLocationUpdate(currentLatLng!);
        // getPolyPoints();
      }

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLatLng!),
      );
    });
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentLatLng ?? LatLng(12.866431981114607, 80.22047084231708),
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      zoomControlsEnabled: false,
      markers: currentLatLng != null
          ? {
              Marker(
                markerId: MarkerId(
                    "bus${context.read<AppUserCubit>().driverUser!.busNo}"),
                position: currentLatLng!,
                icon: AssetMapBitmap(AppImg.busIcon, imagePixelRatio: 1.9),
                infoWindow: InfoWindow(
                    title:
                        "Bus ${context.read<AppUserCubit>().driverUser!.busNo}"),
              ),
              Marker(
                markerId: MarkerId("Jpr Engineering College"),
                position: LatLng(12.866431981114607, 80.22047084231708),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange),
                infoWindow: InfoWindow(title: "Jpr Engineering College"),
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
        title: Text(
          "Bus Tracker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthUserLogout());
            },
            icon: Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isPermissionGranted
            ? currentLatLng == null
                ? Loader()
                : Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isOnline
                                        ? "If you go offline"
                                        : "Go online",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width / 30),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    isOnline
                                        ? Icons.toggle_off_rounded
                                        : Icons.toggle_on_rounded,
                                    color: isOnline
                                        ? null
                                        : AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    isOnline
                                        ? "you don't share the location."
                                        : "to share location.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width / 30),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isOnline ? "Online" : "Offline",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isOnline) {
                                        _mapController?.animateCamera(
                                            CameraUpdate.newLatLngZoom(
                                                currentLatLng!, 18));
                                      }
                                      setState(() {
                                        isOnline = !isOnline;
                                      });
                                      if (isOnline) {
                                        _mapController?.animateCamera(
                                            CameraUpdate.newLatLngZoom(
                                                currentLatLng!, 18));
                                      }
                                    },
                                    child: Icon(
                                      isOnline
                                          ? Icons.toggle_on_rounded
                                          : Icons.toggle_off_rounded,
                                      size: 50,
                                      color: isOnline
                                          ? AppColors.primaryColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: _buildGoogleMap()),
                    ],
                  )
            : Center(child: Text("Location permission required!")),
      ),
    );
  }
}
