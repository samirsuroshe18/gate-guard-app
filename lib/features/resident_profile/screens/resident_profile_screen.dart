import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/bloc/auth_bloc.dart';

class ResidentProfileScreen extends StatefulWidget {
  const ResidentProfileScreen({super.key});

  @override
  State<ResidentProfileScreen> createState() => _ResidentProfileScreenState();
}

class _ResidentProfileScreenState extends State<ResidentProfileScreen> {
  String username = "loading...";
  String apartment = "Apartment ...";
  String block = "Block ...";
  String passcode = "loading...";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthGetUserSuccess){
            username = state.response.userName!;
            apartment = 'Apartment ${state.response.apartment!}';
            block = 'Block ${state.response.societyBlock!}';
            profileImage = state.response.profile!;
            passcode = state.response.checkInCode!;
          }
        },
        builder: (context, state){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage.isEmpty ? const AssetImage('assets/images/profile.png') : NetworkImage(profileImage),
                      ),
                      const SizedBox(height: 15),
                      // Username
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Flat Name
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: block,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            const TextSpan(
                              text: ' - ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: apartment,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      // 6-digit Passcode
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "Passcode: $passcode",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Option List Section
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('My Details', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Navigate to My Details page
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.blue),
                  title: const Text('My Flats', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Navigate to My Flats page
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.group, color: Colors.blue),
                  title: const Text('Apartment Members', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Navigate to Apartment Members page
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: const Text('Settings', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Navigate to Settings page
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text('Logout', style: TextStyle(fontSize: 18)),
                  onTap: _logoutUser,
                ),
                const Divider(height: 1),
              ],
            ),
          );
        },
      )
    );
  }

  void _logoutUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLogoutLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthLogoutFailure) {
                  return TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthLogout(),
                      );
                    },
                  );
                }else if (state is AuthLogoutSuccess) {
                  onPressed(){
                    removeAccessToken();
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Logout'),
                  );
                } else {
                  return TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthLogout(),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> removeAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("refreshMode");

    // Check if the widget is still mounted before using context
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
  }
}
