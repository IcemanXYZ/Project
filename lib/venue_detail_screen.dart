import 'package:flutter/material.dart';
import 'venue.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueDetailScreen extends StatefulWidget {
  final Venue venue;

  // Use 'super' for the 'key' parameter.
  const VenueDetailScreen({super.key, required this.venue});

  @override
    VenueDetailScreenState createState() => VenueDetailScreenState();
}


class VenueDetailScreenState extends State<VenueDetailScreen> {
  // State variables for ExpansionPanel expansion
  bool _generalInfoExpanded = true;
  bool _facilitiesExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venue Details: ${widget.venue.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (index == 0) {
                    _generalInfoExpanded = !_generalInfoExpanded;
                  } else if (index == 1) {
                    _facilitiesExpanded = !_facilitiesExpanded;
                  }
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return const ListTile(
                      title: Text('General Information', style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                  body: _generalInfoPanelBody(),
                  isExpanded: _generalInfoExpanded,
                ),
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return const ListTile(
                      title: Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                  body: _facilitiesPanelBody(),
                  isExpanded: _facilitiesExpanded,
                ),
              ],
            ),
            // "Back to List" button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to List'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted Widget for General Information Panel Body
  Widget _generalInfoPanelBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Name: ${widget.venue.name}'),
          Text('Location: ${widget.venue.location}'),
          // ... Other General Information Fields
          _linkText(widget.venue.virtualTourLink), // Link for Virtual Tour
        ],
      ),
    );
  }

  // Extracted Widget for Facilities Panel Body
  Widget _facilitiesPanelBody() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ... Facilities Information Fields
        ],
      ),
    );
  }

  // Widget for displaying a clickable link
  Widget _linkText(String urlString) {
    // Convert the URL string into a Uri object
    final Uri url = Uri.parse(urlString);

    return InkWell(
      child: Text(
        urlString,
        style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
      ),
      onTap: () async {
        final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Could not launch $urlString')),
          );
        }
      },
    );
  }

}
