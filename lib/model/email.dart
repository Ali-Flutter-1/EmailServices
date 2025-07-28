class Email {
  final String id;
  final String from;
  final String subject;
  final String body;
  final DateTime date;

  Email({
    required this.id,
    required this.from,
    required this.subject,
    required this.body,
    required this.date,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: json['id'] ?? '',
      from: json['from']?['address'] ?? json['from'] ?? '', // Handle nested structure
      subject: json['subject'] ?? '',
      body: json['intro'] ?? json['text'] ?? '', // Try both fields
      date: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'fromEmail': from,
    'subject': subject,
    'intro': body,
    'date': date.toIso8601String(),
  };

  factory Email.fromMap(Map<String, dynamic> map) {
    return Email(
      id: map['id'] ?? '',
      from: map['fromEmail'] ?? '',
      subject: map['subject'] ?? '',
      body: map['intro'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}