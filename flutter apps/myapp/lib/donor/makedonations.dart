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

  Future<void> _submitDonation() async {
    if (selectedOrgan != null) {
      try {
        final response =
            await userServices.submitDonation(widget.id, [selectedOrgan!]);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Donation submitted successfully.')),
          );
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
