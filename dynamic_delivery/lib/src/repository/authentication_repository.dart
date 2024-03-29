
import 'package:dynamic_delivery/bottom_navigationbar.dart';
import 'package:dynamic_delivery/home_screen.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/welcome/welcome_screen_first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/authentication/screens/welcome/welcome_main.dart';
import 'exceptions/login_with_mail_password_failure.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'exceptions/signup_mail_password_failure.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //variables
  final _auth=FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;


  @override
  void onReady() {
    firebaseUser= Rx<User?> (_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, setInitialScreen);
  }

  setInitialScreen(User? user) {
    user==null?Get.offAll(()=>const FirstScreen()):Get.offAll(()=>const BottomNavBar());
  }
  Future<String?> createUserWithEmailAndPassword(String email,String password)async{
      try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value!=null?Get.offAll(()=>const BottomNavBar()):Get.offAll(()=>const FirstScreen());
      }on FirebaseAuthException catch(e){
        final ex=SignupWithEmailAndPasswordFailure.code(e.code);
        return ex.message;
      } catch(_){
        const ex=SignupWithEmailAndPasswordFailure();
        return ex.message;
      }
      return null;
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password).whenComplete (() => Get.snackbar("Success", "You have Logged In!",
          snackPosition: SnackPosition.TOP,
          backgroundColor:Colors.green,
          colorText: Colors.white),)

           .catchError((error,stackTrace) {
         Get.snackbar("Error", "Something went wrong. Please check your credentials!",
             snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      });
      firebaseUser.value!=null?Get.offAll(()=>const BottomNavBar()):Get.offAll(()=>const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      const ex = LoginWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
   // try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().whenComplete
        (() => Get.snackbar("Success", "Your account has been created!",
          snackPosition: SnackPosition.TOP,
          backgroundColor:Colors.green,
          colorText: Colors.white),)

          .catchError((error,stackTrace) {
        Get.snackbar("Error", "Something went wrong.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      });

        // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      //auth._setInitialScreen(auth.firebaseUser as User?);
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    // }on FirebaseAuthException catch(e){
    //   final ex=SignupWithEmailAndPasswordFailure.code(e.code);
    //   throw ex.message;
    // } catch(_){
    //   const ex=SignupWithEmailAndPasswordFailure();
    //   throw ex.message;
    // }

  }
      Future<void> logout() async{
        await _auth.signOut();
      }

      Future<void>sendPasswordResetEmail(String email)async{
        try{
          await _auth.sendPasswordResetEmail(email: email);
        }on FirebaseAuthException catch(e){
          throw FirebaseAuthException(code: e.code);
        }on FirebaseException catch(e){
          throw FirebaseException(code: e.code, plugin: 'This is Error');
        }on FormatException catch(_){
          throw const FormatException();
        }catch(e){
          throw 'Something Went Wrong!,pls try again!';
        }
      }

    }
