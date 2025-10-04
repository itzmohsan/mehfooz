class AppConfig {
  static const String appName = 'Mehfooz';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // Security Settings
  static const int maxPinAttempts = 5;
  static const int autoLockDuration = 300; // 5 minutes in seconds
  static const bool enableBiometrics = true;
  
  // Storage Settings
  static const int maxDocumentSize = 50 * 1024 * 1024; // 50MB
  static const List<String> allowedFileTypes = ['jpg', 'jpeg', 'png', 'pdf', 'txt'];
  
  // API Endpoints (would be actual endpoints in production)
  static const String baseUrl = 'https://api.mehfooz.app';
  static const String privacyPolicyUrl = 'https://mehfooz.app/privacy';
  static const String termsOfServiceUrl = 'https://mehfooz.app/terms';
}

class AppPreferences {
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String biometricsEnabled = 'biometrics_enabled';
  static const String autoLockEnabled = 'auto_lock_enabled';
  static const String simMonitoringEnabled = 'sim_monitoring_enabled';
  static const String threatDetectionEnabled = 'threat_detection_enabled';
}
