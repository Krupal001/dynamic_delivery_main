import 'dart:async';

import 'package:dynamic_delivery/src/features/authentication/controllers/Address_controller.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(23.0225, 72.5714);

  AddressController addressController=AddressController();
  late Future<String?> address;
  late String? addressString;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController.fetchMostRecentDocument();
    addressController.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:  const Text('Location'),
          backgroundColor:tThemeMain,
          foregroundColor: Colors.white,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: _center,
            zoom: 14.0,
          ),
        ),
      ),
    );
  }
}
