import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/admin_profile/screens/admin_profile_screen.dart';
import 'package:gate_guard/features/auth/bloc/auth_bloc.dart';

import '../../../utils/notification_service.dart';
import '../../administration/screens/administration_screen.dart';
import '../../invite_visitors/screens/invite_visitors_screen.dart';
import '../../my_visitors/screens/my_visitors_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  NotificationController notificationServices = NotificationController();

  final List<Widget> _adminPages = [
    const MyVisitorsScreen(),
    const InviteVisitorsScreen(),
    const AdministrationScreen(),
    const AdminProfileScreen(),
  ];

  Future<void> updateDeviceToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (mounted) {
        context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    // notificationServices.updateDeviceToken(context,);
    // Schedule the listener setup in the microtask queue to ensure context is ready.
    Future.microtask(() {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (mounted) {
          context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartGate',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _adminPages,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color.fromARGB(255, 193, 209, 240),
              iconSize: 20.0,
              selectedIconTheme: const IconThemeData(size: 28.0),
              selectedItemColor: const Color.fromARGB(255, 46, 90, 172),
              unselectedItemColor: Colors.black,
              selectedFontSize: 16.0,
              unselectedFontSize: 12,
              currentIndex: _selectedIndex,
              // selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'My Visitors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: 'Invite Visitors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings),
                  label: 'Administration',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ]),
        ),
      ),
    );
  }
}
