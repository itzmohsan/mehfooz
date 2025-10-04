import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';

class FakeCallPage extends StatefulWidget {
  const FakeCallPage({super.key});

  @override
  State<FakeCallPage> createState() => _FakeCallPageState();
}

class _FakeCallPageState extends State<FakeCallPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isCallActive = false;
  String _callerName = 'Ammi Jan';
  String _callerNumber = '+92 300 XXXXXX';
  int _callDuration = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _callTimer?.cancel();
    super.dispose();
  }

  void _startFakeCall() {
    setState(() {
      _isCallActive = true;
      _callDuration = 0;
    });

    _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fake call started'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _endFakeCall() {
    _callTimer?.cancel();
    setState(() {
      _isCallActive = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Call ended after ' + _callDuration.toString() + ' seconds'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _changeCaller() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Caller'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text('Ammi Jan'),
              subtitle: Text('+92 300 XXXXXX'),
              onTap: () {
                setState(() {
                  _callerName = 'Ammi Jan';
                  _callerNumber = '+92 300 XXXXXX';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text('Office'),
              subtitle: Text('+92 321 XXXXXX'),
              onTap: () {
                setState(() {
                  _callerName = 'Office';
                  _callerNumber = '+92 321 XXXXXX';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text('Boss'),
              subtitle: Text('+92 333 XXXXXX'),
              onTap: () {
                setState(() {
                  _callerName = 'Boss';
                  _callerNumber = '+92 333 XXXXXX';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text('Emergency'),
              subtitle: Text('+92 311 XXXXXX'),
              onTap: () {
                setState(() {
                  _callerName = 'Emergency';
                  _callerNumber = '+92 311 XXXXXX';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Fake Call'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Call will ring in:'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ScheduleButton(time: 1, onTap: _scheduleCallInSeconds),
                _ScheduleButton(time: 2, onTap: _scheduleCallInSeconds),
                _ScheduleButton(time: 5, onTap: _scheduleCallInSeconds),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleCallInSeconds(int seconds) {
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fake call scheduled in ' + seconds.toString() + ' seconds'),
        backgroundColor: AppColors.info,
      ),
    );

    Future.delayed(Duration(seconds: seconds), () {
      _startFakeCall();
    });
  }

  String _formatCallDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return ':';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isCallActive ? AppColors.primary : AppColors.background,
      appBar: AppBar(
        title: Text('Fake Call'),
        backgroundColor: _isCallActive ? AppColors.primary : AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: _isCallActive ? null : () => Navigator.pop(context),
        ),
        actions: _isCallActive ? null : [
          IconButton(
            icon: Icon(Icons.schedule_rounded),
            onPressed: _scheduleCall,
          ),
        ],
      ),
      body: _isCallActive ? _buildActiveCallScreen() : _buildReadyScreen(),
    );
  }

  Widget _buildReadyScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Main Call Button
          GestureDetector(
            onTap: _startFakeCall,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.phone_rounded,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),

          SizedBox(height: 32),

          // Caller Info
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_rounded, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Current Caller',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit_rounded),
                        onPressed: _changeCaller,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    _callerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _callerNumber,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.schedule_rounded,
                  title: 'Schedule',
                  subtitle: 'Set timer',
                  onTap: _scheduleCall,
                  color: AppColors.info,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.person_rounded,
                  title: 'Change',
                  subtitle: 'Caller ID',
                  onTap: _changeCaller,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Emergency Info
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Tips',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  _SafetyTip(
                    icon: Icons.emergency_rounded,
                    text: 'Use in uncomfortable situations',
                  ),
                  _SafetyTip(
                    icon: Icons.group_rounded,
                    text: 'Exit crowded gatherings',
                  ),
                  _SafetyTip(
                    icon: Icons.directions_walk_rounded,
                    text: 'Create excuse to leave',
                  ),
                  _SafetyTip(
                    icon: Icons.security_rounded,
                    text: 'Appears as real incoming call',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCallScreen() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Caller Info
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  _callerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _callerNumber,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _formatCallDuration(_callDuration),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Call Controls
        Container(
          padding: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // End Call Button
              GestureDetector(
                onTap: _endFakeCall,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.call_end_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafetyTip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SafetyTip({
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
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleButton extends StatelessWidget {
  final int time;
  final Function(int) onTap;

  const _ScheduleButton({
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(time),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              time.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              'sec',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
