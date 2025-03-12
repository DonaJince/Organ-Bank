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
      return response['pendingMatches'] ?? [];
    } catch (e) {
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
        title: Text('Pending Matches', style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white )),
        backgroundColor: const Color.fromARGB(255, 87, 0, 29),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.red[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: getPendingMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No pending matches available",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var match = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Organ: ${match["organ"]}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 182, 41, 121))),
                        SizedBox(height: 6),
                        buildSection("Donor Details", match["donorid"], match["donorName"]),
                        buildSection("Recipient Details", match["receipientid"], match["receipientName"]),
                        buildSection("Hospital Details", match["hospitalid"], match["hospitalName"]),
                        SizedBox(height: 6),
                        Text(
                          "Status: ${match["status"].toUpperCase()}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: match["status"] == "pending" ? Colors.orange : Colors.green,
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => approveMatch(match["_id"]),
                            child: Text("Approve", style: TextStyle(fontSize: 16, color: Colors.white)),
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
      ),
    );
  }

  Widget buildSection(String title, dynamic id, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Divider(color: Colors.grey.shade400),
        Text("ID: ${id["_id"]}", style: TextStyle(fontSize: 16, color: Colors.black87)),
        Text("Name: $name", style: TextStyle(fontSize: 16, color: Colors.black87)),
      ],
    );
  }
}
