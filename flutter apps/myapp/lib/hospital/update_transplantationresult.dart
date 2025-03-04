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

  Future<void> _updateTransplantResult(String matchId, String transplantResult) async {
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: transplantScheduledMatches.length,
              itemBuilder: (context, index) {
                final match = transplantScheduledMatches[index];
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
                                _updateTransplantResult(match['_id'], 'success');
                              },
                              child: Text('Success'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _updateTransplantResult(match['_id'], 'failure');
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