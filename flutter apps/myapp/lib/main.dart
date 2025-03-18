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
import 'package:myapp/update_userprofile.dart';
import 'package:myapp/donor/makedonations.dart';
import 'package:myapp/donor/view_donationstatus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organ Bank',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        backgroundColor: const Color.fromARGB(255, 128, 2, 0),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Hero Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Give the Gift of Life',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 82, 0, 0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Register as an Organ Donor Today!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/image.png', // Ensure this image exists in the assets folder
                      height: 200,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // About the Organ Bank
              Text(
                'About the Organ Bank',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 102, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The Organ Bank is a secure and efficient platform connecting organ donors with recipients. Our goal is to simplify the organ donation and transplantation process through technology-driven solutions.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 30),

              // Key Features
              Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 102, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              _buildFeatureItem('✅ Easy Registration – Sign up as a donor or recipient in just a few steps.'),
              _buildFeatureItem('🔍 Automated Organ Matching – AI-driven system ensures accurate matches.'),
              _buildFeatureItem('📢 Real-time Notifications – Stay updated on matching and transplant status.'),
              _buildFeatureItem('🔒 Secure & Transparent – Ensuring trust with encrypted data handling.'),
              SizedBox(height: 30),

              // How It Works
              Text(
                'How It Works',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 102, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              _buildStepItem('1. Register: Donors and recipients create profiles.'),
              _buildStepItem('2. Organ Matching: Our system finds the best match based on medical compatibility.'),
              _buildStepItem('3. Hospital Coordination: Schedule tests and transplant procedures.'),
              _buildStepItem('4. Save a Life: The final transplant process takes place under expert medical supervision.'),
              SizedBox(height: 30),

              // Testimonials (Optional)
              Text(
                'Testimonials',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 102, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              _buildTestimonialItem(
                'This platform helped me find a matching kidney donor in record time. Forever grateful!',
                'jennifer Lowrence',
              ),
              _buildTestimonialItem(
                'Knowing my donation could save a life gives me immense satisfaction.',
                'Tyler Lockhood',
              ),
              SizedBox(height: 30),

              // Contact & Support
              Text(
                'Contact & Support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 102, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              _buildContactItem('📍 Location: Silver City, Atlas'),
              _buildContactItem('📞 Helpline: +91 2648364908'),
              _buildContactItem('📧 Email: organbank2025@gmail.com'),
              SizedBox(height: 30),

              // Footer Section
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 99, 0, 0),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Get Started', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 30),

              // Footer Links
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Privacy Policy', style: TextStyle(color: Colors.black87)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Terms & Conditions', style: TextStyle(color: Colors.black87)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('FAQs', style: TextStyle(color: Colors.black87)),
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

  // Helper function for feature list items
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          
          SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // Helper function for step list items
  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.arrow_forward, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // Helper function for testimonial items
  Widget _buildTestimonialItem(String text, String author) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$text"',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
          ),
          SizedBox(height: 5),
          Text(
            '- $author',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Helper function for contact items
  Widget _buildContactItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.contact_mail, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}