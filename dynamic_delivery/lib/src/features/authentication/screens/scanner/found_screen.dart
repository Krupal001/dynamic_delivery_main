import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/maps/map_screen.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/notification/message_screen.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/scanner/otp_screen.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/status_controller.dart';


class FoundScreen extends StatefulWidget {
  final List<String> value;
  const FoundScreen({super.key, required this.value});

  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  bool isPickupClicked = false;
  late DocumentSnapshot? mostRecentDocument;
  late String? parcelId;
  @override
  void initState() {
    super.initState();
    fetchMostRecentDocument();
  }

  Future<void> fetchMostRecentDocument() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Parcels").where("Receiver Name" , isEqualTo:widget.value[1])
         // .orderBy("Date Created", descending: true)
         // .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        mostRecentDocument = querySnapshot.docs[0];

         parcelId= mostRecentDocument?.id;
      }
      print("--------------------------------"+parcelId!);
    } catch (e) {
      print("Error getting most recent document: $e");
    }
  }

        @override
    build(BuildContext context) {
    Get.put(StatusController());
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return RotatedBox(quarterTurns: 0,child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context, true),
            ),);
          },
        ),
        title: const Text("Courier Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white)),
        backgroundColor: tThemeMain,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text("Parcel Data: ", style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)),
              const SizedBox(height: 20),
          FutureBuilder(
          future: fetchMostRecentDocument(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: tThemeMain,)); // or any other loading indicator
          } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
          } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: Offset(0, 3), // Shadow offset
                ),
              ],
            ),
            child: Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("Order id: ${parcelId.toString()}", style: const TextStyle(fontSize: 16)),
              Text("Recipient Name: ${widget.value[1]}", style: const TextStyle(fontSize: 16)),
              Text("Shipping Address: ${widget.value[2]}", style: const TextStyle(fontSize: 16)),
              Text("Description: ${widget.value[3]}", style: const TextStyle(fontSize: 16)),
               ],

              ),
            ),
          );}}
          ),
              const SizedBox(height: 55,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   ElevatedButton(
                    onPressed: () {
                      StatusController.instance.updateStatus(parcelId,"In Transits");
                      setState(() {
                        isPickupClicked = true; // Update the state to enable "Delivered" button
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MapScreen(value:parcelId.toString(),)));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                      backgroundColor: tThemeMain,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: tThemeMain),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                    ),
                    child: const Text(
                      'PICKUP',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: isPickupClicked ? () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(value: parcelId.toString(),)));
                        // Your existing code to handle the "Delivered" button press
                      } : null,

                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: tThemeMain),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                    ),
                    child: const Text(
                      'DELIVERED',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ], )], ),
        ),
      ),
    );
  }
}
