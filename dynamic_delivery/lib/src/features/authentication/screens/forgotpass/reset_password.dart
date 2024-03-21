import 'package:dynamic_delivery/src/features/authentication/controllers/forget_password_controller.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/login/login_screen.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.clear))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Image(image: AssetImage('assets/images/done.gif')),
                  const SizedBox(height: 30,),
                  Text(email, style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
                  const SizedBox(height: 10,),
                  Text("Password Reset Email Sent", style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
                  const SizedBox(height: 20,),
                  Text("Your Account Security is Our Priority! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected", style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
                  const SizedBox(height: 30,),
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(onPressed: ()=>Get.offAll(const LoginScreen()),
                      style:ElevatedButton.styleFrom(
                        backgroundColor: tThemeMain,
                        foregroundColor: Colors.white,
                      ), child: const Text('Done'),)),
                  const SizedBox(height: 20,),
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(onPressed: ()=>ForgetPasswordController.instance.resendPasswordResetEmail(email),
                        style:ElevatedButton.styleFrom(
                          backgroundColor: tThemeMain,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Resend Email')),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
