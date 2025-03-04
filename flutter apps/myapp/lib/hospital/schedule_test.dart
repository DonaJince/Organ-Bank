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
      setState(() {
        approvedMatches = response.map((match) {
          return {
            ...match,
            '_id': match['_id']?.toString() ?? '', // Ensure _id is a String
          };
        }).toList();

        emailControllers = {
          for (var match in approvedMatches)
            match['_id']: TextEditingController()
        };
      });
    } catch (e) {
      print("Error fetching approved matches: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching matches: ${e.toString()}')),
      );
    }
  }

  Future<void> _sendTestScheduleEmail(String matchId) async {
    final emailBody = emailControllers[matchId]?.text.trim() ?? '';
    if (emailBody.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email body cannot be empty.')),
      );
      return;
    }

    try {
      final response =
          await userServices.sendTestScheduleEmail(matchId, emailBody);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email.')),
        );
      }
    } catch (e) {
      print("Error sending test schedule email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Test'),
      ),
      body: approvedMatches.isEmpty
          ? Center(child: Text('There are no approved matches.'))
          : ListView.builder(
              itemCount: approvedMatches.length,
              itemBuilder: (context, index) {
                final match = approvedMatches[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${match["donorName"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Email: ${match["donorEmail"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
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
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${match["receipientName"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Email: ${match["receipientEmail"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
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
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${match["hospitalName"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Email:${match["hospitalEmail"]}",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                        SizedBox(height: 6),
                        TextField(
                          controller: emailControllers[match['_id']],
                          decoration: InputDecoration(
                            labelText: 'Email Body',
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            _sendTestScheduleEmail(match['_id']);
                          },
                          child: Text('Send Email'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
