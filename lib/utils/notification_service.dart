import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/auth/bloc/auth_bloc.dart';
import 'package:gate_guard/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

part 'notifications.dart';

class NotificationController {
  static ReceivedAction? initialAction;
  static bool isInForeground = false;

  static Future<void> initializeLocalNotifications() async {
    AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [
        NotificationChannel(
          channelKey: 'app_notifications',
          channelName: 'App Notifications',
          channelDescription:
              'Notifications related to app activities and updates.',
          playSound: true,
          onlyAlertOnce: true,
          defaultColor: const Color(0xFF9D50DD),
          soundSource: 'resource://raw/res_custom_sound',
          enableVibration: true,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
        )
      ],
    );

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if(message!=null)NotificationController().handleNotification(message);
    // });

    Future<void> markNotificationAsProcessed(String notificationId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> processedNotifications =
          prefs.getStringList('processed_notifications')?.toSet() ?? <String>{};
      processedNotifications.add(notificationId);
      await prefs.setStringList(
          'processed_notifications', processedNotifications.toList());
    }

    Future<bool> isNotificationProcessed(String notificationId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> processedNotifications =
          prefs.getStringList('processed_notifications')?.toSet() ?? <String>{};
      return processedNotifications.contains(notificationId);
    }

    FirebaseMessaging.onMessage.listen((message) async {
      String? notificationId = message.messageId;

      // Check if this notification was already processed
      bool isProcessed = await isNotificationProcessed(notificationId!);

      if (!isProcessed) {
        // Handle the notification (show it or perform actions)
        NotificationController().handleNotification(message, "onMessage");

        // Mark it as processed so it won't be handled again
        await markNotificationAsProcessed(notificationId);
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   NotificationController().handleNotification(message);
    // });

    ///It is used to handle incoming Firebase Cloud Messaging (FCM) messages when the app is in the background or terminated.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  ///your app can handle incoming FCM messages even when it's not in the foreground and you can ensure Firebase is correctly initialized and functional in the background context.
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await NotificationController()
        .handleNotification(message, "firebaseMessagingBackgroundHandler");
  }

  Future<void> handleNotification(RemoteMessage message, String from) async {
    Map<String, String?> stringPayload = Map<String, String?>.from(
        jsonDecode(message.data['payload'])
            ?.map((key, value) => MapEntry(key.toString(), value?.toString())));

    if (message.data['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE') {
      residentVerifyNotification(stringPayload);
    } else if (message.data['action'] == 'VERIFY_GUARD_PROFILE_TYPE') {
      guardVerifyNotification(stringPayload);
    } else if (message.data['action'] == 'VERIFY_DELIVERY_ENTRY') {
      showNotificationWithActions(stringPayload);
    } else if (message.data['action'] == 'DELIVERY_ENTRY_APPROVE') {
      deliveryEntryApprovedNotification(stringPayload);
    } else if (message.data['action'] == 'DELIVERY_ENTRY_REJECTED') {
      deliveryEntryRejectedNotification(stringPayload);
    } else if (message.data['action'] == 'NOTIFY_GUARD_APPROVE') {
      notifyGuardApprove(stringPayload);
    } else if (message.data['action'] == 'NOTIFY_GUARD_REJECTED') {
      notifyGuardReject(stringPayload);
    } else if (message.data['action'] == 'NOTIFY_EXIT_ENTRY') {
      notifyResident(stringPayload);
    } else if (message.data['action'] == 'NOTIFY_CHECKED_IN_ENTRY') {
      notifyCheckedInEntry(stringPayload);
    } else if (message.data['action'] == 'RESIDENT_APPROVE') {
      notifyRoleVerification(stringPayload);
    } else if (message.data['action'] == 'RESIDENT_REJECT') {
      notifyRoleVerification(stringPayload);
    } else if (message.data['action'] == 'GUARD_APPROVE') {
      notifyRoleVerification(stringPayload);
    } else if (message.data['action'] == 'GUARD_REJECT') {
      notifyRoleVerification(stringPayload);
    } else if (message.data['action'] == 'CANCEL') {
      await AwesomeNotifications().cancel(int.parse(stringPayload['notificationId']!));
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    NavigatorState? currentState = MyApp.navigatorKey.currentState;
    if (receivedAction.payload?['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE' &&
        isInForeground == true) {
      currentState?.pushNamedAndRemoveUntil(
        '/resident-approval',
        (route) => route.isFirst,
      );
    } else if (receivedAction.payload?['action'] ==
            'VERIFY_GUARD_PROFILE_TYPE' &&
        isInForeground == true) {
      currentState?.pushNamedAndRemoveUntil(
        '/guard-approval',
        (route) => route.isFirst,
      );
    } else if (receivedAction.payload?['action'] == 'VERIFY_DELIVERY_ENTRY') {
      if (receivedAction.buttonKeyPressed == 'APPROVE') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');
        const apiKey =
            'https://invite.iotsense.in/api/v1/delivery-entry/approve-delivery';
        final Map<String, dynamic> data = {
          'id': receivedAction.payload?['id'],
        };
        final response = await http.post(
          Uri.parse(apiKey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(data),
        );
        debugPrint('response : ${response.body}');
        if (response.statusCode == 200) {
          debugPrint('successfully');
        } else {
          debugPrint(
              'error : statusCode: ${response.statusCode}, message: ${jsonDecode(response.body)['message']}');
        }
      } else if (receivedAction.buttonKeyPressed == 'REJECT') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');
        const apiKey =
            'https://invite.iotsense.in/api/v1/delivery-entry/reject-delivery';
        final Map<String, dynamic> data = {
          'id': receivedAction.payload?['id'],
        };
        final response = await http.post(
          Uri.parse(apiKey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(data),
        );
        debugPrint('response : ${response.body}');
        if (response.statusCode == 200) {
          debugPrint('successfully');
        } else {
          debugPrint(
              'error : statusCode: ${response.statusCode}, message: ${jsonDecode(response.body)['message']}');
        }
      } else if (isInForeground == true) {
        currentState?.pushNamedAndRemoveUntil(
            '/delivery-approval-screen', (route) => route.isFirst,
            arguments: receivedAction.payload);
      }
    }
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            carPlay: true,
            criticalAlert: true,
            provisional: true,
            sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      debugPrint('user denied permission');
    }
  }

  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> updateDeviceToken(
    BuildContext context,
  ) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
    });
  }
}
