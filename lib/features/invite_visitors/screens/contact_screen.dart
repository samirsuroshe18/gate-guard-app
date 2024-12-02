import 'package:flutter/material.dart';
import 'package:gate_guard/features/invite_visitors/screens/manual_contacts.dart';
import 'package:gate_guard/features/invite_visitors/screens/mobile_contacts.dart';

class ContactsScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const ContactsScreen({super.key, this.data});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  String? selectedName;
  String? selectedNumber;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if(widget.data?['profileType'] == 'delivery' || widget.data?['profileType'] == 'cab' || widget.data?['profileType'] == 'other'){
      _tabController.index = 1;
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  void onContactSelected(String name, String number) {
    setState(() {
      selectedName = name;
      selectedNumber = number;
      _tabController.index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                tabs: const [
                  Tab(text: 'Contacts'),
                  Tab(text: 'Add Manually'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MobileContacts(onContactSelected: onContactSelected),
                    ManualContacts(name: selectedName, number: selectedNumber, data: widget.data,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}