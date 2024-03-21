import 'package:dynamic_delivery/src/repository/authentication_repository.dart';
import 'package:dynamic_delivery/src/utils/helper/helper_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/forgotpass/reset_password.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance=>Get.find();

  final email=TextEditingController();
  GlobalKey<FormState>forgotPasswordFormKey=GlobalKey<FormState>();

  sendPasswordResetEmail()async{
 
    await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());
    Helper.successSnackBar(title: 'Email Sent',message: 'Email Link Sent to Reset Your Password!');
    Get.to(()=>ResetPasswordScreen(email:email.text.trim()));
  
  }
  resendPasswordResetEmail(String email)async{
    await AuthenticationRepository.instance.sendPasswordResetEmail(email);
  }
}