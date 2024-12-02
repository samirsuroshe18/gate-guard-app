import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/auth/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/option_tile.dart';
import '../widgets/profile_section.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    if(!mounted) return;
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserSuccess) {
            // Handle success state if needed
          }
        },
        builder: (context, state) {
          if (state is AuthGetUserSuccess) {
            return RefreshIndicator(
              onRefresh: _refreshUserData,  // Method to refresh user data
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileSection(
                      username: state.response.userName!,
                      apartment: state.response.apartment!,
                      block: state.response.societyBlock!,
                      passcode: state.response.checkInCode!,
                      profileImage: state.response.profile!,
                    ),
                    const SizedBox(height: 20),
                    _buildOptionList(),
                  ],
                ),
              ),
            );
          } else if (state is AuthGetUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Failed to load user data'));
          }
        },
      ),
    );
  }

  Future<void> _refreshUserData() async {
    context.read<AuthBloc>().add(AuthGetUser());
  }

  Widget _buildOptionList() {
    return Column(
      children: <Widget>[
        const OptionTile(
          icon: Icons.person,
          title: 'My Details',
          onTap: null, // Define action here
        ),
        const Divider(height: 1),
        const OptionTile(
          icon: Icons.home,
          title: 'My Flats',
          onTap: null,
        ),
        const Divider(height: 1),
        const OptionTile(
          icon: Icons.group,
          title: 'Apartment Members',
          onTap: null,
        ),
        const Divider(height: 1),
        const OptionTile(
          icon: Icons.settings,
          title: 'Settings',
          onTap: null,
        ),
        const Divider(height: 1),
        OptionTile(
          icon: Icons.logout,
          title: 'Logout',
          color: Colors.redAccent,
          onTap: _logoutUser,
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _logoutUser() async {
    if(!mounted) return;

    showDialog(context: context,
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
                      context.read<AuthBloc>().add(AuthLogout());
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
    await _prefs.remove("accessToken");
    await _prefs.remove("refreshMode");

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
  }
}
