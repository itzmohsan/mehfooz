import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';
import 'package:mehfooz/models/app_info.dart';

class PermissionManagerPage extends StatefulWidget {
  const PermissionManagerPage({super.key});

  @override
  State<PermissionManagerPage> createState() => _PermissionManagerPageState();
}

class _PermissionManagerPageState extends State<PermissionManagerPage> {
  List<AppInfo> _apps = [
    AppInfo(
      name: 'Easypaisa',
      packageName: 'com.telenor.easypaisa',
      version: '5.12.0',
      permissions: {
        'SMS': true,
        'Contacts': true,
        'Storage': true,
        'Camera': true,
        'Location': false,
      },
      riskLevel: 7,
    ),
    AppInfo(
      name: 'JazzCash',
      packageName: 'com.genyte.jazzcash',
      version: '4.5.1',
      permissions: {
        'SMS': true,
        'Contacts': true,
        'Storage': true,
        'Camera': true,
        'Location': true,
      },
      riskLevel: 8,
    ),
    AppInfo(
      name: 'WhatsApp',
      packageName: 'com.whatsapp',
      version: '2.23.21',
      permissions: {
        'SMS': false,
        'Contacts': true,
        'Storage': true,
        'Camera': true,
        'Location': true,
      },
      riskLevel: 6,
    ),
    AppInfo(
      name: 'Facebook',
      packageName: 'com.facebook.katana',
      version: '412.0.0',
      permissions: {
        'SMS': false,
        'Contacts': true,
        'Storage': true,
        'Camera': true,
        'Location': true,
      },
      riskLevel: 9,
    ),
  ];

  Color _getRiskColor(int riskLevel) {
    if (riskLevel >= 8) return Color(0xFFEF4444);
    if (riskLevel >= 5) return Color(0xFFF59E0B);
    return Color(0xFF10B981);
  }

  void _togglePermission(String appName, String permission) {
    setState(() {
      final appIndex = _apps.indexWhere((app) => app.name == appName);
      if (appIndex != -1) {
        final currentValue = _apps[appIndex].permissions[permission] ?? false;
        _apps[appIndex].permissions[permission] = !currentValue;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(permission + ' permission updated for ' + appName),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _scanApps() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scanning Apps'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing app permissions...'),
            SizedBox(height: 16),
            Text(
              'Found ' + _apps.length.toString() + ' apps with risky permissions',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE'),
          ),
        ],
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Security scan completed!'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('App Permissions'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.security_rounded),
            onPressed: _scanApps,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 40),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Alert',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _apps.where((app) => app.riskLevel >= 7).length.toString() + ' high-risk apps detected',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _scanApps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('SCAN'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _apps.length,
              itemBuilder: (context, index) {
                final app = _apps[index];
                return _AppPermissionCard(
                  app: app,
                  riskColor: _getRiskColor(app.riskLevel),
                  onPermissionToggle: _togglePermission,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppPermissionCard extends StatelessWidget {
  final AppInfo app;
  final Color riskColor;
  final Function(String, String) onPermissionToggle;

  const _AppPermissionCard({
    required this.app,
    required this.riskColor,
    required this.onPermissionToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.apps_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        app.packageName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    app.riskDescription,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: riskColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Permissions:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            ...app.permissions.entries.map((entry) {
              final permission = entry.key;
              final isGranted = entry.value;
              
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isGranted ? Icons.check_circle_rounded : Icons.remove_circle_rounded,
                  color: isGranted ? AppColors.success : AppColors.error,
                  size: 20,
                ),
                title: Text(
                  permission,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Switch(
                  value: isGranted,
                  onChanged: (value) => onPermissionToggle(app.name, permission),
                  activeColor: AppColors.primary,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
