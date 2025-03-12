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
        title: Text('Transplantation Results', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 87, 0, 29),
        centerTitle: true,
      ),
      body: transplantationResults.isEmpty
          ? Center(
              child: Text(
                'No transplantation results available.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: transplantationResults.length,
              itemBuilder: (context, index) {
                final result = transplantationResults[index];
                return _buildResultCard(result);
              },
            ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    bool isSuccess = result["status"] == "transplantationsuccess";

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 87, 0, 29),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle("Organ", Icons.healing, result["organ"], const Color.fromARGB(255, 255, 255, 255)),
            SizedBox(height: 6),
            _buildSection("Donor Details", Icons.person, result["donorid"]),
            _buildSection("Recipient Details", Icons.person_outline, result["receipientid"]),
            _buildSection("Hospital Details", Icons.local_hospital, result["hospitalid"]),
            Divider(color: Colors.black38),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isSuccess ? "Transplantation Successful" : "Transplantation Failed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, IconData icon, String? value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(width: 8),
        Text(
          "$title: ${value ?? 'N/A'}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, Map<String, dynamic>? data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color.fromARGB(255, 207, 0, 128), size: 22),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(201, 161, 0, 51)),
              ),
            ],
          ),
          Divider(),
          data != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetail("Name", data["name"]),
                    _buildDetail("Email", data["email"]),
                  ],
                )
              : Text(
                  "Data not available",
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, top: 4),
      child: Text(
        "$label: ${value ?? 'N/A'}",
        style: TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }
}
