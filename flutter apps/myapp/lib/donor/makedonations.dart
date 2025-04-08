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
  bool isSubmitting = false;

  String? _bloodType;
  String? get bloodType => _bloodType;
  set bloodType(String? value) {
    _bloodType = value;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchBloodType();
    _fetchDonatedOrgans();
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
        _showSnackBar('Failed to load blood type');
      }
    } catch (e) {
      print("Error fetching blood type: $e");
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _fetchDonatedOrgans() async {
    try {
      print("Fetching donated organs for user ID: ${widget.id}");
      final response = await userServices.getDonatedOrgans(widget.id);
      print("Donated organs response: $response");

      if (response != null && response is List) {
        setState(() {
          donatedOrgans = List<String>.from(response);
          availableOrgans = organs.keys
              .where((organ) => !donatedOrgans.contains(organ))
              .toList();
        });
        print("Donated organs fetched successfully: $donatedOrgans");
        print("Available organs: $availableOrgans");
      } else {
        print("Failed to fetch donated organs: Invalid response format");
        _showSnackBar('Failed to load donated organs');
      }
    } catch (e) {
      print("Error fetching donated organs: $e");
      _showSnackBar('Error: $e');
    }
  }

  Future<void> fetchMatchedReceipient(
      String donorId, String bloodType, String organ) async {
    try {
      print("Posting matched recipient request for Donor ID: $donorId");
      final response = await userServices.fetchMatchedReceipient(
          donorId, bloodType, organ);
      print("Matched recipient request response: $response");
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _submitDonation() async {
    if (selectedOrgan == null) {
      _showSnackBar('Please select an organ to donate.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final response =
          await userServices.submitDonation(widget.id, [selectedOrgan!]);

      if (response.statusCode == 200) {
        _showSnackBar('Donation submitted successfully.');
        await fetchMatchedReceipient(widget.id, bloodType!, selectedOrgan!);

        setState(() {
          donatedOrgans.add(selectedOrgan!);
          availableOrgans.remove(selectedOrgan);
          selectedOrgan = null;
        });
      } else {
        _showSnackBar('Failed to submit donation.');
      }
    } catch (e) {
      print("Error submitting donation: $e");
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        isSubmitting = false;
      });
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
        backgroundColor: const Color.fromARGB(255, 114, 0, 38),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 176, 169)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Select Organ to Donate:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 113, 0, 0),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
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
                          activeColor: const Color.fromARGB(255, 111, 0, 37),
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
                    onPressed: isSubmitting ? null : _submitDonation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 104, 0, 35),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Donate',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
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
