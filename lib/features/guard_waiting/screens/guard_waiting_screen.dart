import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gate_guard/features/guard_waiting/widgets/entry_card.dart';
import 'package:lottie/lottie.dart';

import '../models/entry.dart';

class GuardWaitingScreen extends StatefulWidget {
  const GuardWaitingScreen({super.key});

  @override
  State<GuardWaitingScreen> createState() => _GuardWaitingScreenState();
}

class _GuardWaitingScreenState extends State<GuardWaitingScreen> {
  List<Entry> data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<GuardWaitingBloc>().add(WaitingGetEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Waiting for Approval',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          elevation: 5,
        ),
        body: BlocConsumer<GuardWaitingBloc, GuardWaitingState>(
          listener: (context, state) {
            if (state is WaitingGetEntriesLoading) {
              _isLoading = true;
            }
            if (state is WaitingGetEntriesSuccess) {
              _isLoading = false;
              data = state.response;
            }
            if (state is WaitingGetEntriesFailure) {
              _isLoading = false;
              data = [];
            }
          },
          builder: (context, state) {
            if (data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: data.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return EntryCard(
                      data: data[index],
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
            } else {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/no_data.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "There is no waiting entries",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }

  // Function to simulate refreshing data
  Future<void> _refresh() async {
    context.read<GuardWaitingBloc>().add(WaitingGetEntries());
  }
}
