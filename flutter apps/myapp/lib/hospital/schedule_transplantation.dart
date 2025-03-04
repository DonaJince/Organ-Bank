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
        title: Text('Schedule Transplantation'),
      ),
      body: successMatches.isEmpty
          ? Center(child: Text('There are no matches for scheduling transplantation.'))
          : ListView.builder(
              itemCount: successMatches.length,
              itemBuilder: (context, index) {
                final match = successMatches[index];
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
                            _scheduleTransplantation(match['_id']);
                          },
                          child: Text('Schedule Transplantation'),
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