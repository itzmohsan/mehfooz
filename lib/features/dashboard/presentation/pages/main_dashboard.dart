import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';
import 'package:mehfooz/features/locker/presentation/pages/digital_locker_page.dart';
import 'package:mehfooz/features/permission_manager/presentation/pages/permission_manager_page.dart';
import 'package:mehfooz/features/sim_monitor/presentation/pages/sim_monitor_page.dart';
import 'package:mehfooz/features/fake_call/presentation/pages/fake_call_page.dart';
import 'package:mehfooz/features/bill_checker/presentation/pages/bill_checker_page.dart';
import 'package:mehfooz/features/data_cleaner/presentation/pages/data_cleaner_page.dart';
import 'package:mehfooz/features/advanced/presentation/pages/ai_threat_detection_page.dart';
import 'package:mehfooz/features/advanced/presentation/pages/behavioral_biometrics_page.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final int _securityScore = 65; // Increased due to advanced features

  String get _overallStatus {
    if (_securityScore >= 80) return 'Highly Secure';
    if (_securityScore >= 60) return 'Moderately Secure';
    return 'Needs Attention';
  }

  void _onFeatureTap(String feature) {
    switch (feature) {
      case 'Digital Locker':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalLockerPage()));
        break;
      case 'App Permissions':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PermissionManagerPage()));
        break;
      case 'SIM Monitor':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SimMonitorPage()));
        break;
      case 'Fake Call':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FakeCallPage()));
        break;
      case 'Bill Checker':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BillCheckerPage()));
        break;
      case 'Data Cleaner':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DataCleanerPage()));
        break;
      case 'AI Threat Detection':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AIThreatDetectionPage()));
        break;
      case 'Behavioral Biometrics':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BehavioralBiometricsPage()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feature + ' - Coming Soon!'),
            backgroundColor: AppColors.primary,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            _buildSecurityStatusCard(),
            const SizedBox(height: 24),
            _buildCoreFeaturesGrid(),
            const SizedBox(height: 24),
            _buildAdvancedFeaturesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.security_rounded, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Security Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _overallStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ' + _securityScore.toString() + '/100',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _securityScore / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.white,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreFeaturesGrid() {
    final features = [
      {
        'icon': Icons.folder_rounded,
        'title': 'Digital Locker',
        'subtitle': 'Secure your documents',
        'color': AppColors.success,
      },
      {
        'icon': Icons.apps_rounded,
        'title': 'App Permissions',
        'subtitle': 'Manage app access',
        'color': AppColors.warning,
      },
      {
        'icon': Icons.sim_card_rounded,
        'title': 'SIM Monitor',
        'subtitle': 'Protect your number',
        'color': AppColors.info,
      },
      {
        'icon': Icons.phone_rounded,
        'title': 'Fake Call',
        'subtitle': 'Emergency assistance',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.receipt_rounded,
        'title': 'Bill Checker',
        'subtitle': 'Stop overcharging',
        'color': AppColors.success,
      },
      {
        'icon': Icons.delete_rounded,
        'title': 'Data Cleaner',
        'subtitle': 'Remove your digital footprint',
        'color': AppColors.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Core Security Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _FeatureCard(
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
              subtitle: feature['subtitle'] as String,
              color: feature['color'] as Color,
              onTap: () => _onFeatureTap(feature['title'] as String),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedFeaturesGrid() {
    final advancedFeatures = [
      {
        'icon': Icons.psychology_rounded,
        'title': 'AI Threat Detection',
        'subtitle': 'Real-time AI protection',
        'color': Color(0xFF8B5CF6),
        'isNew': true,
      },
      {
        'icon': Icons.fingerprint_rounded,
        'title': 'Behavioral Biometrics',
        'subtitle': 'Continuous authentication',
        'color': Color(0xFF06D6A0),
        'isNew': true,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Text(
                'Advanced AI Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: advancedFeatures.length,
          itemBuilder: (context, index) {
            final feature = advancedFeatures[index];
            return _AdvancedFeatureCard(
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
              subtitle: feature['subtitle'] as String,
              color: feature['color'] as Color,
              isNew: feature['isNew'] as bool,
              onTap: () => _onFeatureTap(feature['title'] as String),
            );
          },
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvancedFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isNew;
  final VoidCallback onTap;

  const _AdvancedFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
              if (isNew)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
