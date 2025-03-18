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
              donation['availability_status'] = newStatus;
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
        title: Text('Donation Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 104, 0, 35),
      ),
      body: donations.isEmpty
          ? Center(
              child: Text(
                'No donations made',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            )
          : ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  elevation: 5,
                  color: Colors.pink[50],
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      'Organ: ${donation['organ']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 103, 0, 0)),
                    ),
                    subtitle: Text(
                      'Status: ${donation['availability_status'] == 'available' ? 'Available' : 'Not Available'}',
                      style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 139, 0, 46)),
                    ),
                    trailing: donation['donation_status'] != 'pending'
                        ? Text(
                            '${donation['donation_status']}',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              String newStatus = donation['availability_status'] == 'available' ? 'not available' : 'available';
                              _toggleDonationStatus(donation['_id'], newStatus);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: donation['availability_status'] == 'available' ? const Color.fromARGB(255, 149, 11, 11) : Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                            child: Text(
                              donation['availability_status'] == 'available' ? 'Set as Not Available' : 'Set as Available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.white,
    );
  }
}
