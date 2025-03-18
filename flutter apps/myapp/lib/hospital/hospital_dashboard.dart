import 'package:flutter/material.dart';

class HospitalDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 96, 0, 0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 255, 255)!, Colors.red[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              DashboardButton(
                text: 'Update Profile',
                icon: Icons.person,
                onPressed: () {
                  Navigator.pushNamed(context, '/updateHospitalProfile', arguments: userId);
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Schedule Compatibility Test',
                icon: Icons.schedule,
                onPressed: () {
                  Navigator.pushNamed(context, '/testSchedule', arguments: userId);
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Update Compatibility Test Result',
                icon: Icons.update,
                onPressed: () {
                  Navigator.pushNamed(context, '/testResultUpdate', arguments: userId);
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Schedule Transplantation',
                icon: Icons.calendar_today,
                onPressed: () {
                  Navigator.pushNamed(context, '/transplantationSchedule', arguments: userId);
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Update Transplantation Result',
                icon: Icons.update,
                onPressed: () {
                  Navigator.pushNamed(context, '/transplantationResultUpdate', arguments: userId);
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Feedback',
                icon: Icons.feedback,
                onPressed: () {
                  Navigator.pushNamed(context, '/submitFeedback', arguments: userId);
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Complaint',
                icon: Icons.report_problem,
                onPressed: () {
                  Navigator.pushNamed(context, '/submitComplaint', arguments: userId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const DashboardButton({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 92, 2, 0),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
    );
  }
}
