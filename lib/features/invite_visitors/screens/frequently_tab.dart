import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/invite_visitors/bloc/invite_visitors_bloc.dart';
import 'package:intl/intl.dart';

class FrequentlyTab extends StatefulWidget {
  final Map<String, dynamic>? data;
  const FrequentlyTab({super.key, this.data});

  @override
  State<FrequentlyTab> createState() => _FrequentlyTabState();
}

class _FrequentlyTabState extends State<FrequentlyTab> {
  DateTime? currentStartDate;
  DateTime? currentEndDate;
  TimeOfDay? currentStartTime;
  TimeOfDay? currentEndTime;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  bool _isLoading = false;

  void _setDatesBasedOnSelection(int days) {
    setState(() {
      currentStartDate = DateTime.now();
      currentEndDate = currentStartDate!.add(Duration(days: days));
    });
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    DateTime initialDate = isStartDate
        ? (currentStartDate ?? DateTime.now())
        : (currentEndDate ?? DateTime.now());
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          currentStartDate = picked;
        } else {
          currentEndDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime({required bool isStartTime}) async {
    TimeOfDay initialTime = isStartTime
        ? (currentStartTime ?? TimeOfDay.now())
        : (currentEndTime ?? TimeOfDay.now());

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          currentStartTime = picked;
        } else {
          currentEndTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<InviteVisitorsBloc, InviteVisitorsState>(
      listener: (context, state) {
        if (state is AddPreApproveEntryLoading) {
          _isLoading = true;
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
        if (state is AddPreApproveEntryFailure) {
          _isLoading = false;
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Allow Entry for Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _setDatesBasedOnSelection(7),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 0), // Vertical padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 5, // Shadow effect
                          ),
                          child: const Text(
                            '1 week',
                            style: TextStyle(
                              fontSize: 16, // Increase font size
                              fontWeight: FontWeight.bold, // Make text bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _setDatesBasedOnSelection(15),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 0), // Vertical padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 5, // Shadow effect
                          ),
                          child: const Text(
                            '15 days',
                            style: TextStyle(
                              fontSize: 16, // Increase font size
                              fontWeight: FontWeight.bold, // Make text bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _setDatesBasedOnSelection(30),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 0), // Vertical padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 5, // Shadow effect
                          ),
                          child: const Text(
                            '1 month',
                            style: TextStyle(
                              fontSize: 16, // Increase font size
                              fontWeight: FontWeight.bold, // Make text bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentStartDate = null;
                              currentEndDate = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent, // Text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 0), // Vertical padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 5, // Shadow effect
                          ),
                          child: const Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 16, // Increase font size
                              fontWeight: FontWeight.bold, // Make text bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Start Date'),
                TextFormField(
                  readOnly: currentStartDate != null,
                  onTap: () {
                    if (currentStartDate == null) {
                      _selectDate(isStartDate: true);
                    }
                  },
                  controller: TextEditingController(
                    text: currentStartDate != null
                        ? DateFormat('dd MMM yyyy').format(currentStartDate!)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('End Date'),
                TextFormField(
                  readOnly: currentEndDate != null,
                  onTap: () {
                    if (currentEndDate == null) _selectDate(isStartDate: false);
                  },
                  controller: TextEditingController(
                    text: currentEndDate != null
                        ? DateFormat('dd MMM yyyy').format(currentEndDate!)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Start Time'),
                TextFormField(
                  readOnly: true,
                  onTap: () => _selectTime(isStartTime: true),
                  controller: TextEditingController(
                    text: currentStartTime != null
                        ? currentStartTime!.format(context)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('End Time'),
                TextFormField(
                  readOnly: true,
                  onTap: () => _selectTime(isStartTime: false),
                  controller: TextEditingController(
                    text: currentEndTime != null
                        ? currentEndTime!.format(context)
                        : '',
                  ),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (currentStartDate != null &&
                        currentEndDate != null &&
                        currentStartTime != null &&
                        currentEndTime != null) {
                      startDate = DateTime(
                          currentStartDate!.year,
                          currentStartDate!.month,
                          currentStartDate!.day,
                          00,
                          00,
                          00);
                      endDate = DateTime(
                          currentEndDate!.year,
                          currentEndDate!.month,
                          currentEndDate!.day,
                          23,
                          59,
                          59);
                      startTime = DateTime(
                          startDate!.year,
                          startDate!.month,
                          startDate!.day,
                          currentStartTime!.hour,
                          currentStartTime!.minute);
                      endTime = DateTime(
                          endDate!.year,
                          endDate!.month,
                          endDate!.day,
                          currentEndTime!.hour,
                          currentEndTime!.minute);

                      if (startDate!.isAfter(endDate!)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Start date cannot be later than the end date. Please select a valid date range.'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.redAccent,
                        ));
                        return;
                      }

                      int startTimeInSeconds = startTime!.hour * 3600 +
                          startTime!.minute * 60 +
                          startTime!.second;
                      int endTimeInSeconds = endTime!.hour * 3600 +
                          endTime!.minute * 60 +
                          endTime!.second;
                      int result =
                          startTimeInSeconds.compareTo(endTimeInSeconds);

                      if (result > 0) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Start time cannot be later than the end time. Please select a valid time range.'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.redAccent,
                        ));
                        return;
                      }

                      // Convert TimeOfDay to minutes since midnight
                      int startMinutes = currentStartTime!.hour * 60 +
                          currentStartTime!.minute;
                      int endMinutes =
                          currentEndTime!.hour * 60 + currentEndTime!.minute;

                      // Calculate the time difference
                      int timeDifferenceInMinutes = endMinutes - startMinutes;

                      // Minimum time difference (30 minutes)
                      const int minDifferenceInMinutes = 30;

                      // Validate the difference
                      if (timeDifferenceInMinutes < minDifferenceInMinutes) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'The entry duration should be at least 30 minutes.'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.redAccent,
                        ));
                        return;
                      }

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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please select both a date and a time before continuing.'),
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
          ),
        );
      },
    ));
  }
}
