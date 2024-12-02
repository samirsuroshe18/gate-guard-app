import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../guard_waiting/models/entry.dart';

class VisitorDeniedCard extends StatelessWidget {
  final Entry data;

  void _makePhoneCall() async {
    final Uri url = Uri(
      scheme: 'tel',
      path: data.mobNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not connect $url';
    }
  }

  const VisitorDeniedCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Profile image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: data.allowedBy != null && data.approvedBy?.user != null
                      ? AssetImage(data.profileImg!)
                      : data.profileImg != null
                      ? NetworkImage(data.profileImg!)
                      : const AssetImage('assets/images/profile.png'),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  child: GestureDetector(
                    onTap: () {
                      _showImageDialog(data.profileImg, context); // Open dialog on tap
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // User details and tag
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // User name and denied by details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // Made name text responsive
                            flex: 2,
                            child: Text(
                              data.name!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis, // Prevents overflow in narrow screens
                            ),
                          ),

                          // Wrapped the tag in Flexible to prevent overflow
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                data.entryType ?? data.profileType!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis, // Prevents overflow if text is too long
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Denied by: ${data.societyDetails!.societyApartments![0].entryStatus!.rejectedBy!.userName!}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Time
                          Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.grey[700]),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('hh:mm a').format(data.exitTime ?? DateTime.now()),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),

                          // Date
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey[700]),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd MMM, yyyy').format(data.exitTime ?? DateTime.now()),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.directions_car, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            data.vehicleDetails?.vehicleNumber ?? 'NA',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            SizedBox(
              width: double.infinity,  // Makes the button take full width
              child: ElevatedButton(
                onPressed: _makePhoneCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Set the button's color to blue
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the icon and text
                  children: [
                    Icon(
                      Icons.call,  // Use the call icon
                      color: Colors.white,  // Set the icon color to match the text color
                    ),
                    SizedBox(width: 8),  // Add some space between the icon and the text
                    Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
