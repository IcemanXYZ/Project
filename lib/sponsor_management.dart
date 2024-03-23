import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sponsor_service.dart';
import 'sponsor_addition.dart';
import 'sponsor.dart';

class SponsorManagement extends StatefulWidget {
  const SponsorManagement({super.key}); // Corrected for Dart 2.12+ syntax

  @override
  State<SponsorManagement> createState() => _SponsorManagementState();
}

class _SponsorManagementState extends State<SponsorManagement> {
  final TextEditingController _filterController = TextEditingController();
  String _searchText = "";

  _SponsorManagementState() {
    _filterController.addListener(() {
      setState(() {
        _searchText = _filterController.text;
      });
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Sponsors'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filterController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (_searchText != "")
                  ? FirebaseFirestore.instance
                  .collection('sponsors')
                  .where('name', isGreaterThanOrEqualTo: _searchText)
                  .snapshots()
                  : FirebaseFirestore.instance.collection('sponsors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    Map<String, dynamic> sponsorData = doc.data() as Map<String, dynamic>;
                    Sponsor sponsor = Sponsor.fromMap(sponsorData, doc.id);
                    return ListTile(
                      title: Text(sponsor.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SponsorAddition(sponsor: sponsor, mode: 'view'),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SponsorAddition(sponsor: sponsor, mode: 'edit'),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDeletion(context, doc.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SponsorAddition(mode: 'add')),
        ),
        label: const Text('Add New Sponsor'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmDeletion(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this sponsor?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog first to avoid using context across async gap
                bool result = await SponsorService().deleteSponsor(docId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result ? 'Sponsor deleted successfully.' : 'Error deleting sponsor.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}


