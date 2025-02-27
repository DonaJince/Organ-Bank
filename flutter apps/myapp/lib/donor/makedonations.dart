import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class MakeDonationsPage extends StatefulWidget {
  final String id;
  const MakeDonationsPage({super.key, required this.id});

  @override
  _MakeDonationsPageState createState() => _MakeDonationsPageState();
}

class _MakeDonationsPageState extends State<MakeDonationsPage> {
  UserServices userServices = UserServices();
  String? selectedOrgan;
  final Map<String, String> organs = {
    'Liver': 'Liver',
    'Kidney': 'Kidney',
    'Lung': 'Lung',
    'Pancreas': 'Pancreas',
    'Intestine': 'Intestine',
    'Blood & Plasma': 'Blood & Plasma',
    'Bone Marrow': 'Bone Marrow',
  };

  String? _bloodType;
  String? get bloodType => _bloodType;
  set bloodType(String? value) {
    _bloodType = value;
  }

  @override
  void initState() {
    super.initState();
    _fetchBloodType(); // Call _fetchBloodType on initialization
  }

  Future<void> _fetchBloodType() async {
    try {
      print("Fetching blood type for user ID: ${widget.id}");
      final response = await userServices.getBloodType(widget.id);
      print("Blood type response: $response");

      if (response != null && response.containsKey('bloodtype')) {
        setState(() {
          bloodType = response['bloodtype'];
        });
        print("Blood type fetched successfully: $bloodType");
      } else {
        print("Failed to fetch blood type: Invalid response format");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load blood type')),
        );
      }
    } catch (e) {
      print("Error fetching blood type: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> fetchMatchedReceipient(
      String donorId, String bloodType, String organ) async {
    try {
      print("Posting matched recipient request for Donor ID: $donorId");
      final response =
          await userServices.fetchMatchedReceipient(donorId, bloodType, organ);
      print("Matched recipient request response: $response");

      
    } catch (e) {
  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _submitDonation() async {
    if (selectedOrgan != null) {
      try {
        final response =
            await userServices.submitDonation(widget.id, [selectedOrgan!]);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Donation submitted successfully.')),
          );
          fetchMatchedReceipient(widget.id, bloodType!,
              selectedOrgan!); // Call fetchMatchedReceipient after successful donation
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit donation.')),
          );
        }
      } catch (e) {
        print("Error submitting donation: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an organ to donate.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Donation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select Organ to Donate:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: organs.keys.map((String key) {
                  return RadioListTile<String>(
                    title: Text(key),
                    value: key,
                    groupValue: selectedOrgan,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOrgan = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _submitDonation,
              child: Text('Donate'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MakeDonationsPage(id: 'user123'),
  ));
}
