import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'package:myapp/admin/admin_dashboard.dart';
import 'package:myapp/admin/new_registrations.dart';
import 'package:myapp/admin/view_matches.dart';
import 'package:myapp/admin/transplantation_results.dart';
import 'package:myapp/admin/generate_reports.dart';
import 'package:myapp/admin/view_feedbacks.dart';
import 'package:myapp/admin/view_complaints.dart';
// ...other imports...

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/adminDashboard': (context) => AdminDashboardPage(),
        '/newRegistrations': (context) => NewRegistrationsPage(),
        '/viewMatches': (context) => ViewMatchesPage(),
        '/transplantationResults': (context) => TransplantationResultsPage(),
        '/generateReports': (context) => GenerateReportsPage(),
        '/viewFeedbacks': (context) => ViewFeedbacksPage(),
        '/viewComplaints': (context) => ViewComplaintsPage(),
        // ...other routes...
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organ Bank'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome to the Organ Bank',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              SizedBox(height: 20),
              Text(
                'About the Program',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'The Organ Bank program is dedicated to saving lives by facilitating organ donations and transplants. Our system allows users to register as donors, find matching recipients, and manage the entire process seamlessly.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'What the System Does',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Our system provides a platform for users to register as organ donors, search for available organs, and manage their donation preferences. It also helps medical professionals to find matching donors for patients in need of transplants.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //Navigate to login page
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
