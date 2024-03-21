import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_delivery/src/features/authentication/controllers/Address_controller.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String value;
  const MapScreen({super.key,required this.value});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();


  AddressController addressController=AddressController();
  late DocumentSnapshot? mostRecentDocument;
  late String? addressString;
  late double lat=0.0;
  late List<Marker> allMarker=[];
  late double long=0.0;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  Future<void> fetchMostRecentDocument() async {
    try {
      DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection('Parcels').doc(widget.value)
      //QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        //  .collection("Parcels").doc()//where('Receiver Name',isEqualTo: widget.value[1])
          //.orderBy("Date Created", descending: true)
         // .limit(1)
          .get();

      //if (querySnapshot.docs.isNotEmpty) {
       // mostRecentDocument = querySnapshot.docs.first;

        print(";;;;;;;;;;;;;;"+snapshot.toString());

        addressString=snapshot['To'];//mostRecentDocument?['To'];

        List<Location> locations = await locationFromAddress(addressString!);
        Location location = locations.first;
        setState(() {
          lat=location.latitude;
          long=location.longitude;

          final List<Marker>_markers= <Marker>[
            Marker(
              markerId: const MarkerId('1'),
              position: LatLng(lat, long),
              infoWindow: const InfoWindow(title: 'Your Destination Location'),
            )
          ];
          allMarker=_markers;
        });

        print("========="+locations[0].toString());


     // }
    } catch (e) {
      print("Error getting most recent document: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMostRecentDocument();
  }

  @override
  Widget build(BuildContext context) {
    //fetchMostRecentDocument();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:  const Text('Location'),
          backgroundColor:tThemeMain,
          foregroundColor: Colors.white,
        ),
        body: lat == 0.0 && long == 0.0
            ? const Center(child:Image(image: AssetImage('assets/images/E0guCpfGXM.gif')))
            : GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, long),
            zoom: 14.0,
          ),
          markers: Set<Marker>.of(allMarker),
        ),

    /*FutureBuilder(
          future: fetchMostRecentDocument(),
          builder: (BuildContext context,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Image(image: AssetImage("assets/images/E0guCpfGXM.gif")),); // or any other loading indicator
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return
             GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
            target: LatLng(lat, long),
            zoom: 14.0,
            ),
               markers: Set<Marker>.of(allMarker),
            );
            }

            }),*/
      ),
    );
  }
}
