import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';

class SimMonitorPage extends StatefulWidget {
  const SimMonitorPage({super.key});

  @override
  State<SimMonitorPage> createState() => _SimMonitorPageState();
}

class _SimMonitorPageState extends State<SimMonitorPage> {
  bool _isMonitoring = false;
  String _phoneNumber = '+92 XXX XXXXXX';
  DateTime? _lastChecked;
  bool _simSwapDetected = false;

  void _startMonitoring() {
    setState(() {
      _isMonitoring = true;
      _lastChecked = DateTime.now();
      _simSwapDetected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SIM Monitoring Started for ' + _phoneNumber),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _stopMonitoring() {
    setState(() {
      _isMonitoring = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SIM Monitoring Stopped'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _simulateSimSwap() {
    setState(() {
      _simSwapDetected = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('SIM Swap Detected!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A SIM swap was detected for your number:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            Text(
              _phoneNumber,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Time: ' + DateTime.now().toString(),
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _contactSupport();
            },
            child: Text('CONTACT SUPPORT'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _acknowledgeAlert();
            },
            child: Text('ACKNOWLEDGE'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirecting to customer support...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _acknowledgeAlert() {
    setState(() {
      _simSwapDetected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert acknowledged. Continue monitoring.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _updatePhoneNumber() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Phone Number'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _phoneNumber = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Phone number updated'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('SIM Monitor'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _simSwapDetected ? AppColors.error.withOpacity(0.1) : 
                       _isMonitoring ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                border: Border.all(
                  color: _simSwapDetected ? AppColors.error : 
                         _isMonitoring ? AppColors.success : AppColors.warning,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _simSwapDetected ? Icons.warning_amber_rounded : 
                    _isMonitoring ? Icons.security_rounded : Icons.sim_card_alert_rounded,
                    size: 50,
                    color: _simSwapDetected ? AppColors.error : 
                           _isMonitoring ? AppColors.success : AppColors.warning,
                  ),
                  SizedBox(height: 12),
                  Text(
                    _simSwapDetected ? 'SIM SWAP DETECTED!' : 
                    _isMonitoring ? 'Monitoring Active' : 'Monitoring Inactive',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _simSwapDetected ? AppColors.error : 
                             _isMonitoring ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _simSwapDetected ? 
                    'Immediate action required!' : 
                    _isMonitoring ? 
                    'Your SIM is being protected' : 
                    'Start monitoring to protect your SIM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Phone Number Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Monitored Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit_rounded, size: 20),
                          onPressed: _updatePhoneNumber,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _phoneNumber,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Last checked: ' + (_lastChecked?.toString() ?? 'Never'),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isMonitoring ? _stopMonitoring : _startMonitoring,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isMonitoring ? AppColors.warning : AppColors.success,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isMonitoring ? Icons.stop_rounded : Icons.play_arrow_rounded),
                        SizedBox(width: 8),
                        Text(_isMonitoring ? 'STOP MONITORING' : 'START MONITORING'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _simulateSimSwap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  child: Icon(Icons.warning_amber_rounded),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Information Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About SIM Swap Protection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    _InfoItem(
                      icon: Icons.security_rounded,
                      title: 'Real-time Monitoring',
                      description: 'Continuously monitors for SIM replacement requests',
                    ),
                    _InfoItem(
                      icon: Icons.notifications_active_rounded,
                      title: 'Instant Alerts',
                      description: 'Get immediate notifications if SIM swap is detected',
                    ),
                    _InfoItem(
                      icon: Icons.support_agent_rounded,
                      title: 'Quick Action',
                      description: 'Direct contact with support when fraud is detected',
                    ),
                    _InfoItem(
                      icon: Icons.phone_locked_rounded,
                      title: 'Bank Protection',
                      description: 'Prevent unauthorized access to your bank accounts',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
