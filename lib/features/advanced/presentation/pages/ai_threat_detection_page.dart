import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';

class AIThreatDetectionPage extends StatefulWidget {
  const AIThreatDetectionPage({super.key});

  @override
  State<AIThreatDetectionPage> createState() => _AIThreatDetectionPageState();
}

class _AIThreatDetectionPageState extends State<AIThreatDetectionPage> {
  bool _isMonitoring = false;
  List<Map<String, dynamic>> _threats = [];
  int _threatsBlocked = 0;
  Timer? _threatSimulator;

  void _startAIMonitoring() {
    setState(() {
      _isMonitoring = true;
      _threats = [];
      _threatsBlocked = 0;
    });

    _threatSimulator = Timer.periodic(Duration(seconds: 3), (timer) {
      _simulateThreatDetection();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI Threat Detection Activated'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _stopAIMonitoring() {
    _threatSimulator?.cancel();
    setState(() {
      _isMonitoring = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI Monitoring Stopped'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _simulateThreatDetection() {
    final threatTypes = [
      {
        'type': 'Phishing Attack',
        'severity': 'High',
        'source': 'Suspicious Email',
        'action': 'Blocked',
        'time': DateTime.now().toString().substring(11, 19),
      },
      {
        'type': 'Malware Download',
        'severity': 'Critical',
        'source': 'Unknown Website',
        'action': 'Blocked',
        'time': DateTime.now().toString().substring(11, 19),
      },
      {
        'type': 'Data Breach Attempt',
        'severity': 'Medium',
        'source': 'Background App',
        'action': 'Blocked',
        'time': DateTime.now().toString().substring(11, 19),
      },
      {
        'type': 'Network Intrusion',
        'severity': 'High',
        'source': 'Public WiFi',
        'action': 'Blocked',
        'time': DateTime.now().toString().substring(11, 19),
      },
    ];

    final randomThreat = threatTypes[_threats.length % threatTypes.length];
    
    setState(() {
      _threats.insert(0, Map<String, dynamic>.from(randomThreat));
      _threatsBlocked++;
    });

    // Show notification for critical threats
    if (randomThreat['severity'] == 'Critical') {
      _showThreatAlert(randomThreat);
    }
  }

  void _showThreatAlert(Map<String, dynamic> threat) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Critical Threat Detected!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              threat['type'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Source: ' + threat['source'],
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.security_rounded, color: AppColors.success),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Threat automatically blocked',
                      style: TextStyle(
                        color: AppColors.success,
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
              _viewThreatDetails(threat);
            },
            child: Text('DETAILS'),
          ),
        ],
      ),
    );
  }

  void _viewThreatDetails(Map<String, dynamic> threat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Threat Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ThreatDetailRow(title: 'Type', value: threat['type']),
            _ThreatDetailRow(title: 'Severity', value: threat['severity']),
            _ThreatDetailRow(title: 'Source', value: threat['source']),
            _ThreatDetailRow(title: 'Action', value: threat['action']),
            _ThreatDetailRow(title: 'Time', value: threat['time']),
            SizedBox(height: 16),
            Text(
              'AI Analysis:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our AI system detected patterns consistent with ' +
              threat['type'].toString().toLowerCase() +
              ' and prevented potential data loss.',
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
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical': return AppColors.error;
      case 'High': return Color(0xFFFF6B35);
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.info;
      default: return AppColors.textSecondary;
    }
  }

  @override
  void dispose() {
    _threatSimulator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('AI Threat Detection'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // AI Status Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _isMonitoring ? 
                LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ) :
                LinearGradient(
                  colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
                ),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isMonitoring ? 'AI Protection Active' : 'AI Protection Inactive',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _isMonitoring ? 
                              ' threats blocked' : 
                              'Enable AI monitoring',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isMonitoring,
                      onChanged: (value) {
                        if (value) {
                          _startAIMonitoring();
                        } else {
                          _stopAIMonitoring();
                        }
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                if (_isMonitoring) ...[
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    color: Colors.white,
                    minHeight: 4,
                  ),
                ],
              ],
            ),
          ),

          // Real-time Threats
          Expanded(
            child: _threats.isEmpty ? 
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      size: 80,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No threats detected',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _isMonitoring ? 
                        'AI is monitoring your device' : 
                        'Enable AI monitoring to start protection',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ) :
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _threats.length,
                itemBuilder: (context, index) {
                  final threat = _threats[index];
                  return _ThreatCard(threat: threat);
                },
              ),
          ),
        ],
      ),
    );
  }
}

class _ThreatCard extends StatelessWidget {
  final Map<String, dynamic> threat;

  const _ThreatCard({
    required this.threat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getSeverityColor(threat['severity']).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                color: _getSeverityColor(threat['severity']),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    threat['type'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    threat['source'] + '  ' + threat['time'],
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
                color: _getSeverityColor(threat['severity']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                threat['severity'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getSeverityColor(threat['severity']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical': return AppColors.error;
      case 'High': return Color(0xFFFF6B35);
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.info;
      default: return AppColors.textSecondary;
    }
  }
}

class _ThreatDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _ThreatDetailRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title + ':',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
