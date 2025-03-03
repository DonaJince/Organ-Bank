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
          for (var match in approvedMatches) match['_id']: TextEditingController()
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
      final response = await userServices.sendTestScheduleEmail(matchId, emailBody);
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: approvedMatches.length,
              itemBuilder: (context, index) {
                final match = approvedMatches[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Match ID: ${match['_id']}'),
                        Text('Donor ID: ${match['donorid']}'),
                        Text('Recipient ID: ${match['receipientid']}'),
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
