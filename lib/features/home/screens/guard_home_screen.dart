import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/auth/bloc/auth_bloc.dart';

import '../../../utils/notification_service.dart';
import '../../guard_entry/screens/guard_entry_screen.dart';
import '../../guard_exit/screens/guard_exit_screen.dart';
import '../../guard_profile/screens/guard_profile_screen.dart';
import '../../guard_waiting/screens/guard_waiting_screen.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _guardPages = [
    const GuardEntryScreen(),
    const GuardWaitingScreen(),
    const GuardExitScreen(),
    const GuardProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    NotificationController().requestNotificationPermission();
    // NotificationController().updateDeviceToken(context);
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _guardPages,
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
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_empty),
                label: 'Waiting',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.exit_to_app),
                label: 'Exit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.security),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
