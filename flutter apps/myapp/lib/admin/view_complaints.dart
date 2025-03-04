import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart'; // Import UserService

class ViewComplaintsPage extends StatefulWidget {
  @override
  _ViewComplaintsPageState createState() => _ViewComplaintsPageState();
}

class _ViewComplaintsPageState extends State<ViewComplaintsPage> {
  final UserServices userService = UserServices(); // Create UserService instance

  Future<List<dynamic>> fetchComplaints() async {
  try {
    final response = await userService.getComplaints();
    return response["complaints"]; // Extract the complaints list
  } catch (e) {
    throw Exception("Failed to load complaints");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Complaints', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchComplaints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No complaints available",
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var complaint = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text("ID: ${complaint["_id"]}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${complaint["userName"]}",
                          style: TextStyle(color: Colors.black87)),
                      Text("Email: ${complaint["userEmail"]}",
                          style: TextStyle(color: Colors.black87)),
                      SizedBox(height: 6),
                      Text("Complaint: ${complaint["complaint"]}",
                          style: TextStyle(color: Colors.teal)),
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