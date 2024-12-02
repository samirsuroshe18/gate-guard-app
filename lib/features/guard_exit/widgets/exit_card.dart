import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:intl/intl.dart';

import '../../guard_waiting/models/entry.dart';

class ExitCard extends StatelessWidget {
  final Entry data;
  final String type;

  const ExitCard({super.key, required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1.0, // Minimal shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Increased padding for more white space
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(context),
                const SizedBox(width: 12.0), // Increased spacing between avatar and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3000000), // Softer black color
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      _buildEntryTypeTag(data.entryType ?? data.profileType ?? 'NA'),
                      const SizedBox(height: 10.0),
                      _buildInfoRow(Icons.door_front_door, data.approvedBy?.user != null || data.profileType == 'Resident' ? data.gateName ?? 'NA' : data.societyDetails?.societyGates ?? 'NA'),
                      _buildInfoRow(Icons.two_wheeler, data.vehicleDetails?.vehicleNumber ?? 'NA'),
                      _buildInfoRow(Icons.access_time, DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now())),
                      _buildInfoRow(Icons.home, _getApartmentDetails()),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showOutConfirmationDialog(context, data, type),
                child: _buildOutButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2, // Border width
        ),
      ),
      child: CircleAvatar(
        backgroundImage: _getProfileImage(),
        radius: 45,
        child: GestureDetector(
          onTap: () {
            _showImageDialog(data.profileImg, context); // Open dialog on tap
          },
        ),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (data.profileImg != null && data.allowedBy == null) {
      return NetworkImage(data.profileImg!);
    } else if (data.profileType != null && data.profileImg != null) {
      return NetworkImage(data.profileImg!);
    } else {
      return AssetImage(data.profileImg!);
    }
  }

  Widget _buildEntryTypeTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100, // Subtle blue color
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600), // Softer grey for icons
        const SizedBox(width: 4.0),
        Text(info.isEmpty ? "NA" : info, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  String _getApartmentDetails() {
    if (data.profileType != null && data.apartment == null) {
      return data.societyName!;
    } else if (data.allowedBy != null) {
      return data.apartment!;
    } else {
      return data.societyDetails!.societyApartments!.map((item) => item.apartment as String).toList().join(', ');
    }
  }

  Widget _buildOutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade400, // Softer green
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Row(
        children: [
          Icon(Icons.exit_to_app, color: Colors.white, size: 20),
          SizedBox(width: 4),
          Text(
            'OUT',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showOutConfirmationDialog(BuildContext context, Entry data, String type) {
    bool isLoading = false;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: BlocConsumer<GuardExitBloc, GuardExitState>(
            listener: (context, state) {
              if (state is ExitEntryLoading) {
                isLoading = true;
              }
              if (state is ExitEntrySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.response['message']),
                  backgroundColor: Colors.green,
                ));
                Navigator.of(context).pop();
                isLoading = false;
                _refresh(context);
              }
              if (state is ExitEntryFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
                isLoading = false;
              }
            },
            builder: (context, state) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: _getProfileImage(),
                            radius: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name!,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4.0),
                                _buildTag(data.entryType ?? data.profileType!),
                                const SizedBox(height: 8.0),
                                _buildInfoRow(Icons.two_wheeler, data.vehicleDetails?.vehicleNumber ?? 'NA'),
                                const SizedBox(height: 4.0),
                                _buildInfoRow(Icons.access_time, DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now())),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String? isPreApproved = data.approvedBy != null && data.entryType != null ? data.entryType : data.profileType;
                            context.read<GuardExitBloc>().add(ExitEntry(id: data.id!, entryType: isPreApproved != null ? 'preapproved' : 'delivery'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400, // Softer green for minimal look
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                            'Confirm Exit',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: child,
          ),
        );
      },
    );
  }

  void _refresh(BuildContext context){
    switch(type){
      case 'all' :
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
        context.read<GuardExitBloc>().add(ExitGetCabEntries());
        context.read<GuardExitBloc>().add(ExitGetDeliveryEntries());
        context.read<GuardExitBloc>().add(ExitGetGuestEntries());
        context.read<GuardExitBloc>().add(ExitGetServiceEntries());
      case 'cab' :
        context.read<GuardExitBloc>().add(ExitGetCabEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      case 'delivery' :
        context.read<GuardExitBloc>().add(ExitGetDeliveryEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      case 'guest' :
        context.read<GuardExitBloc>().add(ExitGetGuestEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      case 'service' :
        context.read<GuardExitBloc>().add(ExitGetServiceEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      default:
        return;
    }
  }

  void _showImageDialog(String? imageUrl, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent, // Transparent background
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.white, // White background for the image container
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit to image size
                    children: [
                      imageUrl!.contains("assets")
                          ? Image.asset(imageUrl,
                        height: MediaQuery.of(context).size.height * 0.5, // Constrain the height
                        width: double.infinity, // Expand to the width of the dialog
                        fit: BoxFit.contain, // Contain image within the space, maintaining aspect ratio
                      )
                          : Image.network(
                        imageUrl,
                        height: MediaQuery.of(context).size.height * 0.5, // Constrain the height
                        width: double.infinity, // Expand to the width of the dialog
                        fit: BoxFit.contain, // Contain image within the space, maintaining aspect ratio
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 100);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
