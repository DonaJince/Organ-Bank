import 'package:flutter/material.dart';
import 'package:myapp/admin/verifydonor.dart';
import 'package:myapp/admin/verifyhospital.dart';
import 'package:myapp/admin/verifyreceipient.dart';
import 'package:myapp/complaint.dart';
import 'package:myapp/donor/donor_dashboard.dart';
import 'package:myapp/feedback.dart';
import 'package:myapp/hospital/hospital_dashboard.dart';
import 'package:myapp/hospital/schedule_test.dart';
import 'package:myapp/hospital/schedule_transplantation.dart';
import 'package:myapp/hospital/update_testresult.dart';
import 'package:myapp/hospital/update_transplantationresult.dart';
import 'package:myapp/login.dart';
import 'package:myapp/admin/admin_dashboard.dart';
import 'package:myapp/admin/view_matches.dart';
import 'package:myapp/admin/transplantation_results.dart';
import 'package:myapp/admin/generate_reports.dart';
import 'package:myapp/admin/view_feedbacks.dart';
import 'package:myapp/admin/view_complaints.dart';
import 'package:myapp/receipient/makerequests.dart';
import 'package:myapp/receipient/receiver_dashboard.dart';
import 'package:myapp/receipient/view_requeststatus.dart';
import 'package:myapp/update_hospitalprofile.dart';
import 'package:myapp/update_userprofile.dart'; // Add this import
import 'package:myapp/donor/makedonations.dart'; 
import 'package:myapp/donor/view_donationstatus.dart'; // Add this import
// ...other imports..

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
        '/donorDashboard': (context) => DonorDashboardPage(),
        '/hospitalDashboard': (context) => HospitalDashboardPage(),
        '/receiverDashboard': (context) => ReceiverDashboardPage(),
        '/viewMatches': (context) => ViewMatchesPage(),
        '/transplantationResults': (context) => TransplantationResultsPage(),
        '/generateReports': (context) => GenerateReportsPage(),
        '/viewFeedbacks': (context) => ViewFeedbacksPage(),
        '/viewComplaints': (context) => ViewComplaintsPage(),
        '/verifyDonors': (context) => VerifyDonorPage(),
        '/verifyReceipients': (context) => VerifyReceipientPage(),
        '/verifyHospitals': (context) => VerifyHospitalPage(),
        '/updateUserProfile': (context) => UpdateUserProfilePage(
            id: ModalRoute.of(context)!.settings.arguments as String),
        '/updateHospitalProfile': (context) => UpdateHospitalProfilePage(
            id: ModalRoute.of(context)!.settings.arguments as String),
        '/submitFeedback': (context) => FeedbackForm(
            userId: ModalRoute.of(context)!.settings.arguments as String),
        '/submitComplaint': (context) => ComplaintForm(
            userId: ModalRoute.of(context)!.settings.arguments as String),
        '/submitDonation': (context) => MakeDonationsPage(
            id: ModalRoute.of(context)!.settings.arguments as String),
        '/submitRequest': (context) => MakeRequestPage(
            id: ModalRoute.of(context)!.settings.arguments as String),
        '/viewDonationStatus': (context) => ViewDonationStatusPage(
            donorId: ModalRoute.of(context)!.settings.arguments as String),
        '/viewRequestStatus': (context) => ViewRequestStatusPage(
            receiverId: ModalRoute.of(context)!.settings.arguments as String),
        '/testSchedule': (context) => ScheduleTestPage(
            hospitalId: ModalRoute.of(context)!.settings.arguments as String),
        '/testResultUpdate': (context) => UpdateTestResultPage(
            hospitalId: ModalRoute.of(context)!.settings.arguments as String), 
        '/transplantationSchedule': (context) => ScheduleTransplantationPage(
            hospitalId: ModalRoute.of(context)!.settings.arguments as String), 
        '/transplantationResultUpdate': (context) => UpdateTransplantationResultPage(
            hospitalId: ModalRoute.of(context)!.settings.arguments as String),
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
        backgroundColor: Colors.teal,
        elevation: 0,
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
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'A platform dedicated to saving lives through efficient organ donation and transplantation.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Add image above the About section
              Center(
                child: Image.asset(
                  'assets/image.png', // Ensure this image exists in the assets folder
                  height: 200,
                ),
              ),
              SizedBox(height: 20),

              // About Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: Colors.teal, size: 30),
                      SizedBox(height: 10),
                      Text(
                        'About the Program',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'The Organ Bank is a life-saving initiative that connects donors and recipients through an efficient matching system. It ensures timely organ allocation while providing transparency in the donation process.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // System Features Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.settings, color: Colors.teal, size: 30),
                      SizedBox(height: 10),
                      Text(
                        'What the System Does',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                      SizedBox(height: 10),
                      _buildFeatureItem(
                          '✔️ Register as an organ donor or recipient.'),
                      _buildFeatureItem(
                          '✔️ Match donors with recipients based on medical compatibility.'),
                      _buildFeatureItem(
                          '✔️ Manage donation and transplantation requests.'),
                      _buildFeatureItem(
                          '✔️ Provide a secure platform for hospitals to verify donor eligibility.'),
                      _buildFeatureItem(
                          '✔️ Generate reports and track transplantation success rates.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Login Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for feature list items
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
