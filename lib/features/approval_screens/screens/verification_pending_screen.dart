import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  State<VerificationPendingScreen> createState() => _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {
  String status = 'pending';
  String? profileImg;

  Future<void> _refresh() async {
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Verification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthGetUserSuccess){
            profileImg = state.response.profile;

            if(state.response.role=='admin'){
              if(state.response.residentStatus=='approve'){
                Navigator.pushReplacementNamed(context, '/admin-home');
              }
            }else if(state.response.profileType=='Security'){
              status = state.response.guardStatus!;
              if(state.response.guardStatus=='approve'){
                Navigator.pushReplacementNamed(context, '/guard-home');
              }
            }else if(state.response.profileType=='Resident'){
              status = state.response.residentStatus!;
              if(state.response.residentStatus=='approve'){
                Navigator.pushReplacementNamed(context, '/resident-home');
              }
            }

          }
        },
        builder: (context, state){
          return RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture Placeholder
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImg!=null ?
                      NetworkImage(profileImg!) :
                      const AssetImage('assets/images/profile.png'),
                      child: const Opacity(
                        opacity: 0.5,
                        child: Center(
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Verification Pending Message
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Your Profile is Under Verification',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'We are currently verifying your information. Please allow some time for this process.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  // Steps of Verification
                  const Text(
                    'Verification Steps:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // List of Verification Steps
                  const ListTile(
                    title: Text('1. Profile Submitted'),
                    subtitle: Text('We have received your profile details.'),
                  ),
                  const ListTile(
                    title: Text('2. Under Review'),
                    subtitle: Text('Your information is being reviewed by our team.'),
                  ),
                  const ListTile(
                    title: Text('3. Verification Complete'),
                    subtitle: Text('Once verified, you will be granted full access.'),
                  ),
                  ListTile(
                    title: const Text('Your profile status'),
                    subtitle: Text(status.toUpperCase()),
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
