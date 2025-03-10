import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ViewFeedbacksPage extends StatefulWidget {
  @override
  _ViewFeedbacksPageState createState() => _ViewFeedbacksPageState();
}

class _ViewFeedbacksPageState extends State<ViewFeedbacksPage> {
  final UserServices userService = UserServices();

  Future<List<dynamic>> fetchFeedbacks() async {
    try {
      final response = await userService.getFeedback();
      return response["feedbacks"] ?? []; // Handle null case
    } catch (e) {
      throw Exception("Failed to load feedbacks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Feedbacks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 94, 0, 31), // Changed from Teal
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 16, color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No feedbacks available",
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var feedback = snapshot.data![index];
              return Card(
                color: const Color.fromARGB(255, 217, 217, 217),
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${feedback["_id"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 4),
                      Text("Name: ${feedback["userName"]}",
                          style: TextStyle(fontSize: 14, color: Colors.black87)),
                      Text("Email: ${feedback["userEmail"]}",
                          style: TextStyle(fontSize: 14, color: Colors.black87)),
                      Divider(),
                      Text("Feedback:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(feedback["feedback"] ?? "No feedback provided",
                          style: TextStyle(fontSize: 14, color: Colors.black87)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
