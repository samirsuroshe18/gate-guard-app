import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/auth/bloc/auth_bloc.dart';
import 'package:gate_guard/features/auth/models/society_model.dart';
import 'package:gate_guard/features/auth/widgets/text_form_field.dart';

import '../widgets/auth_btn.dart';
import '../widgets/auth_dropdown_button_form_field.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController profileTypeController = TextEditingController();
  final TextEditingController societyController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController ownershipController = TextEditingController();
  final TextEditingController gateController = TextEditingController();

  final List<String> profileItems = ['Resident', 'Security'];
  late List<String> societyItems;
  late List<String> blockItems;
  late List<String> apartmentItems;
  final List<String> ownershipItems = ['Owner', 'Tenant'];
  late List<String> gateItems;

  bool _isLoading = false;
  String? profileType;
  String? societyName;
  String? blockName;
  String? apartment;
  String? ownershipStatus;
  String? gateName;
  late List<Society> response;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthSocietyDetails());
  }

  @override
  void dispose() {
    mobileController.dispose();
    profileTypeController.dispose();
    societyController.dispose();
    blockController.dispose();
    apartmentController.dispose();
    gateController.dispose();
    ownershipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthSocietyDetailsLoading){
            societyItems = ['Loading...'];
          }
          if(state is AuthSocietyDetailsSuccess){
            response = state.response;
            societyItems = state.response.map((society) => society.societyName ?? '').toList();
          }
          if(state is AuthSocietyDetailsFailure){
            societyItems = ['Failed to load...'];
          }
          if(state is AuthCompleteProfileLoading){
            _isLoading = true;
          }

          if(state is AuthCompleteProfileSuccess){
            if(state.response.role == 'admin'){
              Navigator.pushReplacementNamed(context, '/admin-home');
              _isLoading = false;
            }else if(state.response.role == 'user' && state.response.profileType == 'Resident'){
              Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              _isLoading = false;
            }else{
              Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              _isLoading = false;
            }
          }

          if(state is AuthCompleteProfileFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ));
            _isLoading = false;
          }

        },
        builder: (context, state){
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Mobile Number Field
                  AuthTextField(
                    hintText: 'Mobile No',
                    controller: mobileController,
                    errorMsg: 'Please enter valid mobile number',
                    obscureText: false,
                    icon: const Icon(Icons.phone),
                    inputLength: 10,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Profile type Dropdown
                  AuthDropdownButtonFormField<String>(
                    icon: const Icon(Icons.badge),
                    hintText: 'Profile type',
                    selectedValue: profileType,
                    onChanged: profileOnChanged,
                    controller: profileTypeController,
                    items: profileItems,
                  ),
                  const SizedBox(height: 20),

                  if (profileType != null)
                  // Society name Dropdown
                  AuthDropdownButtonFormField<String>(
                    hintText: 'Society name',
                    icon: const Icon(Icons.people),
                    selectedValue: societyName,
                    onChanged: societyOnChanged,
                    items: societyItems,
                    controller: societyController,
                  ),
                  if (profileType != null)const SizedBox(height: 20),

                  if(societyName!=null && profileType=='Resident')
                  // Block name Dropdown
                  AuthDropdownButtonFormField<String>(
                    icon: const Icon(Icons.location_city),
                    hintText: 'Block name',
                    selectedValue: blockName,
                    onChanged: blockOnChanged,
                    items: blockItems,
                    controller: blockController,
                  ),
                  if(societyName!=null && profileType=='Resident')const SizedBox(height: 20),

                  if(blockName!=null && profileType=='Resident')
                  // Apartment number Dropdown
                  AuthDropdownButtonFormField<String>(
                    icon: const Icon(Icons.location_city),
                    hintText: 'Apartment number',
                    selectedValue: apartment,
                    onChanged: apartmentOnChanged,
                    items: apartmentItems,
                    controller: apartmentController,
                  ),
                  if(blockName!=null && profileType=='Resident')const SizedBox(height: 20),

                  if(apartment!=null && profileType=='Resident')
                  // Ownership status Dropdown
                  AuthDropdownButtonFormField<String>(
                    icon: const Icon(Icons.security),
                    hintText: 'Ownership status',
                    selectedValue: ownershipStatus,
                    onChanged: ownershipOnChanged,
                    items: ownershipItems,
                    controller: ownershipController,
                  ),
                  if(apartment!=null && profileType=='Resident')const SizedBox(height: 20),

                  if(societyName!=null && profileType=='Security')
                  // Ownership status Dropdown
                    AuthDropdownButtonFormField<String>(
                      icon: const Icon(Icons.door_sliding_outlined),
                      hintText: 'Select gate',
                      selectedValue: gateName,
                      onChanged: gateOnChanged,
                      items: gateItems,
                      controller: gateController,
                    ),
                  if(societyName!=null && profileType=='Security')const SizedBox(height: 20),

                  AuthBtn(
                    onPressed: _onProfilePressed,
                    isLoading: _isLoading,
                    text: 'Submit',
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  void _onProfilePressed() {
    if (_formKey.currentState!.validate()) {
      if(profileType=='Resident' && societyName!=null && blockName!=null && apartment!=null && ownershipStatus!=null){
        context.read<AuthBloc>().add(
            AuthCompleteProfile(
              phoneNo: mobileController.text,
              profileType: '$profileType',
              societyName : '$societyName',
              blockName : '$blockName',
              apartment : '$apartment',
              ownershipStatus : '$ownershipStatus'
            )
        );
      }else if(profileType=='Security' && societyName!=null && gateName!=null){
        context.read<AuthBloc>().add(
            AuthCompleteProfile(
                phoneNo: mobileController.text,
                profileType: '$profileType',
                societyName : '$societyName',
                gateName : '$gateName'
            )
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')),
        );
      }
    }
  }

  void profileOnChanged(value) {
    setState(() {
      profileType = value;
    });
  }
  void societyOnChanged(newValue) {
    setState(() {
      societyName = newValue;
      final society = response.firstWhere((society) => society.societyName == societyName);
      blockItems = society.societyBlocks ?? [];
      gateItems = society.societyGates ?? [];
    });
  }
  void blockOnChanged(newValue) {
    setState(() {
      blockName = newValue;
      final society = response.firstWhere((society) => society.societyName == societyName);
      final apartments = society.societyApartments?.where((apartment) => apartment.societyBlock == blockName).toList();
      apartmentItems = apartments!.map((apartment) => apartment.apartmentName ?? '').toList();
    });
  }
  void apartmentOnChanged(newValue) {
    setState(() {
      apartment = newValue;
    });
  }
  void ownershipOnChanged(newValue) {
    setState(() {
      ownershipStatus = newValue;
    });
  }
  void gateOnChanged(newValue) {
    setState(() {
      gateName = newValue;
    });
  }
}