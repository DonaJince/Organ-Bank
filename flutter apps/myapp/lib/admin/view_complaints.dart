import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ViewComplaintsPage extends StatefulWidget {
  @override
  _ViewComplaintsPageState createState() => _ViewComplaintsPageState();
}

class _ViewComplaintsPageState extends State<ViewComplaintsPage> {
  final UserServices userService = UserServices();

  Future<List<dynamic>> fetchComplaints() async {
    try {
      final response = await userService.getComplaints();
      return response["complaints"] ?? []; // Handle null case
    } catch (e) {
      throw Exception("Failed to load complaints: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Complaints', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 94, 0, 31), // Changed from Teal
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchComplaints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 16, color: Colors.red)));
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
                      Text("ID: ${complaint["_id"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 4),
                      Text("Name: ${complaint["userName"]}",
                          style: TextStyle(fontSize: 14, color: Colors.black87)),
                      Text("Email: ${complaint["userEmail"]}",
                          style: TextStyle(fontSize: 14, color: Colors.black87)),
                      Divider(),
                      Text("Complaint:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(complaint["complaint"] ?? "No complaint provided",
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
