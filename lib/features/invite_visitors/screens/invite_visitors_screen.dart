import 'package:flutter/material.dart';

class InviteVisitorsScreen extends StatefulWidget {
  const InviteVisitorsScreen({super.key});

  @override
  State<InviteVisitorsScreen> createState() => _InviteVisitorsScreenState();
}

class _InviteVisitorsScreenState extends State<InviteVisitorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildVisitorOption(
              icon: Icons.person,
              title: 'Guest',
              subtitle: 'Pre-approve expected guest entry',
              onTap: () {
                // Handle Guest click
                Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'guest', 'image': 'assets/images/guest/single_guest.png'});
              },
            ),
            const SizedBox(height: 20),
            buildVisitorOption(
              icon: Icons.delivery_dining,
              title: 'Delivery',
              subtitle: 'Pre-approve expected delivery entry',
              onTap: () {
                Navigator.pushNamed(context, '/delivery-company-screen');
              },
            ),
            const SizedBox(height: 20),
            buildVisitorOption(
              icon: Icons.local_taxi,
              title: 'Cab',
              subtitle: 'Pre-approve expected cab entry',
              onTap: () {
                Navigator.pushNamed(context, '/cab-company-screen');
              },
            ),
            const SizedBox(height: 20),
            buildVisitorOption(
              icon: Icons.build,
              title: 'Other',
              subtitle: 'Pre-approve expected services entry',
              onTap: () {
                Navigator.pushNamed(context, '/other-services-screen');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVisitorOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
