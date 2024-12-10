import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/administration/bloc/administration_bloc.dart';
import 'package:gate_guard/features/administration/models/society_guard.dart';
import 'package:gate_guard/features/administration/models/society_member.dart';
import 'package:gate_guard/features/resident_profile/bloc/resident_profile_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class AllGuardScreen extends StatefulWidget {
  const AllGuardScreen({super.key,});

  @override
  State<AllGuardScreen> createState() => _AllGuardScreenState();
}

class _AllGuardScreenState extends State<AllGuardScreen> {
  List<SocietyGuard> data = [];
  bool _isLoading = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Guards',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyGuardLoading) {
              _isLoading = true;
            }
            if (state is AdminGetSocietyGuardSuccess) {
              _isLoading = false;
              data = state.response;
            }
            if (state is AdminGetSocietyGuardFailure) {
              _isLoading = false;
            }
          },
          builder: (context, state){
            if(data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,  // Method to refresh user data
                child: ListView.builder(
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  itemBuilder: (context, index) {
                    final member = data[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(member.user?.profile ?? ""),
                        ),
                        title: Text(
                          member.user?.userName ?? "NA",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(member.user?.phoneNo ?? ""),
                        trailing: IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () {
                            _makePhoneCall(member.user?.phoneNo ?? "");
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (_isLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/loader.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              );
            }else {
              return RefreshIndicator(
                onRefresh: _refreshUserData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/error.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Something went wrong!",
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        )
    );
  }

  Future<void> _refreshUserData() async {
    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}