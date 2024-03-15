import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/notification/message_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationServices {
  String? token = "";

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);

        }
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(1000000).toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    token = await messaging.getToken().then((newToken) async {
      if (newToken != null &&  newToken != token) {
        // Store the new token in Firestore only if it's different from the previous one
        await _storeTokenInFirestore(newToken);
        token = newToken;
      }
      return token;
    });

    return token!;
  }

  Future<void> _storeTokenInFirestore(String newToken) async {
    try {
      // Specify the collection and document where you want to store the token
      String collectionName = 'deviceTokens';

      QuerySnapshot existingTokens = await _firestore
          .collection(collectionName)
          .where('token', isEqualTo: newToken)
          .get();

      if (existingTokens.docs.isEmpty) {
        // If the token doesn't exist, add it to Firestore
        await _firestore.collection(collectionName).add({
          'token': newToken,
        });
      // Add the token in Firestore

      }
    } catch (e) {
      if (kDebugMode) {
        print('Error storing token in Firestore: $e');
      }
    }
  }

  void handleMessage(BuildContext context,RemoteMessage message){
    if(message.data['type']=='msg'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const MessageScreen()));
    }
  }
  //redirect screen when app is in background or terminated
  Future<void>setupInteractMessage(BuildContext context) async{
    //when app is terminated
    RemoteMessage? initialMessage=await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage!=null){
      handleMessage(context, initialMessage);
    }
    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }
}


  //function to get device token on which we will send the notifications




