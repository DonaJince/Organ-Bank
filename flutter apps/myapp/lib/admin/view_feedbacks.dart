import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart'; // Import UserService

class ViewFeedbacksPage extends StatefulWidget {
  @override
  _ViewFeedbacksPageState createState() => _ViewFeedbacksPageState();
}

class _ViewFeedbacksPageState extends State<ViewFeedbacksPage> {
  final UserServices userService = UserServices(); // Create UserService instance

  Future<List<dynamic>> fetchFeedbacks() async {
    try {
      final response =
          await userService.getFeedback(); // Use UserService to get feedback
      return response;
    } catch (e) {
      throw Exception("Failed to load feedbacks");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Feedbacks',
            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
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
                margin: EdgeInsets.all(8.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text("ID: ${feedback["_id"]}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Feedback: ${feedback["feedback"]}",
                      style: TextStyle(color: Colors.teal)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
