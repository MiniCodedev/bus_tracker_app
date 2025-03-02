import 'dart:convert';
import 'package:bus_tracker_app/core/assets/app_img.dart';
import 'package:bus_tracker_app/core/secret/app_secret.dart';
import 'package:bus_tracker_app/core/utils/show_snackbar.dart';
import 'package:bus_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bus_tracker_app/core/common/widgets/basic_field.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController busNocontroller = TextEditingController();
  late WebSocketChannel channel;
  GoogleMapController? mapController;
  bool isPermissionGranted = true;
  Map<String, LatLng> busPositions = {}; // Store buses' positions
  Set<Marker> busMarkers = {}; // Store markers for buses

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse(AppSecret.webSocketLink));
    // Listen for incoming WebSocket messages
    channel.stream.listen((message) {
      final Map data = jsonDecode(message);
      setState(() {
        busPositions.clear(); // Clear the old positions
        busMarkers.clear(); // Clear the old markers
        if (!data.containsKey("type")) {
          data.forEach((busId, location) {
            busPositions[busId] =
                LatLng(location['lat'] as double, location['lng'] as double);
            busMarkers.add(Marker(
              icon: AssetMapBitmap(AppImg.busIcon, imagePixelRatio: 1.9),
              markerId: MarkerId("$busId"),
              position:
                  LatLng(location['lat'] as double, location['lng'] as double),
              infoWindow: InfoWindow(title: "Bus $busId"),
            ));
          });
        }
      });
    });
  }

  // Function to search for a bus and move the camera to that bus's location
  void _searchBus() {
    String busId = busNocontroller.text.trim();
    if (busPositions.containsKey(busId)) {
      LatLng position = busPositions[busId]!;
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 18));
    } else {
      // Show error message if bus not found
      showSnackBar(context: context, text: 'Bus $busId not found!');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Bus"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthUserLogout());
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          // Text field for entering bus number
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: BasicField(
              isNum: true,
              suffixIcon: IconButton(
                onPressed: _searchBus,
                icon: Icon(Icons.search),
              ),
              controller: busNocontroller,
              icon: Icons.directions_bus_rounded,
              hintText: "Enter Bus Number",
            ),
          ),
          Text("busPositions: $busPositions"),
          // Google Map displaying buses' positions
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    12.9716, 77.5946), // Default position (e.g., Bangalore)
                zoom: 14,
              ),
              markers: busMarkers,
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
