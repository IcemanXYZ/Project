class EventManagerHomepage extends StatefulWidget {
  @override
  _EventManagerHomepageState createState() => _EventManagerHomepageState();
}

class _EventManagerHomepageState extends State<EventManagerHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Manager Dashboard'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            leading: Icon(Icons.location_city),
            title: Text('Venue Profile Management'),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add_location),
                title: Text('Add Venue'),
                onTap: () {
                  /* Navigate to Add Venue Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.edit_location),
                title: Text('Amend Venue'),
                onTap: () {
                  /* Navigate to Amend Venue Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete Venue'),
                onTap: () {
                  /* Navigate to Delete Venue Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Venues List'),
                onTap: () {
                  /* Navigate to Venue List Screen */
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Booking and Reservation Management'),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.pending_actions),
                title: Text('Pending Bookings and Reservations List'),
                onTap: () {
                  /* Navigate to Pending Bookings Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.list_alt),
                title: Text('Bookings & Reservations List'),
                onTap: () {
                  /* Navigate to Bookings & Reservations List Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.rule),
                title: Text('Set Booking Rules'),
                onTap: () {
                  /* Navigate to Set Booking Rules Screen */
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.settings_input_component),
            title: Text('Resource Allocation and Management'),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.category),
                title: Text('Manage Resources'),
                onTap: () {
                  /* Navigate to Manage Resources Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.sync_alt),
                title: Text('Coordinate with Service Providers'),
                onTap: () {
                  /* Navigate to Service Providers Screen */
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.attach_money),
            title: Text('Pricing and Financial Functions'),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.price_change),
                title: Text('Set Pricing'),
                onTap: () {
                  /* Navigate to Set Pricing Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('Process Payments'),
                onTap: () {
                  /* Navigate to Process Payments Screen */
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Manage Financial Records'),
                onTap: () {
                  /* Navigate to Financial Records Screen /},
),
],
),
ExpansionTile(
leading: Icon(Icons.support_agent),
title: Text('Customer Service and Communication'),
children: <Widget>[
ListTile(
leading: Icon(Icons.info_outline),
title: Text('Provide Information and Support'),
onTap: () {/ Navigate to Support Screen /},
),
ListTile(
leading: Icon(Icons.comment),
title: Text('Resolve Queries and Complaints'),
onTap: () {/ Navigate to Queries and Complaints Screen /},
),
ListTile(
leading: Icon(Icons.policy),
title: Text('Communicate Policies and Guidelines'),
onTap: () {/ Navigate to Policies and Guidelines Screen /},
),
],
),
ExpansionTile(
leading: Icon(Icons.analytics),
title: Text('Reporting and Analytics'),
children: <Widget>[
ListTile(
leading: Icon(Icons.report),
title: Text('Generate Reports'),
onTap: () {/ Navigate to Generate Reports Screen /},
),
ListTile(
leading: Icon(Icons.trending_up),
title: Text('Analyze Data'),
onTap: () {/ Navigate to Data Analysis Screen */
                },
              ),
            ],
          ),
// ... Add more main options or expansion tiles as needed
        ],
      ),
    );
  }
}
