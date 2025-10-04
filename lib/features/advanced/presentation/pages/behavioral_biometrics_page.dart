import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';

class BehavioralBiometricsPage extends StatefulWidget {
  const BehavioralBiometricsPage({super.key});

  @override
  State<BehavioralBiometricsPage> createState() => _BehavioralBiometricsPageState();
}

class _BehavioralBiometricsPageState extends State<BehavioralBiometricsPage> {
  bool _isTraining = false;
  double _typingPatternAccuracy = 0.0;
  double _touchPatternAccuracy = 0.0;
  double _movementPatternAccuracy = 0.0;
  int _trainingProgress = 0;
  bool _isBiometricsActive = false;

  void _startTraining() {
    setState(() {
      _isTraining = true;
      _trainingProgress = 0;
    });

    _simulateTrainingProcess();
  }

  void _simulateTrainingProcess() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_trainingProgress < 100) {
        setState(() {
          _trainingProgress += 2;
          
          // Update pattern accuracies during training
          if (_trainingProgress <= 33) {
            _typingPatternAccuracy = _trainingProgress / 33;
          } else if (_trainingProgress <= 66) {
            _touchPatternAccuracy = (_trainingProgress - 33) / 33;
          } else {
            _movementPatternAccuracy = (_trainingProgress - 66) / 34;
          }
        });
        _simulateTrainingProcess();
      } else {
        setState(() {
          _isTraining = false;
          _isBiometricsActive = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Behavioral Biometrics Training Complete!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _toggleBiometrics() {
    setState(() {
      _isBiometricsActive = !_isBiometricsActive;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Behavioral Biometrics ' + (_isBiometricsActive ? 'Activated' : 'Deactivated')),
        backgroundColor: _isBiometricsActive ? AppColors.success : AppColors.warning,
      ),
    );
  }

  void _simulateIntrusion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Suspicious Behavior Detected!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Behavioral patterns do not match the device owner.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.fingerprint_rounded, color: AppColors.error),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Typing rhythm mismatch: 87%',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app_rounded, color: AppColors.warning),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Touch pressure abnormal',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('DISMISS'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _lockDevice();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('LOCK DEVICE'),
          ),
        ],
      ),
    );
  }

  void _lockDevice() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Device Secured'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded, size: 60, color: AppColors.success),
            SizedBox(height: 16),
            Text(
              'Device locked due to suspicious behavior.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            Text(
              'Sensitive apps have been secured.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternIndicator(String title, double accuracy, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  (accuracy * 100).toStringAsFixed(0) + '%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: accuracy > 0.8 ? AppColors.success : 
                           accuracy > 0.5 ? AppColors.warning : AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: accuracy,
              backgroundColor: AppColors.border,
              color: accuracy > 0.8 ? AppColors.success : 
                     accuracy > 0.5 ? AppColors.warning : AppColors.error,
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Behavioral Biometrics'),
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
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isBiometricsActive ? 
                  AppColors.success.withOpacity(0.1) : 
                  AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                border: Border.all(
                  color: _isBiometricsActive ? AppColors.success : AppColors.warning,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.fingerprint_rounded,
                    size: 60,
                    color: _isBiometricsActive ? AppColors.success : AppColors.warning,
                  ),
                  SizedBox(height: 12),
                  Text(
                    _isBiometricsActive ? 
                      'Behavioral Protection Active' : 
                      'Behavioral Protection Inactive',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _isBiometricsActive ? 
                      'Continuous authentication active' : 
                      'Train system to enable protection',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 16),
                  if (!_isBiometricsActive && !_isTraining)
                    ElevatedButton(
                      onPressed: _startTraining,
                      child: Text('START TRAINING'),
                    ),
                  if (_isTraining) ...[
                    LinearProgressIndicator(
                      value: _trainingProgress / 100,
                      backgroundColor: AppColors.border,
                      color: AppColors.primary,
                      minHeight: 8,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Training: %',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                  if (_isBiometricsActive)
                    Switch(
                      value: _isBiometricsActive,
                      onChanged: (value) => _toggleBiometrics(),
                    ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Pattern Indicators
            _buildPatternIndicator(
              'Typing Rhythm',
              _typingPatternAccuracy,
              Icons.keyboard_rounded,
            ),
            SizedBox(height: 12),
            _buildPatternIndicator(
              'Touch Patterns',
              _touchPatternAccuracy,
              Icons.touch_app_rounded,
            ),
            SizedBox(height: 12),
            _buildPatternIndicator(
              'Movement Patterns',
              _movementPatternAccuracy,
              Icons.phone_iphone_rounded,
            ),

            SizedBox(height: 24),

            // Test Section
            if (_isBiometricsActive) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Test',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Simulate an intrusion attempt to test the behavioral biometrics system.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _simulateIntrusion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('SIMULATE INTRUSION'),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: 24),

            // Information
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How It Works',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    _InfoItem(
                      icon: Icons.schedule_rounded,
                      text: 'Learns your unique typing speed and rhythm',
                    ),
                    _InfoItem(
                      icon: Icons.gesture_rounded,
                      text: 'Analyzes touch pressure and swipe patterns',
                    ),
                    _InfoItem(
                      icon: Icons.phone_iphone_rounded,
                      text: 'Monitors how you hold and move your device',
                    ),
                    _InfoItem(
                      icon: Icons.security_rounded,
                      text: 'Locks device when behavior doesn\'t match',
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
  final String text;

  const _InfoItem({
    required this.icon,
    required this.text,
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
            child: Text(
              text,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
