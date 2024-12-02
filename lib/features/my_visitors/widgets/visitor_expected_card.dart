import 'package:flutter/material.dart';
import 'package:gate_guard/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorExpectedCard extends StatelessWidget {
  final PreApprovedBanner data;
  final String profileImageUrl;
  final String userName;
  final String date;
  final String? companyName;
  final String? companyLogo;
  final String? serviceName;
  final String? serviceLogo;
  final String tag;
  final Color tagColor;

  const VisitorExpectedCard({
    required this.profileImageUrl,
    required this.userName,
    this.companyName,
    this.companyLogo,
    this.serviceName,
    this.serviceLogo,
    required this.date,
    required this.tag,
    required this.tagColor,
    required this.data,
    super.key,
  });

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
                  backgroundImage: AssetImage(profileImageUrl),
                  child: GestureDetector(
                    onTap: () {
                      _showImageDialog(profileImageUrl, context); // Open dialog on tap
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // User details and tag
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // User name and tag container
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis, // Prevent overflow
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
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
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      if (serviceName != null || companyName != null)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: serviceLogo != null
                                    ? AssetImage(serviceLogo!)
                                    : AssetImage(companyLogo!),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  serviceName != null ? serviceName! : companyName!,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis, // Prevent overflow
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            // Button section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/otp-banner', arguments: data);
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text(
                      "Share Code",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _makePhoneCall,
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text(
                      "Call",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
