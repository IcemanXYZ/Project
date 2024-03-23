import 'package:cloud_firestore/cloud_firestore.dart';

class UpgradeRequest {
  final String id;
  final String userId;
  final String currentRole;
  final String desiredRole;
  final String reasonForUpgrade;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic> additionalInfo;
  final String reviewNotes; // New field for review notes
  final String firstName; // Added firstName property
  final String lastName; // Added lastName property

  UpgradeRequest({
    this.id = '',
    required this.userId,
    required this.currentRole,
    required this.desiredRole,
    required this.reasonForUpgrade,
    this.status = 'Pending',
    required this.createdAt,
    this.additionalInfo = const {},
    this.reviewNotes = '', // Default value for review notes
    required this.firstName, // Initialize firstName property
    required this.lastName, // Initialize lastName property
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'currentRole': currentRole,
      'desiredRole': desiredRole,
      'reasonForUpgrade': reasonForUpgrade,
      'status': status,
      'createdAt': createdAt,
      'additionalInfo': additionalInfo,
      'reviewNotes': reviewNotes, // Include review notes in map
      'firstName': firstName, // Include firstName in map
      'lastName': lastName, // Include lastName in map
    };
  }

  factory UpgradeRequest.fromMap(Map<String, dynamic> map, String documentId) {
    return UpgradeRequest(
      id: documentId,
      userId: map['userId'] ?? '',
      currentRole: map['currentRole'] ?? '',
      desiredRole: map['desiredRole'] ?? '',
      reasonForUpgrade: map['reasonForUpgrade'] ?? '',
      status: map['status'] ?? 'Pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      additionalInfo: map['additionalInfo'] != null ? Map<String, dynamic>.from(map['additionalInfo']) : {},
      reviewNotes: map['reviewNotes'] ?? '', // Fetch review notes from map
      firstName: map['firstName'] ?? '', // Initialize firstName from map
      lastName: map['lastName'] ?? '', // Initialize lastName from map
    );
  }

  @override
  String toString() => 'UpgradeRequest(id: $id, userId: $userId, currentRole: $currentRole, desiredRole: $desiredRole, status: $status, createdAt: $createdAt, reviewNotes: $reviewNotes, firstName: $firstName, lastName: $lastName)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpgradeRequest && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
