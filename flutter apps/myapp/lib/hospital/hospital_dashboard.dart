import 'package:flutter/material.dart';

class HospitalDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the user ID passed from the login page
    final String userId = ModalRoute.of(context)!.settings.arguments as String;
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  DashboardCard(
                    title: 'Update Profile',
                    icon: Icons.person,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/updateHospitalProfile',
                        arguments: userId, // Pass the user ID
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'Schedule Compatibility Test',
                    icon: Icons.schedule,
                    color: Colors.orange,
                    onTap: () {

                      Navigator.pushNamed(
                        context,
                        '/testSchedule',
                        arguments: userId, // Pass the user ID
                      );
                      // Navigate to Schedule Compatibility Test screen
                    },
                  ),
                  DashboardCard(
                    title: 'Update Compatibility Test Result',
                    icon: Icons.update,
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to Update Compatibility Test Result screen
                    },
                  ),
                  DashboardCard(
                    title: 'Schedule Transplantation',
                    icon: Icons.calendar_today,
                    color: Colors.green,
                    onTap: () {
                      // Navigate to Schedule Transplantation screen
                    },
                  ),
                  DashboardCard(
                    title: 'Update Transplantation Result',
                    icon: Icons.update,
                    color: const Color.fromARGB(255, 5, 23, 222),
                    onTap: () {
                      // Navigate to Update Transplantation Result screen
                    },
                  ),
                  DashboardCard(
                    title: 'Feedback',
                    icon: Icons.feedback,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/submitFeedback',
                        arguments: email, // Pass the user ID
                      );
                    },
                  ),
                  DashboardCard(
                    title: 'Complaint',
                    icon: Icons.report_problem,
                    color: const Color.fromARGB(255, 255, 68, 0),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/submitComplaint',
                        arguments: email, // Pass the user ID
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  DashboardCard(
      {required this.title,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 50, color: color),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HospitalDashboardPage(),
  ));
}
