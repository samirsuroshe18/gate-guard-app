// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gate_guard/features/check_in/bloc/check_in_bloc.dart';
//
// class BlockSelectionScreen extends StatefulWidget {
//   final String? entryType;
//   const BlockSelectionScreen({super.key, this.entryType});
//
//   @override
//   State<BlockSelectionScreen> createState() => _BlockSelectionScreenState();
// }
//
// class _BlockSelectionScreenState extends State<BlockSelectionScreen> {
//   final TextEditingController searchController = TextEditingController();
//   List<String> allBlocks = [];
//   List<String> filteredBlocks = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<CheckInBloc>().add(CheckInGetBlock());
//     filteredBlocks = allBlocks;
//     searchController.addListener(() {
//       filterBlocks();
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   // Method to filter blocks based on the search input
//   void filterBlocks() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       filteredBlocks = allBlocks
//           .where((block) => block.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,),
//           onPressed: () {
//             context.read<CheckInBloc>().add(ClearFlat());
//             Navigator.of(context).pop();
//           },
//         ),
//         backgroundColor: Colors.blue,  // Change AppBar color here
//         title: const Text(
//           'Select Block',
//           style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),  // Text color adjusted to white for visibility
//         ),
//       ),
//       body: BlocConsumer<CheckInBloc, CheckInState>(
//         listener: (context, state){
//           if(state is CheckInGetBlockLoading){
//             _isLoading = true;
//           }
//           if(state is CheckInGetBlockSuccess){
//             allBlocks = state.response;
//             filteredBlocks = allBlocks;
//             _isLoading = false;
//           }
//           if(state is CheckInGetBlockFailure){
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(state.message.toString()),
//               backgroundColor: Colors.redAccent,
//             ));
//             allBlocks = [];
//             _isLoading = false;
//           }
//         },
//         builder: (context, state){
//           if(allBlocks.isNotEmpty && _isLoading == false){
//             return Column(
//               children: [
//                 Container(
//                   color: Colors.blue, // Background color for the search field's container
//                   padding: const EdgeInsets.all(8.0), // Add padding to provide spacing around the TextField
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       filled: true, // Enables the fill color
//                       fillColor: Colors.white, // Sets the background color of the TextField to white
//                       contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                       hintText: 'Search block',
//                       prefixIcon: const Icon(Icons.search, color: Colors.grey), // Set the icon color
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none, // Removes border for a cleaner look
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0,),
//                     child: GridView.builder(
//                       itemCount: filteredBlocks.length,
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 6,
//                         mainAxisSpacing: 6,
//                         childAspectRatio: 2.5,
//                       ),
//                       itemBuilder: (context, index) {
//                         return BlockCard(onFunctionCall: () => onBlockPressed(filteredBlocks[index]), blockName: filteredBlocks[index],);
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }else if(_isLoading){
//             return const Center(
//               child: RefreshProgressIndicator(),
//             );
//           }else{
//             return const Center(
//               child: Text("Something went wrong"),
//             );
//           }
//         },
//       )
//     );
//   }
//
//   void onBlockPressed(String blockName) {
//     Navigator.pushNamed(context, '/apartment-selection-screen', arguments: {'blockName' : blockName, 'entryType' : widget.entryType});
//   }
// }
//
// class BlockCard extends StatelessWidget {
//   final void Function() onFunctionCall;
//   final String blockName;
//
//   const BlockCard({super.key, required this.blockName, required this.onFunctionCall});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 4,
//       child: InkWell(
//         onTap: onFunctionCall,
//         borderRadius: BorderRadius.circular(15.0),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               const Icon(Icons.apartment, color: Colors.blueAccent),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   blockName,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/check_in/bloc/check_in_bloc.dart';
import 'package:lottie/lottie.dart';

class BlockSelectionScreen extends StatefulWidget {
  final String? entryType;
  const BlockSelectionScreen({super.key, this.entryType});

  @override
  State<BlockSelectionScreen> createState() => _BlockSelectionScreenState();
}

class _BlockSelectionScreenState extends State<BlockSelectionScreen> {
  final TextEditingController searchController = TextEditingController();
  List<String> data = [];
  List<String> filteredBlocks = [];
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    context.read<CheckInBloc>().add(CheckInGetBlock());
    filteredBlocks = data;
    searchController.addListener(() {
      filterBlocks();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Method to filter blocks based on the search input
  void filterBlocks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredBlocks = data
          .where((block) => block.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,),
            onPressed: () {
              context.read<CheckInBloc>().add(ClearFlat());
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.blue,  // Change AppBar color here
          title: const Text(
            'Select Block',
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),  // Text color adjusted to white for visibility
          ),
        ),
        body: BlocConsumer<CheckInBloc, CheckInState>(
          listener: (context, state){
            if(state is CheckInGetBlockLoading){
              _isLoading = true;
              _isError = false;
            }
            if(state is CheckInGetBlockSuccess){
              data = state.response;
              filteredBlocks = data;
              _isLoading = false;
              _isError = false;
            }
            if(state is CheckInGetBlockFailure){
              filteredBlocks = [];
              _isLoading = false;
              _isError = true;
            }
          },
          builder: (context, state){
            if(filteredBlocks.isNotEmpty && _isLoading == false){
              return Column(
                children: [
                  Container(
                    color: Colors.blue, // Background color for the search field's container
                    padding: const EdgeInsets.all(8.0), // Add padding to provide spacing around the TextField
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true, // Enables the fill color
                        fillColor: Colors.white, // Sets the background color of the TextField to white
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        hintText: 'Search block',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey), // Set the icon color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Removes border for a cleaner look
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: GridView.builder(
                          itemCount: filteredBlocks.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 2.5,
                          ),
                          itemBuilder: (context, index) {
                            return BlockCard(onFunctionCall: () => onBlockPressed(filteredBlocks[index]), blockName: filteredBlocks[index],);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
            } else if (filteredBlocks.isEmpty && _isError == true) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
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
            } else{
              return RefreshIndicator(
                onRefresh: _onRefresh,
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
                          "There are no Block",
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

  Future<void> _onRefresh() async {
    context.read<CheckInBloc>().add(CheckInGetBlock());
  }

  void onBlockPressed(String blockName) {
    Navigator.pushNamed(context, '/apartment-selection-screen', arguments: {'blockName' : blockName, 'entryType' : widget.entryType});
  }
}

class BlockCard extends StatelessWidget {
  final void Function() onFunctionCall;
  final String blockName;

  const BlockCard({super.key, required this.blockName, required this.onFunctionCall});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onFunctionCall,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.apartment, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  blockName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
