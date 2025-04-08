import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ScheduleTransplantationPage extends StatefulWidget {
  final String hospitalId;

  const ScheduleTransplantationPage({super.key, required this.hospitalId});

  @override
  _ScheduleTransplantationPageState createState() =>
      _ScheduleTransplantationPageState();
}

class _ScheduleTransplantationPageState
    extends State<ScheduleTransplantationPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> successMatches = [];
  Map<String, TextEditingController> emailControllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchSuccessMatches();
  }

  Future<void> _fetchSuccessMatches() async {
    try {
      final response = await userServices.getSuccessMatches(widget.hospitalId);

      if (!mounted) return; // Prevent updating UI if the widget is disposed

      setState(() {
        successMatches = response;
        emailControllers = {
          for (var match in successMatches)
            match['_id']: TextEditingController()
        };
      });
    } catch (e) {
      if (!mounted) return; // Prevent error if the widget is unmounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _scheduleTransplantation(String matchId) async {
  if (_formKey.currentState?.validate() ?? false) {
    final emailBody = emailControllers[matchId]?.text.trim() ?? '';
    if (emailBody.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Date and time cannot be empty.')),
      );
      return;
    }

    try {
      final response =
          await userServices.scheduleTransplantation(matchId, emailBody);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transplantation scheduled successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        await _fetchSuccessMatches(); // 🔁 Refresh the page to update list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule transplantation.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Transplantation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 0, 33),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.red[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: successMatches.isEmpty
            ? Center(
                child: Text(
                  'There are no matches for scheduling transplantation.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : Form(
                key: _formKey,
                child: ListView.builder(
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
                            _buildInfoText(
                                "ID: ${match["receipientid"]["_id"]}"),
                            _buildInfoText("Name: ${match["receipientName"]}"),
                            _buildInfoText(
                                "Email: ${match["receipientEmail"]}"),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: emailControllers[match['_id']],
                              decoration: InputDecoration(
                                labelText: 'Date And Time',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the date and time for the transplantation';
                                }
                                return null;
                              },
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
              ),
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
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
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
    emailControllers.clear();
    successMatches.clear();
    super.dispose();
  }
}