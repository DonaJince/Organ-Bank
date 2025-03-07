import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReceiverDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context)!.settings.arguments as String;
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Receiver Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red[200],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.red.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Receiver!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 116, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Manage your requests and profile here.',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(179, 82, 0, 0),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildDashboardButton(
                      context,
                      title: 'Update Profile',
                      icon: FontAwesomeIcons.userEdit,
                      route: '/updateUserProfile',
                      argument: userId,
                    ),
                    _buildDashboardButton(
                      context,
                      title: 'Make a Request',
                      icon: FontAwesomeIcons.handHoldingMedical,
                      route: '/submitRequest',
                      argument: userId,
                    ),
                    _buildDashboardButton(
                      context,
                      title: 'Request Status',
                      icon: FontAwesomeIcons.clipboardList,
                      route: '/viewRequestStatus',
                      argument: userId,
                    ),
                    _buildDashboardButton(
                      context,
                      title: 'Give Feedback',
                      icon: FontAwesomeIcons.comment,
                      route: '/submitFeedback',
                      argument: userId,
                    ),
                    _buildDashboardButton(
                      context,
                      title: 'File a Complaint',
                      icon: FontAwesomeIcons.exclamationCircle,
                      route: '/submitComplaint',
                      argument: userId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    String? argument,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route, arguments: argument);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red.shade900, size: 20),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}