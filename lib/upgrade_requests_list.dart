import 'package:flutter/material.dart';
import 'upgrade_request.dart';
import 'upgrade_request_service.dart';
import 'upgrade_request_update.dart';

class UpgradeRequestsList extends StatefulWidget {
  final String currentUserRole;
  final UpgradeRequestService upgradeRequestService;

  const UpgradeRequestsList({
    super.key,
    required this.currentUserRole,
    required this.upgradeRequestService,
  });

  @override
  State<UpgradeRequestsList> createState() => _UpgradeRequestsListState();
}

class _UpgradeRequestsListState extends State<UpgradeRequestsList> {
  late Stream<List<UpgradeRequest>> requestsStream;

  @override
  void initState() {
    super.initState();
    requestsStream = widget.currentUserRole == "System Administrator"
        ? widget.upgradeRequestService.fetchUpgradeRequestsForSysAdmin()
        : widget.upgradeRequestService.fetchUpgradeRequestsForFacultyAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Upgrade Requests'),
      ),
      body: StreamBuilder<List<UpgradeRequest>>(
        stream: requestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error fetching upgrade requests: ${snapshot.error}');
            return Text('Error fetching upgrade requests: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No upgrade requests data available.');
            return const Center(child: Text("No pending upgrade requests."));
          }

          print('Upgrade requests data received: ${snapshot.data}');
          List<UpgradeRequest> requests = snapshot.data!;
          print('Number of upgrade requests: ${requests.length}');

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              UpgradeRequest request = requests[index];
              return ListTile(
                title: Text('${request.firstName} ${request.lastName}'),
                subtitle: Text('Current Role: ${request.currentRole}, Desired Role: ${request.desiredRole}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => UpgradeRequestUpdate(userId: request.userId, request: request)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _handleEditRequest(request),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleEditRequest(UpgradeRequest request) async {
    print('Editing upgrade request: $request');
    String status = 'Approved'; // Example status
    String reviewNotes = ''; // Initialize reviewNotes

    // Perform different actions based on the status
    switch (status) {
      case 'Approved':
      // Fetch user details
        Map<String, dynamic>? userDetails = await widget.upgradeRequestService.fetchUserDetails(request.userId);

        if (userDetails != null) {
          // Get the previous role and desired role from the user details
          String? previousRole = userDetails['previousRole'];
          String? desiredRole = userDetails['desiredRole'];

          if (previousRole != null && desiredRole != null) {
            try {
              // Update the user's current role to the previous role
              await widget.upgradeRequestService.updateUserRole(request.userId, previousRole);

              // Update the desired role in the user's document
              await widget.upgradeRequestService.updateDesiredRole(request.userId, desiredRole);

              // Update the upgrade request status to Approved
              await widget.upgradeRequestService.reviewUpgradeRequest(request.id, status);
            } catch (error) {
              print('Error handling approved request: $error');
            }
          } else {
            print('Previous role or desired role not found for the user.');
          }
        } else {
          print('User details not found.');
        }
        break;

      case 'Rejected':
      // Ensure reviewNotes are provided
        if (reviewNotes.isEmpty) {
          print('Review notes are required for Rejected status.');
          return;
        }

        // Update the upgrade request status to Rejected
        await widget.upgradeRequestService.reviewUpgradeRequest(request.id, status, reviewNotes: reviewNotes);
        break;

      case 'RequireMoreInfo':
      // Ensure reviewNotes are provided
        if (reviewNotes.isEmpty) {
          print('Review notes are required for RequireMoreInfo status.');
          return;
        }

        // Update the upgrade request status to RequireMoreInfo
        await widget.upgradeRequestService.reviewUpgradeRequest(request.id, status, reviewNotes: reviewNotes);
        break;

      default:
        print('Invalid status');
        break;
    }
  }
}
