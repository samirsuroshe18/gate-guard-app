import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/administration/bloc/administration_bloc.dart';
import 'package:gate_guard/features/administration/models/society_member.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class AllResidentScreen extends StatefulWidget {
  const AllResidentScreen({super.key,});

  @override
  State<AllResidentScreen> createState() => _AllResidentScreenState();
}

class _AllResidentScreenState extends State<AllResidentScreen> {
  List<SocietyMember> data = [];
  List<SocietyMember> filteredResidents = [];
  String searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    context.read<AdministrationBloc>().add(AdminGetSocietyMember());
  }

  void filterResidents(String query) {
    final filtered = data.where((data) {
      final nameLower = data.user?.userName?.toLowerCase() ?? '';
      final phoneLower = data.user?.phoneNo?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredResidents = filtered;
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Members',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyMemberLoading) {
              _isLoading = true;
            }
            if (state is AdminGetSocietyMemberSuccess) {
              _isLoading = false;
              data = state.response;
              filteredResidents = data;
            }
            if (state is AdminGetSocietyMemberFailure) {
              _isLoading = false;
            }
          },
          builder: (context, state){
            if(data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,  // Method to refresh user data
                child: Column(
                  children: [
                    TextField(
                      onChanged: (query) => filterResidents(query),
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search by name or mobile number',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredResidents.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        itemBuilder: (context, index) {
                          final member = filteredResidents[index];
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
                    ),
                  ],
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
    context.read<AdministrationBloc>().add(AdminGetSocietyMember());
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
