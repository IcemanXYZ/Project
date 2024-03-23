import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor.dart'; // Import the Vendor class

class VendorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createVendor(
      String userId,
      String businessName,
      String certifications,
      ) async {
    try {
      DocumentReference vendorRef = _firestore.collection('vendors').doc(userId);

      await vendorRef.set({
        'businessName': businessName,
        'certifications': certifications,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating vendor: $e');
      rethrow;
    }
  }

  Future<void> addMenuItem(
      String userId,
      String itemName,
      String itemDescription,
      double itemPrice,
      ) async {
    try {
      CollectionReference menuOfferingsCollection =
      _firestore.collection('vendors').doc(userId).collection('MenuOfferings');

      await menuOfferingsCollection.add({
        'itemName': itemName,
        'itemDescription': itemDescription,
        'itemPrice': itemPrice,
      });
    } catch (e) {
      print('Error adding menu item: $e');
      rethrow;
    }
  }


  Future<Vendor?> getVendor(String userId) async {
    try {
      DocumentSnapshot vendorSnapshot = await _firestore.collection('vendors').doc(userId).get();

      if (vendorSnapshot.exists) {
        Map<String, dynamic> data = vendorSnapshot.data() as Map<String, dynamic>;

        // Create Vendor without menuItems
        return Vendor(
          id: userId,
          businessName: data['businessName'],
          certifications: data['certifications'],
          status: data['status'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          // No need to explicitly pass menuItems since we have a default value.
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving vendor: $e');
      rethrow;
    }
  }


  Future<void> deleteVendor(String userId) async {
    try {
      await _firestore.collection('vendors').doc(userId).delete();
    } catch (e) {
      print('Error deleting vendor: $e');
      rethrow;
    }
  }

  Future<void> editVendor(
      String userId,
      String businessName,
      String certifications,
      String status,
      ) async {
    try {
      DocumentReference vendorRef =
      _firestore.collection('vendors').doc(userId);

      await vendorRef.update({
        'businessName': businessName,
        'certifications': certifications,
        'status': status,
      });
    } catch (e) {
      print('Error editing vendor: $e');
      rethrow;
    }
  }

  Future<void> submitVendorUpgradeRequest(
      String userId, String businessName, String certifications) async {
    try {
      await _firestore.collection('vendorUpgradeRequests').add({
        'userId': userId,
        'businessName': businessName,
        'certifications': certifications,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error submitting vendor upgrade request: $e');
      rethrow;
    }
  }

  Future<void> submitUpgradeRequest({
    required String userId,
    required String businessName,
    required String certifications,
  }) async {
    try {
      await _firestore.collection('upgradeRequests').add({
        'userId': userId,
        'businessName': businessName,
        'certifications': certifications,
        'status': 'Pending', // Initial status for admin review
        'createdAt': FieldValue.serverTimestamp(), // Timestamp of the request submission
      });
    } catch (e) {
      print('Error submitting upgrade request: $e');
      rethrow;
    }
  }

}




