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
  Map<String, bool> organs = {
    'Liver': false,
    'Kidney': false,
    'Lung': false,
    'Pancreas': false,
    'Intestine': false,
    'Blood & Plasma': false,
    'Bone Marrow': false,
  };

  Future<void> _submitDonation() async {
    List<String> selectedOrgans = organs.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedOrgans.isNotEmpty) {
      try {
        final response =
            await userServices.submitDonation(widget.id, selectedOrgans);
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
        SnackBar(content: Text('Please select at least one organ to donate.')),
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
              'Select Organs to Donate:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: organs.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: organs[key],
                    onChanged: (bool? value) {
                      setState(() {
                        organs[key] = value!;
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
