import 'package:flutter/material.dart';
import 'package:myapp/services/adminservices.dart';

class TransplantationResultsPage extends StatefulWidget {
  const TransplantationResultsPage({super.key});

  @override
  _TransplantationResultsPageState createState() => _TransplantationResultsPageState();
}

class _TransplantationResultsPageState extends State<TransplantationResultsPage> {
  AdminServices adminServices = AdminServices();
  List<Map<String, dynamic>> transplantationResults = [];

  @override
  void initState() {
    super.initState();
    _fetchTransplantationResults();
  }

  Future<void> _fetchTransplantationResults() async {
    try {
      final response = await adminServices.getTransplantations();
      setState(() {
        transplantationResults = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching transplantation results: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transplantation Results'),
      ),
      body: transplantationResults.isEmpty
          ? Center(child: Text('No transplantation results available.'))
          : ListView.builder(
              itemCount: transplantationResults.length,
              itemBuilder: (context, index) {
                final result = transplantationResults[index];
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
                          "Organ: ${result["organ"]}",
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
                        Text("ID: ${result["donorid"]["_id"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${result["donorid"]["name"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${result["donorid"]["email"]}",
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
                        Text("ID: ${result["receipientid"]["_id"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${result["receipientid"]["name"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${result["receipientid"]["email"]}",
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
                        Text("ID: ${result["hospitalid"]["_id"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${result["hospitalid"]["name"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text("Name: ${result["hospitalid"]["email"]}",
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        SizedBox(height: 6),
                        Text(
                          "Status: ${result["status"] == "transplantationsuccess" ? "Success" : "Failure"}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: result["status"] == "transplantationsuccess"
                                ? Colors.green
                                : Colors.red,
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
}