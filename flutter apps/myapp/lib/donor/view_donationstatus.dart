import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ViewDonationStatusPage extends StatefulWidget {
  final String donorId;

  const ViewDonationStatusPage({super.key, required this.donorId});

  @override
  _ViewDonationStatusPageState createState() => _ViewDonationStatusPageState();
}

class _ViewDonationStatusPageState extends State<ViewDonationStatusPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> donations = [];

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    try {
      final response = await userServices.getDonations(widget.donorId);
      print("API Response: $response");

      setState(() {
        donations = response != null ? List<Map<String, dynamic>>.from(response) : [];
      });
    } catch (e) {
      print("Error fetching donations: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _toggleDonationStatus(String donationId, String newStatus) async {
    try {
      final response = await userServices.updateDonationStatus(donationId, newStatus);

      if (response.statusCode == 200) {
        setState(() {
          donations = donations.map((donation) {
            if (donation['_id'] == donationId) {
              donation['availability_status'] = newStatus; // Update locally
            }
            return donation;
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update donation status.')),
        );
      }
    } catch (e) {
      print("Error updating donation status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Status'),
      ),
      body: donations.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Organ: ${donation['organ']}'),
                    subtitle: Text(
                      'Status: ${donation['availability_status'] == 'available' ? 'Available' : 'Not Available'}',
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        String newStatus = donation['availability_status'] == 'available' ? 'not available' : 'available';
                        _toggleDonationStatus(donation['_id'], newStatus);
                      },
                      child: Text(
                        donation['availability_status'] == 'available' ? 'Set as Not Available' : 'Set as Available',
                        style: TextStyle(color: donation['availability_status'] == 'available' ? Colors.red : Colors.green),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
