import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ScheduleTransplantationPage extends StatefulWidget {
  final String hospitalId;

  const ScheduleTransplantationPage({super.key, required this.hospitalId});

  @override
  _ScheduleTransplantationPageState createState() => _ScheduleTransplantationPageState();
}

class _ScheduleTransplantationPageState extends State<ScheduleTransplantationPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> successMatches = [];
  Map<String, TextEditingController> emailControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchSuccessMatches();
  }

  Future<void> _fetchSuccessMatches() async {
    try {
      final response = await userServices.getSuccessMatches(widget.hospitalId);
      setState(() {
        successMatches = response;
        emailControllers = {
          for (var match in successMatches) match['_id']: TextEditingController()
        };
      });
    } catch (e) {
      print("Error fetching success matches: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _scheduleTransplantation(String matchId) async {
    final emailBody = emailControllers[matchId]?.text ?? '';
    try {
      final response = await userServices.scheduleTransplantation(matchId, emailBody);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transplantation scheduled successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to schedule transplantation.')),
        );
      }
    } catch (e) {
      print("Error scheduling transplantation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Transplantation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: successMatches.isEmpty
          ? Center(
              child: Text(
                'There are no matches for scheduling transplantation.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: successMatches.length,
              itemBuilder: (context, index) {
                final match = successMatches[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Organ: ${match["organ"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(height: 6),
                        _buildSectionTitle("Donor Details"),
                        _buildInfoText("ID: ${match["donorid"]["_id"]}"),
                        _buildInfoText("Name: ${match["donorName"]}"),
                        _buildInfoText("Email: ${match["donorEmail"]}"),
                        SizedBox(height: 6),
                        _buildSectionTitle("Recipient Details"),
                        _buildInfoText("ID: ${match["receipientid"]["_id"]}"),
                        _buildInfoText("Name: ${match["receipientName"]}"),
                        _buildInfoText("Email: ${match["receipientEmail"]}"),
                        SizedBox(height: 10),
                        TextField(
                          controller: emailControllers[match['_id']],
                          decoration: InputDecoration(
                            labelText: 'Date And Time',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _scheduleTransplantation(match['_id']);
                            },
                            child: Text(
                              'Schedule Transplantation',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Divider(color: Colors.pinkAccent),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: Colors.black87),
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
