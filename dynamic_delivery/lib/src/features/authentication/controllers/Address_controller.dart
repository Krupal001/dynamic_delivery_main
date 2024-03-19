import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  late DocumentSnapshot? mostRecentDocument;
  late String? parcelId;
  FirebaseFirestore db=FirebaseFirestore.instance;
  User? user=FirebaseAuth.instance.currentUser;

  Future<void> fetchMostRecentDocument() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Parcels")
          .orderBy("Date Created", descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        mostRecentDocument = querySnapshot.docs[0];

        parcelId= mostRecentDocument?.id;
      }
    } catch (e) {
      print("Error getting most recent document: $e");
    }
  }


  Future<String?>getAddress()async {
    String? address=mostRecentDocument?['To'];
    return address;
  }
}
