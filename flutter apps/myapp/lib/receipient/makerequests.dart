import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class MakeRequestPage extends StatefulWidget {
  final String id;
  const MakeRequestPage({super.key, required this.id});

  @override
  _MakeRequestPageState createState() => _MakeRequestPageState();
}

class _MakeRequestPageState extends State<MakeRequestPage> {
  UserServices userServices = UserServices();
  String? selectedOrgan;
  String? selectedHospital;
  String? selectedHospitalId;
  String? bloodType;
  List<String> organs = [
    'Liver',
    'Kidney',
    'Lung',
    'Pancreas',
    'Intestine',
    'Blood & Plasma',
    'Bone Marrow'
  ];
  List<String> requestedOrgans = [];
  List<String> availableOrgans = [];
  Map<String, String> hospitalMap = {};

  @override
  void initState() {
    super.initState();
    _fetchApprovedHospitals();
    _fetchBloodType();
    _fetchRequestedOrgans();
  }

  Future<void> _fetchApprovedHospitals() async {
    try {
      final response = await userServices.getApprovedHospitals();
      if (response['success']) {
        setState(() {
          hospitalMap = {
            for (var hospital in response['data']) hospital['name']: hospital['_id']
          };
        });
      }
    } catch (e) {
      _showSnackBar('Error fetching hospitals: $e');
    }
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

  Future<void> _fetchRequestedOrgans() async {
    try {
      final response = await userServices.getRequestedOrgans(widget.id);
      setState(() {
        requestedOrgans = response;
        availableOrgans = organs.where((organ) => !requestedOrgans.contains(organ)).toList();
      });
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _submitRequest() async {
    if (selectedOrgan != null && selectedHospitalId != null) {
      try {
        final response = await userServices.submitRequest(widget.id, [selectedOrgan!], selectedHospitalId!);
        if (response.statusCode == 200) {
          _showSnackBar('Request submitted successfully.');
        } else {
          _showSnackBar('Failed to submit request.');
        }
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    } else {
      _showSnackBar('Please select an organ and a hospital.');
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
        title: Text('Request an Organ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.redAccent.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select an Organ to Request:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: availableOrgans.map((String organ) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      title: Text(organ, style: TextStyle(color: Colors.black)),
                      value: organ,
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
            SizedBox(height: 10),
            Text(
              'Select Hospital:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              dropdownColor: Colors.white,
              value: selectedHospital,
              onChanged: (String? newValue) {
                setState(() {
                  selectedHospital = newValue;
                  selectedHospitalId = hospitalMap[newValue];
                });
              },
              items: hospitalMap.keys.map<DropdownMenuItem<String>>((String hospital) {
                return DropdownMenuItem<String>(
                  value: hospital,
                  child: Text(hospital, style: TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Submit Request', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
