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
        title: Text('Update Test Result'),
      ),
      body: testScheduledMatches.isEmpty
          ? Center(child: Text('There are no test results to update.'))
          : ListView.builder(
              itemCount: testScheduledMatches.length,
              itemBuilder: (context, index) {
                final match = testScheduledMatches[index];
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
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _updateTestResult(match['_id'], 'failure');
                              },
                              child: Text('Failure'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
}