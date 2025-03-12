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
        title: Text(
          'Update Transplantation Result',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 75, 0, 25),
      ),
      body: transplantScheduledMatches.isEmpty
          ? Center(
              child: Text(
                'There are no transplantation results to update.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: transplantScheduledMatches.length,
              itemBuilder: (context, index) {
                final match = transplantScheduledMatches[index];
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
                  
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _updateTransplantationResult(match['_id'], 'success');
                              },
                              child: Text(
                                'Success',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _updateTransplantationResult(match['_id'], 'failure');
                              },
                              child: Text(
                                'Failure',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
}
