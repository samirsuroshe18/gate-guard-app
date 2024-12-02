import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/check_in_bloc.dart';

class ApartmentSelectionScreen extends StatefulWidget {
  final String? entryType;
  final String? blockName;
  const ApartmentSelectionScreen({super.key, this.blockName, this.entryType});

  @override
  State<ApartmentSelectionScreen> createState() =>
      _ApartmentSelectionScreenState();
}

class _ApartmentSelectionScreenState extends State<ApartmentSelectionScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> allFlats = [];
  List<String> filteredFlats = [];
  List<String> selectedFlats = [];
  String? blockName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    blockName = widget.blockName;
    context.read<CheckInBloc>().add(CheckInGetApartment(blockName: blockName!));
    filteredFlats = allFlats;
    searchController.addListener(filterFlats);
    context.read<CheckInBloc>().add(AddFlat());
  }

  void filterFlats() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredFlats =
          allFlats.where((flat) => flat.toLowerCase().contains(query)).toList();
    });
  }

  void toggleFlatSelection(String flat) {
    if (selectedFlats.contains(flat)) {
      context.read<CheckInBloc>().add(RemoveFlat(flatName: flat));
    } else {
      context.read<CheckInBloc>().add(AddFlat(flatName: flat));
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Change AppBar color here
        title: const Text(
          'Select apartment',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight
                  .bold), // Text color adjusted to white for visibility
        ),
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is FlatState) {
            selectedFlats = state.selectedFlats;
          }
          if (state is CheckInGetApartmentLoading) {
            _isLoading = true;
          }
          if (state is CheckInGetApartmentSuccess) {
            allFlats = state.response;
            filteredFlats = allFlats;
            _isLoading = false;
          }
          if (state is CheckInGetApartmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message.toString()),
              backgroundColor: Colors.redAccent,
            ));
            allFlats = [];
            _isLoading = false;
          }
        },
        builder: (context, state) {
          if (allFlats.isNotEmpty && _isLoading == false) {
            return Column(
              children: [
                // Search Bar and Block Info
                Container(
                  color: Colors
                      .blue, // Background color for the search field's container
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true, // Enables the fill color
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Search apartment',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Block : $blockName',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to previous page (block selection)
                          Navigator.of(context).pop();
                        },
                        child: const Text("Select Another Block"),
                      )
                    ],
                  ),
                ),
                if (selectedFlats.isNotEmpty)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedFlats.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(selectedFlats[index]),
                            onDeleted: () {
                              // context.read().add(RemoveFlat(blockName: blockName!, flatName: selectedFlats[index]));
                              toggleFlatSelection(selectedFlats[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                // Apartment Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      itemCount: filteredFlats.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (context, index) {
                        final flat = filteredFlats[index];
                        final selected = '$blockName ${filteredFlats[index]}';
                        final isSelected = selectedFlats.contains(selected);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              toggleFlatSelection(selected);
                            },
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.home,
                                      color: Colors.blueAccent),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      flat,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      toggleFlatSelection(selected);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Next Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _onContinuePress,
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
            );
          } else if (_isLoading) {
            return const Center(
              child: RefreshProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
    );
  }

  void _onContinuePress() {
    if (selectedFlats.isNotEmpty) {
      Navigator.pushNamed(context, '/mobile-no-screen',
          arguments: {'entryType': widget.entryType});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select apartment'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
