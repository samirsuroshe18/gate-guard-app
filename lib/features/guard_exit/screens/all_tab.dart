import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../guard_waiting/models/entry.dart';
import '../widgets/exit_card.dart';

class AllTab extends StatefulWidget {
  const AllTab({super.key});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  List<Entry> data = [];

  @override
  void initState() {
    super.initState();
    context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<GuardExitBloc, GuardExitState>(
        listener: (context, state) {
          if (state is ExitGetAllowedEntriesLoading) {
            _isLoading = true;
          }
          if (state is ExitGetAllowedEntriesSuccess) {
            _isLoading = false;
            data = state.response;
          }
          if (state is ExitGetAllowedEntriesFailure) {
            _isLoading = false;
            data = [];
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: data.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return ExitCard(data: data[index], type: 'all');
                  },
                ),
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
                        "All clear! No visitors at the moment.",
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
      ),
    );
  }

  Future<void> _refresh() async {
    context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
  }

  void onSearch(value) {}

  // ignore: unused_element
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearch,
          decoration: InputDecoration(
            hintText: 'Search by Name, Flat, or Vehicle number',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.search, color: Colors.blue),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0), // Adjusting padding
          ),
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          cursorColor: Colors.blue, // Cursor color
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}