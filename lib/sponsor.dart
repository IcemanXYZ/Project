class Sponsor {
  final String id;
  final String personEntity; // "Person" or "Entity"
  final String? salutation;
  final String? firstName;
  final String? lastName;
  final String? entityName; // Added for entity sponsors
  final String logoUrl;
  final String website;
  final String contactInfo;
  final String category;
  final double sponsorshipAmount;
  final String contributionType;
  final List<String> eventParticipation;
  final DateTime agreementDate;
  final DateTime? renewalDate;
  final String? notes;
  final String status;

  Sponsor({
    required this.id,
    required this.personEntity,
    this.salutation,
    this.firstName,
    this.lastName,
    this.entityName,
    required this.logoUrl,
    required this.website,
    required this.contactInfo,
    required this.category,
    required this.sponsorshipAmount,
    required this.contributionType,
    required this.eventParticipation,
    required this.agreementDate,
    this.renewalDate,
    this.notes,
    required this.status,
  });

  Sponsor.empty()
      : id = '',
        personEntity = 'Entity',
        salutation = null,
        firstName = null,
        lastName = null,
        entityName = '',
        logoUrl = '',
        website = '',
        contactInfo = '',
        category = 'Unknown',
        sponsorshipAmount = 0.0,
        contributionType = 'Unknown',
        eventParticipation = [],
        agreementDate = DateTime.now(),
        renewalDate = null,
        notes = null,
        status = 'Active';

  // Added for convenience, to get the sponsor's name depending on type
  String get name => personEntity == "Entity" ? (entityName ?? "N/A") : ("${firstName ?? ""} ${lastName ?? ""}").trim();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personEntity': personEntity,
      'salutation': salutation,
      'firstName': firstName,
      'lastName': lastName,
      'entityName': entityName,
      'logoUrl': logoUrl,
      'website': website,
      'contactInfo': contactInfo,
      'category': category,
      'sponsorshipAmount': sponsorshipAmount,
      'contributionType': contributionType,
      'eventParticipation': eventParticipation,
      'agreementDate': agreementDate.millisecondsSinceEpoch,
      'renewalDate': renewalDate?.millisecondsSinceEpoch,
      'notes': notes,
      'status': status,
    };
  }

  static Sponsor fromMap(Map<String, dynamic> map, String documentId) {
    return Sponsor(
      id: documentId,
      personEntity: map['personEntity'] ?? "Entity",
      salutation: map['salutation'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      entityName: map['entityName'],
      logoUrl: map['logoUrl'] ?? "",
      website: map['website'] ?? "",
      contactInfo: map['contactInfo'] ?? "",
      category: map['category'] ?? "Unknown",
      sponsorshipAmount: (map['sponsorshipAmount']?.toDouble() ?? 0.0),
      contributionType: map['contributionType'] ?? "Unknown",
      eventParticipation: List<String>.from(map['eventParticipation'] ?? []),
      agreementDate: map['agreementDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['agreementDate']) : DateTime.now(),
      renewalDate: map['renewalDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['renewalDate']) : null,
      notes: map['notes'],
      status: map['status'] ?? "Active",
    );
  }
}
