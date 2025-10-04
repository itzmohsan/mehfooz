import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';

class BillCheckerPage extends StatefulWidget {
  const BillCheckerPage({super.key});

  @override
  State<BillCheckerPage> createState() => _BillCheckerPageState();
}

class _BillCheckerPageState extends State<BillCheckerPage> {
  final List<Map<String, dynamic>> _bills = [
    {
      'type': 'Electricity',
      'provider': 'IESCO',
      'amount': 4500,
      'dueDate': '2024-01-15',
      'status': 'pending',
      'isOvercharged': true,
    },
    {
      'type': 'Gas',
      'provider': 'SNGPL',
      'amount': 1200,
      'dueDate': '2024-01-20',
      'status': 'paid',
      'isOvercharged': false,
    },
    {
      'type': 'Water',
      'provider': 'WASA',
      'amount': 800,
      'dueDate': '2024-01-25',
      'status': 'pending',
      'isOvercharged': true,
    },
    {
      'type': 'Internet',
      'provider': 'PTCL',
      'amount': 2500,
      'dueDate': '2024-01-10',
      'status': 'paid',
      'isOvercharged': false,
    },
  ];

  double _totalSavings = 0.0;

  void _analyzeBills() {
    double savings = 0;
    for (var bill in _bills) {
      if (bill['isOvercharged'] == true) {
        savings += (bill['amount'] as int) * 0.15; // Assume 15% overcharge
      }
    }
    
    setState(() {
      _totalSavings = savings;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Found ' + _bills.where((bill) => bill['isOvercharged'] == true).length.toString() + ' overcharged bills'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _disputeBill(int index) {
    setState(() {
      _bills[index]['status'] = 'disputed';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispute filed for ' + _bills[index]['type'] + ' bill'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _uploadBill() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Bill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _analyzePhotoBill();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _analyzePhotoBill();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _analyzePhotoBill() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Analyzing Bill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking for overcharges...'),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill analysis complete'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid': return AppColors.success;
      case 'pending': return AppColors.warning;
      case 'disputed': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bill Checker'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Savings Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: Row(
              children: [
                Icon(Icons.savings_rounded, color: Colors.white, size: 40),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Potential Savings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rs. ' + _totalSavings.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _analyzeBills,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text('ANALYZE'),
                ),
              ],
            ),
          ),

          // Bills List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _bills.length,
              itemBuilder: (context, index) {
                final bill = _bills[index];
                return _BillCard(
                  bill: bill,
                  onDispute: () => _disputeBill(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadBill,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final Map<String, dynamic> bill;
  final VoidCallback onDispute;

  const _BillCard({
    required this.bill,
    required this.onDispute,
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
                    Icons.receipt_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill['type'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        bill['provider'],
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
                    color: _getStatusColor(bill['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    bill['status'].toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(bill['status']),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Rs. ' + bill['amount'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        bill['dueDate'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (bill['isOvercharged'] == true) ...[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Possible overcharge detected',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (bill['status'] != 'disputed')
                      TextButton(
                        onPressed: onDispute,
                        child: Text(
                          'DISPUTE',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid': return AppColors.success;
      case 'pending': return AppColors.warning;
      case 'disputed': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }
}
