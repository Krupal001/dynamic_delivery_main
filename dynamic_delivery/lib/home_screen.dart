
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_delivery/parcel_datail_screen.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'src/features/authentication/screens/notification/notification_services.dart';
import 'src/repository/authentication_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  late String? merchantID;

  Future<void> getData() async {
    QuerySnapshot merchantQuery = await FirebaseFirestore.instance.collection("Delivery-agents")
        .where("Email", isEqualTo: user?.email!).get();

    if (merchantQuery.docs.isNotEmpty) {
      merchantID = merchantQuery.docs.first.id;
    }
  }

  NotificationServices notificationServices = NotificationServices();

  /*Future<List<String>> getDeviceTokensFromFirestore() async {
    List<String> tokens = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('deviceTokens').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Assuming 'token' is the field in your Firestore document that stores the device token
      String token = doc.get('token');

      if (token != null && token.isNotEmpty) {
        tokens.add(token);
      }
    }

    return tokens;
  }*/


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
       // print('device token');
       // print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcel Details'),
        backgroundColor: tThemeMain,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: tThemeMain,),
            );
          } else if (merchantID == null) {
            return const Center(
              child: Text('No merchant ID found'),
            );
          } else {
            return StreamBuilder<QuerySnapshot>(
              stream: db.collection('Parcels').where('Agent-Id', isEqualTo: merchantID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: tThemeMain,),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ParcelDetailScreen(parcel: doc)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc.id),
                                    Text(
                                      "status: " + doc['Status'],
                                      style: TextStyle(
                                        color: doc['Status'] == 'Delivered' ? Colors.green :
                                        doc['Status'] == 'Shipment Picked Up' ? Colors.yellow :
                                        Colors.red, // Change color based on status
                                      ),
                                    ),
                                    Text("Date:" + doc['Date Created']),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final result = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Are you sure?'),
                                        content: const Text('This action will permanently delete this data'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result == null || !result) {
                                      return;
                                    }

                                    // Delete the document from Firestore
                                    await FirebaseFirestore.instance.collection('Parcels').doc(doc.id).delete();
                                    // Optionally, you can also remove the card from the UI without reloading the data
                                    // This requires managing the state of the list of documents
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );

                }
              },
            );
          }
        },
      ),
    );
  }
}