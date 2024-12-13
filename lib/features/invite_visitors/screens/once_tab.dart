import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/invite_visitors_bloc.dart';

class OnceTab extends StatefulWidget {
  final Map<String, dynamic>? data;
  const OnceTab({super.key, this.data});

  @override
  State<OnceTab> createState() => _OnceTabState();
}

class _OnceTabState extends State<OnceTab> {
  String? selectedOption;
  TimeOfDay? currentTime = TimeOfDay.now();
  DateTime? currentDate = DateTime.now();
  DateTime? startDate;
  DateTime? endTime;
  DateTime? startTime;
  DateTime? endDate;
  bool _isLoading = false;

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
      startDate = DateTime(
          currentDate!.year, currentDate!.month, currentDate!.day, 00, 00, 00);
      endDate = DateTime(
          currentDate!.year, currentDate!.month, currentDate!.day, 23, 59, 59);
      startTime = DateTime(currentDate!.year, currentDate!.month,
          currentDate!.day, currentTime!.hour, currentTime!.minute);

      switch (option) {
        case '4 hours':
          endTime = startTime!.add(const Duration(hours: 4));
          break;
        case '8 hours':
          endTime = startTime!.add(const Duration(hours: 8));
          break;
        case '12 hours':
          endTime = startTime!.add(const Duration(hours: 12));
          break;
        case '24 hours':
          endTime = startTime!.add(const Duration(hours: 24));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<InviteVisitorsBloc, InviteVisitorsState>(
      listener: (context, state) {
        if (state is AddPreApproveEntryLoading) {
          _isLoading = true;
        }
        if (state is AddPreApproveEntryFailure) {
          _isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.redAccent,
          ));
        }
        if (state is AddPreApproveEntrySuccess) {
          _isLoading = false;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/otp-banner',
            arguments: state.response,
            (route) => route.isFirst, // Keep the first route only
          );
          // Navigator.pushReplacementNamed(context, '/otp-banner', arguments: state.response);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Select Date
              const Text('Select Date', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      currentDate = date;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentDate != null
                            ? DateFormat('yMMMd').format(currentDate!)
                            : 'Select Date',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Select Time', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: currentTime!,
                  );
                  if (time != null) {
                    setState(() {
                      currentTime = time;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentTime!.format(context)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pass Validity
              const Text('Pass Validity', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildOptionButton('4 hours'),
                  buildOptionButton('8 hours'),
                  buildOptionButton('12 hours'),
                  buildOptionButton('24 hours'),
                ],
              ),
              const SizedBox(height: 16),
              const Spacer(),

              // Pre-approve Button
              ElevatedButton(
                onPressed: () {
                  if (startDate != null && endTime != null) {
                    if (endTime!.isAfter(endDate!)) {
                      context.read<InviteVisitorsBloc>().add(AddPreApproveEntry(
                          name: widget.data?['name'],
                          mobNumber: widget.data?['number'],
                          profileImg: widget.data?['profileImg'],
                          companyName: widget.data?['companyName'],
                          companyLogo: widget.data?['companyLogo'],
                          serviceName: widget.data?['serviceName'],
                          serviceLogo: widget.data?['serviceLogo'],
                          vehicleNumber: widget.data?['vehicleNo'],
                          entryType: widget.data?['profileType'],
                          checkInCodeStartDate: startDate!.toIso8601String(),
                          checkInCodeExpiryDate: endTime!.toIso8601String(),
                          checkInCodeStart: startTime!.toIso8601String(),
                          checkInCodeExpiry: endTime!.toIso8601String()));
                    } else {
                      context.read<InviteVisitorsBloc>().add(AddPreApproveEntry(
                          name: widget.data?['name'],
                          mobNumber: widget.data?['number'],
                          profileImg: widget.data?['profileImg'],
                          companyName: widget.data?['companyName'],
                          companyLogo: widget.data?['companyLogo'],
                          serviceName: widget.data?['serviceName'],
                          serviceLogo: widget.data?['serviceLogo'],
                          vehicleNumber: widget.data?['vehicleNo'],
                          entryType: widget.data?['profileType'],
                          checkInCodeStartDate: startDate!.toIso8601String(),
                          checkInCodeExpiryDate: endDate!.toIso8601String(),
                          checkInCodeStart: startTime!.toIso8601String(),
                          checkInCodeExpiry: endTime!.toIso8601String()));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Please select date, time and pass validity before continuing.'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.redAccent,
                    ));
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Pre-approve',
                        ),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }

  Widget buildOptionButton(String option) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectOption(option),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedOption == option ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: selectedOption == option ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
