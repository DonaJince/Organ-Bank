import 'package:flutter/material.dart';
import 'package:myapp/services/adminservices.dart';

class ViewMatchesPage extends StatefulWidget {
  @override
  _ViewMatchesPageState createState() => _ViewMatchesPageState();
}

class _ViewMatchesPageState extends State<ViewMatchesPage> {
  final AdminServices adminService = AdminServices();

  Future<List<dynamic>> getPendingMatches() async {
    try {
      final response = await adminService.getPendingMatches();
      print("Fetched Matches: ${response['pendingMatches']}");
      return response['pendingMatches'] ?? [];
    } catch (e) {
      print("Error fetching matches: $e");
      throw Exception("Failed to load matches");
    }
  }

  Future<void> approveMatch(String matchId) async {
    try {
      await adminService.approveMatch(matchId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Match Approved Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to approve match: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Matches'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getPendingMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No pending matches available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var match = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Organ: ${match["organ"]}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Donor Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(),
                      Text("ID: ${match["donorid"]["_id"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black87)),
                      Text("Name: ${match["donorName"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black87)),
                      SizedBox(height: 6),
                      Text(
                        "Recipient Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(),
                      Text("ID: ${match["receipientid"]["_id"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black87)),
                      Text("Name: ${match["receipientName"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black87)),
                      SizedBox(height: 6),
                      Text(
                        "Hospital Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Divider(),
                      Text("ID: ${match["hospitalid"]["_id"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black87)),
                      Text("Name: ${match["hospitalName"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black87)),
                      SizedBox(height: 6),
                      Text(
                        "Status: ${match["status"].toUpperCase()}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: match["status"] == "pending"
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => approveMatch(match["_id"]),
                          child: Text(
                            "Approve",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
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