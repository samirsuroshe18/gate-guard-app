import 'package:flutter/material.dart';

class VerificationRequestCard extends StatelessWidget {
  final String profileImageUrl;
  final String userName;
  final String date;
  final String role;
  final Color tagColor;
  final String societyName;
  final String? blockName;
  final String? apartment;
  final String? gateAssign;
  final bool isLoadingApprove;
  final bool isLoadingReject;
  final String time;
  final VoidCallback onApprove;
  final VoidCallback onCall;
  final VoidCallback onReject;

  const VerificationRequestCard({
    super.key,
    required this.profileImageUrl,
    required this.userName,
    required this.date,
    required this.role,
    required this.tagColor,
    required this.societyName,
    this.blockName,
    this.apartment,
    this.gateAssign,
    required this.isLoadingApprove,
    required this.isLoadingReject,
    required this.time,
    required this.onApprove,
    required this.onCall,
    required this.onReject,
  });

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
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : const AssetImage('assets/images/profile.png')
                          as ImageProvider,
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
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Tag with background color and bold text
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              role,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.blue),
                              const SizedBox(
                                  width:
                                      5), // Add some spacing between the icon and the text
                              Text(date),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0), // Add padding to the right
                            child: Row(
                              children: [
                                const Icon(
                                    Icons
                                        .access_time, // You can choose another icon here
                                    size: 16,
                                    color:
                                        Colors.blue // Adjust the size if needed
                                    ),
                                const SizedBox(
                                    width:
                                        5), // Add spacing between the icon and the text
                                Text(time),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_city,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 8.0),
                          Text(societyName),
                        ],
                      ),
                      // SizedBox(height: 8),
                      if (blockName != null)
                        Row(
                          children: [
                            const Icon(Icons.apartment,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 8.0),
                            Text(blockName ?? ''),
                          ],
                        ),
                      // SizedBox(height: 8),
                      if (apartment != null)
                        Row(
                          children: [
                            const Icon(Icons.home,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 8.0),
                            Text(apartment ?? ''),
                          ],
                        ),
                      if (gateAssign != null)
                        Row(
                          children: [
                            const Icon(Icons.door_sliding_outlined,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 8.0),
                            Text(gateAssign ?? ''),
                          ],
                        ),
                      // SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: 16),
            const Divider(),
            // Button section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: isLoadingApprove
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Approve", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.call, color: Colors.white),
                  label:
                  const Text("Call", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: isLoadingReject
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Reject", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
