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
  List<String> donatedOrgans = [];
  List<String> availableOrgans = [];

  String? _bloodType;
  String? get bloodType => _bloodType;
  set bloodType(String? value) {
    _bloodType = value;
  }

  @override
  void initState() {
    super.initState();
    _fetchBloodType();
    _fetchDonatedOrgans();
  }

  Future<void> _fetchBloodType() async {
    try {
      final response = await userServices.getBloodType(widget.id);
      if (response != null && response.containsKey('bloodtype')) {
        setState(() {
          bloodType = response['bloodtype'];
        });
      }
    } catch (e) {
      _showSnackBar('Error fetching blood type: $e');
    }
  }

  Future<void> _fetchDonatedOrgans() async {
    try {
      final response = await userServices.getDonatedOrgans(widget.id);
      if (response != null && response is List) {
        setState(() {
          donatedOrgans = List<String>.from(response);
          availableOrgans = organs.keys
              .where((organ) => !donatedOrgans.contains(organ))
              .toList();
        });
      }
    } catch (e) {
      _showSnackBar('Error fetching donated organs: $e');
    }
  }

  Future<void> _submitDonation() async {
    if (selectedOrgan != null) {
      try {
        final response = await userServices.submitDonation(widget.id, [selectedOrgan!]);
        if (response.statusCode == 200) {
          _showSnackBar('Donation submitted successfully.');
        } else {
          _showSnackBar('Failed to submit donation.');
        }
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    } else {
      _showSnackBar('Please select an organ to donate.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Donation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent.shade100, Colors.redAccent.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Organ to Donate:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: availableOrgans.map((String key) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RadioListTile<String>(
                        title: Text(key, style: TextStyle(color: Colors.black)),
                        value: key,
                        groupValue: selectedOrgan,
                        activeColor: Colors.pinkAccent,
                        onChanged: (String? value) {
                          setState(() {
                            selectedOrgan = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Donate', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MakeDonationsPage(id: 'user123'),
  ));
}
