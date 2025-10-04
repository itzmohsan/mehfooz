import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';

class DataCleanerPage extends StatefulWidget {
  const DataCleanerPage({super.key});

  @override
  State<DataCleanerPage> createState() => _DataCleanerPageState();
}

class _DataCleanerPageState extends State<DataCleanerPage> {
  final List<Map<String, dynamic>> _dataBrokers = [
    {
      'name': 'PeopleFinders',
      'dataPoints': 15,
      'risk': 'High',
      'status': 'active',
    },
    {
      'name': 'Whitepages',
      'dataPoints': 12,
      'risk': 'High',
      'status': 'active',
    },
    {
      'name': 'Spokeo',
      'dataPoints': 8,
      'risk': 'Medium',
      'status': 'active',
    },
    {
      'name': 'Intelius',
      'dataPoints': 10,
      'risk': 'High',
      'status': 'removed',
    },
    {
      'name': 'BeenVerified',
      'dataPoints': 6,
      'risk': 'Medium',
      'status': 'active',
    },
  ];

  int _totalDataPoints = 0;
  bool _isCleaning = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotalData();
  }

  void _calculateTotalData() {
    int total = 0;
    for (var broker in _dataBrokers) {
      if (broker['status'] == 'active') {
        total += broker['dataPoints'] as int;
      }
    }
    setState(() {
      _totalDataPoints = total;
    });
  }

  void _startCleanup() {
    setState(() {
      _isCleaning = true;
      _progress = 0.0;
    });

    _simulateCleanupProcess();
  }

  void _simulateCleanupProcess() {
    const totalSteps = 10;
    var currentStep = 0;

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        currentStep++;
        _progress = currentStep / totalSteps;

        if (currentStep % 2 == 0 && currentStep < _dataBrokers.length * 2) {
          int brokerIndex = (currentStep ~/ 2) - 1;
          if (brokerIndex < _dataBrokers.length) {
            _dataBrokers[brokerIndex]['status'] = 'removed';
          }
        }
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        setState(() {
          _isCleaning = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data cleanup completed!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        _calculateTotalData();
      }
    });
  }

  void _optOutManually(String brokerName) {
    setState(() {
      final broker = _dataBrokers.firstWhere((b) => b['name'] == brokerName);
      broker['status'] = 'removed';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opt-out request sent to ' + brokerName),
        backgroundColor: AppColors.info,
      ),
    );

    _calculateTotalData();
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'High': return AppColors.error;
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Data Cleaner'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.privacy_tip_rounded, color: AppColors.primary, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Privacy Score',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            (_totalDataPoints == 0 ? '100' : (100 - _totalDataPoints).clamp(0, 100)).toString() + '/100',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: (_totalDataPoints == 0 ? 100 : (100 - _totalDataPoints).clamp(0, 100)) / 100,
                  backgroundColor: AppColors.border,
                  color: _totalDataPoints == 0 ? AppColors.success : AppColors.warning,
                  minHeight: 8,
                ),
                SizedBox(height: 8),
                Text(
                  _totalDataPoints.toString() + ' data points found across ' + 
                  _dataBrokers.where((b) => b['status'] == 'active').length.toString() + ' sites',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Cleanup Progress
          if (_isCleaning) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                border: Border.all(color: AppColors.info),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircularProgressIndicator(
                        value: _progress,
                        color: AppColors.info,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cleaning Data...',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Removing your data from broker sites',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        (_progress * 100).toStringAsFixed(0) + '%',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],

          // Data Brokers List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _dataBrokers.length,
              itemBuilder: (context, index) {
                final broker = _dataBrokers[index];
                return _DataBrokerCard(
                  broker: broker,
                  onOptOut: () => _optOutManually(broker['name']),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isCleaning ? null : FloatingActionButton.extended(
        onPressed: _startCleanup,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: Icon(Icons.clean_hands_rounded),
        label: Text('CLEAN NOW'),
      ),
    );
  }
}

class _DataBrokerCard extends StatelessWidget {
  final Map<String, dynamic> broker;
  final VoidCallback onOptOut;

  const _DataBrokerCard({
    required this.broker,
    required this.onOptOut,
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
                    Icons.business_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        broker['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        broker['dataPoints'].toString() + ' data points',
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
                    color: _getRiskColor(broker['risk']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    broker['risk'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getRiskColor(broker['risk']),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: broker['status'] == 'removed' ? 
                             AppColors.success.withOpacity(0.1) : 
                             AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      broker['status'] == 'removed' ? 'Data Removed' : 'Active Tracking',
                      style: TextStyle(
                        color: broker['status'] == 'removed' ? 
                               AppColors.success : AppColors.warning,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (broker['status'] == 'active')
                  ElevatedButton(
                    onPressed: onOptOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('OPT OUT'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'High': return AppColors.error;
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }
}
