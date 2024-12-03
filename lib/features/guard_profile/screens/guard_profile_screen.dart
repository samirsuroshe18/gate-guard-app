import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/auth/models/get_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/bloc/auth_bloc.dart';

class GuardProfileScreen extends StatefulWidget {
  const GuardProfileScreen({super.key});

  @override
  State<GuardProfileScreen> createState() => _GuardProfileScreenState();
}

class _GuardProfileScreenState extends State<GuardProfileScreen> {
  GetUserModel? data;
  String userName = "loading...";
  String email = "loading...";
  String gateName = "loading...";
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
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthGetUserSuccess) {
              data = state.response;
              userName = state.response.userName ?? '';
              email = state.response.email ?? '';
              gateName = state.response.gateAssign ?? '';
              profileImage = state.response.profile ?? '';
              passcode = state.response.checkInCode ?? '';
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: profileImage.isEmpty
                                  ? const AssetImage('assets/images/profile.png')
                                  : NetworkImage(profileImage),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit-profile-screen', arguments: data);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18)
                              ),
                              child: const Text(
                                'Edit profile',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1F0FF),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFFE1E1E1), // Border color
                            width: 2, // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: const Icon(
                                      Icons.door_sliding_outlined,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: Text(
                                  'Gate : ${gateName.toUpperCase()}',
                                  style: const TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: Text(
                                  'Passcode : $passcode',
                                  style: const TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: const Icon(
                                      Icons.history,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: const Text(
                                  'View Checkout History',
                                  style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF5B5B5B),),
                                onTap: () {
                                  Navigator.pushNamed(context, '/checkout-history-screen');
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: const Icon(
                                      Icons.settings,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: const Text(
                                  'Settings',
                                  style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF5B5B5B),),
                                onTap: () {
                                  Navigator.pushNamed(context, '/setting-screen',);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            ListTile(
                              leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0x2FB74343),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Icon(
                                    Icons.logout,
                                    color: Color(0xFFAD3232),
                                  )),
                              title: const Text(
                                'Logout',
                                style: TextStyle(color: Color(0xFFB74343), fontWeight: FontWeight.w500),
                              ),
                              onTap: _logoutUser,
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
              ),
            );
          },
        ));
  }

  Future<void> _refreshData() async {
    context.read<AuthBloc>().add(AuthGetUser());
  }


  Widget _buildOptionTile(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey[800],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
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
                } else if (state is AuthLogoutSuccess) {
                  onPressed() {
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out')),
      );
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    }
  }
}

// import 'package:flutter/material.dart';
//
// class GuardProfileScreen extends StatelessWidget {
//   const GuardProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text(
//           "Profile",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: Column(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50.0,
//                       backgroundImage:
//                           AssetImage('assets/images/profile.png'),
//                     ),
//                     const SizedBox(height: 14),
//                     const Text(
//                       'Coffeestories df fd fdf gf gfd g fdg df gdf g dfg',
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     const Text(
//                       'mark.brock@icloud.com',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/edit-profile-screen');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(45),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18)
//                       ),
//                       child: const Text(
//                         'Edit profile',
//                         style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF3F3F3),
//                   borderRadius: BorderRadius.circular(25),
//                   border: Border.all(
//                     color: Color(0xFFE1E1E1), // Border color
//                     width: 2, // Border width
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(bottom: 6),
//                       child: ListTile(
//                         leading: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white
//                             ),
//                             child: const Icon(
//                               Icons.password,
//                               color: Color(0xFF5B5B5B),
//                             )),
//                         title: const Text(
//                           'Passcode : 123456',
//                           style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: const Divider(height: 2),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(bottom: 6),
//                       child: ListTile(
//                         leading: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                               color: Colors.white
//                             ),
//                             child: const Icon(
//                               Icons.history,
//                               color: Color(0xFF5B5B5B),
//                             )),
//                         title: const Text(
//                           'View Checkout History',
//                           style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
//                         ),
//                         trailing: const Icon(Icons.arrow_forward_ios,
//                             size: 16,
//                           color: Color(0xFF5B5B5B),),
//                         onTap: () {},
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: const Divider(height: 2),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(bottom: 6),
//                       child: ListTile(
//                         leading: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                             child: const Icon(
//                               Icons.settings,
//                               color: Color(0xFF5B5B5B),
//                             )),
//                         title: const Text(
//                           'Settings',
//                           style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
//                         ),
//                         trailing: const Icon(Icons.arrow_forward_ios,
//                             size: 16,
//                           color: Color(0xFF5B5B5B),),
//                         onTap: () {},
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: const Divider(height: 2),
//                     ),
//                     ListTile(
//                       leading: Container(
//                         padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                               color: const Color(0x2FB74343),
//                             borderRadius: BorderRadius.circular(10)
//                           ),
//                           child: const Icon(
//                             Icons.logout,
//                             color: Color(0xFFAD3232),
//                           )),
//                       title: const Text(
//                         'Logout',
//                         style: TextStyle(color: Color(0xFFB74343), fontWeight: FontWeight.w500),
//                       ),
//                       onTap: () {},
//                     ),
//                   ],
//                 ),
//               ),
//             ]
//           )
//         ))
//
//     );
//   }
// }
