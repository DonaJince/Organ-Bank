import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class UpdateTestResultPage extends StatefulWidget {
  final String hospitalId;

  const UpdateTestResultPage({super.key, required this.hospitalId});

  @override
  _UpdateTestResultPageState createState() => _UpdateTestResultPageState();
}

class _UpdateTestResultPageState extends State<UpdateTestResultPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> testScheduledMatches = [];

  @override
  void initState() {
    super.initState();
    _fetchTestScheduledMatches();
  }

  Future<void> _fetchTestScheduledMatches() async {
    try {
      final response = await userServices.getTestScheduledMatches(widget.hospitalId);
      setState(() {
        testScheduledMatches = response;
      });
    } catch (e) {
      print("Error fetching test scheduled matches: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateTestResult(String matchId, String testResult) async {
    try {
      final response = await userServices.updateTestResult(matchId, testResult);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test result updated successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update test result.')),
        );
      }
    } catch (e) {
      print("Error updating test result: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Test Result', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: testScheduledMatches.isEmpty
          ? Center(child: Text('There are no test results to update.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)))
          : ListView.builder(
              itemCount: testScheduledMatches.length,
              itemBuilder: (context, index) {
                final match = testScheduledMatches[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.pink[50],
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
                            color: Colors.redAccent,
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
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _updateTestResult(match['_id'], 'success');
                              },
                              child: Text('Success'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _updateTestResult(match['_id'], 'failure');
                              },
                              child: Text('Failure'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
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
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
          ),
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
}
