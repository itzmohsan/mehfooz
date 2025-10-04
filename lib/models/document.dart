class Document {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;
  final String filePath;
  final bool isEncrypted;

  const Document({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.filePath,
    this.isEncrypted = true,
  });

  String get fileSize {
    return '2.4 MB';
  }

  String get formattedDate {
    return '//';
  }
}
