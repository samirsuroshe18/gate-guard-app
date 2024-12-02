import 'package:flutter/material.dart';

import '../widgets/dashboard_card.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DashboardCard(
            icon: Icons.person_add,
            title: 'Resident Request',
            badgeCount: 0,
            onDashboard: () {
              Navigator.pushNamed(context, '/resident-approval');
            },
          ),
          const SizedBox(height: 16.0),
          DashboardCard(
            icon: Icons.security,
            title: 'Guard Request',
            badgeCount: 0,
            onDashboard: () {
              Navigator.pushNamed(context, '/guard-approval');
            },
          ),
          const SizedBox(height: 16.0),
          // Additional fields can be added here
          DashboardCard(
            icon: Icons.people,
            title: 'Manage Residents',
            onDashboard: () {
              // Handle Manage Residents click
            },
          ),
          const SizedBox(height: 16.0),
          DashboardCard(
            icon: Icons.security,
            title: 'Manage Guards',
            onDashboard: () {
              // Handle Admin Settings click
            },
          ),
        ],
      ),
    );
  }
}
