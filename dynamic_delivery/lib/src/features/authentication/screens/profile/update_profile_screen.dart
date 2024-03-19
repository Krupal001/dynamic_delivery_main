import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/strings.dart';
import '../../../../repository/authentication_repository.dart';
import '../../../../utils/helper/helper_controller.dart';
import '../../../../utils/theme/colors/colors.dart';
import '../../controllers/profile_controller.dart';
import '../../models/users_models.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title:const Text(tEditProfile,),
        backgroundColor: tThemeMain,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            builder: (context,snapshot){
              if(snapshot.connectionState== ConnectionState.done){
                if(snapshot.hasData){
                  UserModel userdata=snapshot.data as UserModel;
                  return  Column(
                    children: [
                      // -- IMAGE with ICON
                      const SizedBox(height: 50),

                      // -- Form Fields
                      Form(
                        child: Column(
                          children: [
                            TextFormField(

                              initialValue: userdata.name,
                              decoration: const InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),)),
                                  label: Text("Name"), prefixIcon: Icon(LineAwesomeIcons.user)),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: userdata.email,
                              decoration: const InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),)),

                                  label: Text(tEmail), prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: userdata.phone,
                              decoration: const InputDecoration(
                                  border:  OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15),)),

                                  label: Text("Phone no"), prefixIcon: Icon(LineAwesomeIcons.phone)),
                            ),
                            const SizedBox(height:  20),
                            TextFormField(
                              initialValue: userdata.password,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15),)),

                                label: const Text("Password"),
                                prefixIcon: const Icon(Icons.lock_outline_sharp),
                                suffixIcon:
                                IconButton(icon: const Icon(LineAwesomeIcons.eye_slash), onPressed: () {}),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // -- Form Submit Button
                            const SizedBox(
                              width: double.infinity,

                            ),
                            const SizedBox(height: 30),

                            // -- Created Date and Delete Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async{
                                    user?.delete();
                                    try {
                                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                          .collection('Delivery-agents')
                                          .where('Email', isEqualTo: user!.email)
                                          .get();

                                      for (var doc in querySnapshot.docs) {
                                        await FirebaseFirestore.instance.collection('Delivery-agents').doc(doc.id).delete();
                                        print("Document deleted from Firestore.");
                                      }
                                    } catch (e) {
                                      Helper.errorSnackBar(title:'Error',message:e.toString());
                                    }
                                    AuthenticationRepository.instance.logout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                                      elevation: 0,
                                      foregroundColor: Colors.red,
                                      shape: const StadiumBorder(),
                                      side: BorderSide.none),
                                  child: const Text("Delete"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }else if(snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()),);
                }
                else{
                  return const Center(child: Text("Something went Wrong"),);
                }
              }else{
                return const Center(child: CircularProgressIndicator(color: tThemeMain,),);
              }
            }, future: controller.getUserData(),
          ),
        ),
      ),
    );
  }
}

