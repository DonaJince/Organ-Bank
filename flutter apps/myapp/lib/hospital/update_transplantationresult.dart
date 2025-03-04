import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class UpdateTransplantationResultPage extends StatefulWidget {
  final String hospitalId;

  const UpdateTransplantationResultPage({super.key, required this.hospitalId});

  @override
  _UpdateTransplantationResultPageState createState() => _UpdateTransplantationResultPageState();
}

class _UpdateTransplantationResultPageState extends State<UpdateTransplantationResultPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> transplantScheduledMatches = [];

  @override
  void initState() {
    super.initState();
    _fetchTransplantScheduledMatches();
  }

  Future<void> _fetchTransplantScheduledMatches() async {
    try {
      final response = await userServices.getTransplantationScheduledMatches(widget.hospitalId);
      setState(() {
        transplantScheduledMatches = response;
      });
    } catch (e) {
      print("Error fetching transplant scheduled matches: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateTransplantationResult(String matchId, String transplantResult) async {
    try {
      final response = await userServices.updateTransplantationResult(matchId, transplantResult);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transplant result updated successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update transplant result.')),
        );
      }
    } catch (e) {
      print("Error updating transplant result: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Transplantation Result'),
      ),
      body: transplantScheduledMatches.isEmpty
          ? Center(child: Text('There are no transplantation results to update.'))
          : ListView.builder(
              itemCount: transplantScheduledMatches.length,
              itemBuilder: (context, index) {
                final match = transplantScheduledMatches[index];
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
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${match["donorName"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Email: ${match["donorEmail"]}",
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
                        Text("Email: ${match["receipientEmail"]}",
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
                        Text("Email: ${match["hospitalEmail"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _updateTransplantationResult(match['_id'], 'success');
                              },
                              child: Text('Success'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _updateTransplantationResult(match['_id'], 'failure');
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