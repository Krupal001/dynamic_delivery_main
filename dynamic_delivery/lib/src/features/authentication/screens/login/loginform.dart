import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/strings.dart';
import '../../../../utils/Validations/validations.dart';
import '../../../../utils/theme/colors/colors.dart';
import '../../controllers/login_controller.dart';
import '../forgotpass/forgotpassscreen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(LoginController());
    final formKey=GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller.email,
            validator: (value)=>Tvalidator.validateEmail(value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_2_outlined),
              labelText: tEmail,
              hintText: tEmail,
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
          const SizedBox(height: 20,),
          Obx(
                ()=> TextFormField(
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              validator: (value)=>Tvalidator.validatePassword(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline_sharp),
                labelText: tPass,
                hintText: tPass,
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value=!controller.hidePassword.value,
                    icon:Icon(controller.hidePassword.value ? Icons.remove_red_eye_sharp:LineAwesomeIcons.eye_slash)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15),)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: tThemeMain),),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),


              ),

            ),
          ), const SizedBox(height: 20,),
          Align(alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ForgotPassMailScreen()));
              },
                  child: const Text("Forgot Password ?",
                    style: TextStyle(color: tThemeMain, fontSize: 17),))),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(onPressed: () {
              if(formKey.currentState!.validate()){
                LoginController.instance.login(controller.email.text.trim(), controller.password.text.trim());
              }
            },
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  backgroundColor: tThemeMain,
                  foregroundColor: Colors.white,

                  side: const BorderSide(color: tThemeMain),
                  //padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 25),

                ),
                child: const Text("SIGN IN", style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Arial"))),

          ),
         //
         ],),
    );
  }
}