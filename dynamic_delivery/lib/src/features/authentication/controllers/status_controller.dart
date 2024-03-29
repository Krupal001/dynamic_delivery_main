import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StatusController extends GetxController{
  static StatusController get instance=>Get.find();
  User? user = FirebaseAuth.instance.currentUser;
  void updateStatus(String? id,String message) async {
    try {
      //QuerySnapshot agentsQuery = await FirebaseFirestore.instance.collection("Parcels")
      //    .where("Email", isEqualTo: user?.email!).get();

      //final String agentID = agentsQuery.docs.first.id;
      await FirebaseFirestore.instance.collection('Parcels').doc(id).update({"Status":message});
      print('Field added successfully');
    } catch (e) {
      print('Error adding field: $e');
    }
  }
}