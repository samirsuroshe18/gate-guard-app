import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileContacts extends StatefulWidget {
  final Function(String, String) onContactSelected;
  const MobileContacts({super.key, required this.onContactSelected});

  @override
  State<MobileContacts> createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts>
    with AutomaticKeepAliveClientMixin {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      Iterable<Contact> fetchedContacts =
          await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        contacts = fetchedContacts.toList();
        filteredContacts = contacts; // Initialize with all contacts
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Contact permission denied!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void filterContacts(String query) {
    final filtered = contacts.where((contact) {
      final nameLower = contact.displayName?.toLowerCase() ?? '';
      final phoneLower = contact.phones?.isNotEmpty ?? false
          ? contact.phones!.first.value?.toLowerCase() ?? ''
          : '';
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredContacts = filtered;
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (query) => filterContacts(query),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search by name or mobile number',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  return ListTile(
                    onTap: () {
                      String name = contact.displayName ?? '';
                      String number = contact.phones?.isNotEmpty ?? false
                          ? contact.phones!.first.value ?? ''
                          : '';
                      widget.onContactSelected(name, number);
                      // DefaultTabController.of(context).animateTo(1);
                    },
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(contact.displayName ?? 'No name'),
                    subtitle: Text(contact.phones?.isNotEmpty ?? false
                        ? contact.phones!.first.value ?? 'No phone number'
                        : 'No phone number'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
