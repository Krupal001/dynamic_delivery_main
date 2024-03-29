import 'package:dynamic_delivery/src/features/authentication/controllers/forget_password_controller.dart';
import 'package:dynamic_delivery/src/utils/Validations/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../constants/strings.dart';
import '../../../../utils/theme/colors/colors.dart';

class ForgotPassMailScreen extends StatefulWidget {
  const ForgotPassMailScreen({super.key});

  @override
  State<ForgotPassMailScreen> createState() => _ForgotPassMailScreenState();
}

class _ForgotPassMailScreenState extends State<ForgotPassMailScreen> {
  @override
  Widget build(BuildContext context) {
    final controller=Get.put(ForgetPasswordController());
    final formKey=GlobalKey<FormState>();
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                const Image(image: AssetImage("assets/images/mail.gif",)),
                const Column(
                  children:[ Text(tForgotPassTitle,style:TextStyle(
                    fontFamily: "Open Sans",
                     fontSize: 35,
                    fontWeight: FontWeight.bold,)),
                    SizedBox(height: 20,),
                  Text(tForgotPAssSubtitle,style: TextStyle(
                    fontSize:20,
                    fontWeight: FontWeight.normal,),textAlign: TextAlign.center,),
              ], ),
                const SizedBox(height: 40,),
                Form(child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: controller.email,
                        validator: (value)=>Tvalidator.validateEmail(value),
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15),)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: tThemeMain),),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                                      
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                        height: 50,
                        child: ElevatedButton(onPressed: (){
                        if(formKey.currentState!.validate()){

                            controller.sendPasswordResetEmail();
                        }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))),
                            backgroundColor: tThemeMain,
                            foregroundColor: Colors.white,
                
                            side: const BorderSide(color: tThemeMain),),
                            child: const Text("Next",style: TextStyle(fontSize: 20),)),
                
                    )],
                ))
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

