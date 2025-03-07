import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.red[200],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.red[200]!],
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
                text: 'Verify Donors',
                icon: Icons.person_search,
                onPressed: () {
                  Navigator.pushNamed(context, '/verifyDonors');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Verify Recipients',
                icon: Icons.person_add,
                onPressed: () {
                  Navigator.pushNamed(context, '/verifyReceipients');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Verify Hospitals',
                icon: Icons.local_hospital,
                onPressed: () {
                  Navigator.pushNamed(context, '/verifyHospitals');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'View Matches',
                icon: Icons.view_list,
                onPressed: () {
                  Navigator.pushNamed(context, '/viewMatches');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Transplantation Results',
                icon: Icons.assignment_turned_in,
                onPressed: () {
                  Navigator.pushNamed(context, '/transplantationResults');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'Generate Reports',
                icon: Icons.insert_chart,
                onPressed: () {
                  Navigator.pushNamed(context, '/generateReports');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'View Feedbacks',
                icon: Icons.feedback,
                onPressed: () {
                  Navigator.pushNamed(context, '/viewFeedbacks');
                },
              ),
              SizedBox(height: 20),
              DashboardButton(
                text: 'View Complaints',
                icon: Icons.report_problem,
                onPressed: () {
                  Navigator.pushNamed(context, '/viewComplaints');
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
        backgroundColor: Colors.red[400],
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
    );
  }
}