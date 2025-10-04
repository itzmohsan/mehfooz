class AppInfo {
  final String name;
  final String packageName;
  final String version;
  final Map<String, bool> permissions;
  final int riskLevel;

  const AppInfo({
    required this.name,
    required this.packageName,
    required this.version,
    required this.permissions,
    required this.riskLevel,
  });

  String get riskDescription {
    if (riskLevel >= 8) return 'High Risk';
    if (riskLevel >= 5) return 'Medium Risk';
    return 'Low Risk';
  }
}
