import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ScheduleTestPage extends StatefulWidget {
  final String hospitalId;

  const ScheduleTestPage({super.key, required this.hospitalId});

  @override
  _ScheduleTestPageState createState() => _ScheduleTestPageState();
}

class _ScheduleTestPageState extends State<ScheduleTestPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> approvedMatches = [];
  Map<String, TextEditingController> emailControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchApprovedMatches();
  }

  Future<void> _fetchApprovedMatches() async {
  try {
    final response = await userServices.getApprovedMatches(widget.hospitalId);
    if (!mounted) return;

    List<Map<String, dynamic>> fetchedMatches = response.map((match) {
      return {
        ...match,
        '_id': match['_id']?.toString() ?? '',
      };
    }).toList();

    print("Approved Matches: $fetchedMatches"); // Debugging line

    if (!mounted) return;

    setState(() {
      approvedMatches = fetchedMatches;
      emailControllers = {
        for (var match in approvedMatches) if (match['_id'].isNotEmpty) match['_id']: TextEditingController()
      };
    });
  } catch (e) {
    if (!mounted) return;
    print("Error fetching matches: ${e.toString()}"); // Debugging line
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching matches: ${e.toString()}')),
    );
  }
}



  Future<void> _sendTestScheduleEmail(String matchId) async {
  final emailBody = emailControllers[matchId]?.text.trim() ?? '';
  if (emailBody.isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email body cannot be empty.')),
    );
    return;
  }

  try {
    final response = await userServices.sendTestScheduleEmail(matchId, emailBody);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.statusCode == 200 ? 'Email sent successfully.' : 'Failed to send email.'),
        backgroundColor: response.statusCode == 200 ? Colors.green : Colors.red,
      ),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error sending email: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Test', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 87, 0, 20),
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
        child: approvedMatches.isEmpty
            ? Center(
                child: Text('There are no approved matches.',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: approvedMatches.length,
                itemBuilder: (context, index) {
                  final match = approvedMatches[index];
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
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 149, 0, 77))),
                          SizedBox(height: 6),
                          buildSection("Donor Details", match["donorid"]["_id"], match["donorid"]["name"], match["donorid"]["email"]),
                          buildSection("Recipient Details", match["receipientid"]["_id"], match["receipientid"]["name"], match["receipientid"]["email"]),

      
                          SizedBox(height: 6),
                          TextField(
                            controller: emailControllers[match['_id']],
                            decoration: InputDecoration(
                              labelText: 'Enter date and time for test',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 8.0),
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
                              onPressed: () => _sendTestScheduleEmail(match['_id']),
                              child: Text('Send Email', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildSection(String title, String id, String name, String email) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 6),
      Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      Divider(color: Colors.grey.shade400),
      Text("ID: $id", style: TextStyle(fontSize: 16, color: Colors.black87)),
      Text("Name: $name", style: TextStyle(fontSize: 16, color: Colors.black87)),
      Text("Email: $email", style: TextStyle(fontSize: 16, color: Colors.black87)),
    ],
  );
}


  @override
  void dispose() {
    for (var controller in emailControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
