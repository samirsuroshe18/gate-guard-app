import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/check_in/bloc/check_in_bloc.dart';

import '../../auth/widgets/text_form_field.dart';

class MobileNoScreen extends StatefulWidget {
  final String? entryType;
  const MobileNoScreen({super.key, this.entryType});

  @override
  State<MobileNoScreen> createState() => _MobileNoScreenState();
}

class _MobileNoScreenState extends State<MobileNoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _validatePhoneNumber() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      context.read<CheckInBloc>().add(CheckInGetNumber(
          mobNumber: _phoneController.text, entryType: widget.entryType!));
      if (widget.entryType == 'delivery') {
        Navigator.pushNamed(context, '/delivery-approval-profile',
            arguments: {'mobNumber': _phoneController.text});
      } else if (widget.entryType == 'guest') {
        Navigator.pushNamed(context, '/guest-approval-profile',
            arguments: {'mobNumber': _phoneController.text});
      } else if (widget.entryType == 'cab') {
        Navigator.pushNamed(context, '/cab-approval-profile',
            arguments: {'mobNumber': _phoneController.text});
      } else if (widget.entryType == 'others') {
        Navigator.pushNamed(context, '/other-approval-profile',
            arguments: {'mobNumber': _phoneController.text});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mobile Number',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white, // Set screen background color to white
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Enter Delivery Mobile Number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AuthTextField(
                icon: const Icon(Icons.phone),
                hintText: 'Phone number',
                controller: _phoneController,
                errorMsg: 'Please enter phone number',
                obscureText: false,
                inputLength: 10,
                inputType: TextInputType.number,
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: _validatePhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Continue',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
