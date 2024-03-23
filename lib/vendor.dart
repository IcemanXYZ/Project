class Vendor {
  final String id;
  final String businessName;
  final String certifications;
  final String status;
  final DateTime createdAt;
  final List<MenuItem> menuItems; // Keep as a list to store menu items.

  Vendor({
    required this.id,
    required this.businessName,
    required this.certifications,
    required this.status,
    required this.createdAt,
    this.menuItems = const [], // Provide a default empty list.
  });
}

class MenuItem {
  final String itemName;
  final String itemDescription;
  final double itemPrice;

  MenuItem({
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
  });
}
