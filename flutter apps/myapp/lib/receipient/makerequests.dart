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
  List<String> organs = [
    'Liver',
    'Kidney',
    'Lung',
    'Pancreas',
    'Intestine',
    'Blood & Plasma',
    'Bone Marrow'
  ];
  Map<String, String> hospitalMap = {};

  @override
  void initState() {
    super.initState();
    _fetchApprovedHospitals();
  }

  Future<void> _fetchApprovedHospitals() async {
    try {
      final response = await userServices.getApprovedHospitals();
      if (response['success']) {
        setState(() {
          hospitalMap = { for (var hospital in response['data']) hospital['name']: hospital['_id'] };
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load hospitals: ${response['message']}')),
        );
      }
    } catch (e) {
      print("Error fetching hospitals: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _submitRequest() async {
    if (selectedOrgan != null && selectedHospitalId != null) {
      try {
        print("Submitting Request - ID: ${widget.id}, Organ: $selectedOrgan, Hospital ID: $selectedHospitalId");
        final response = await userServices.submitRequest(
          widget.id, [selectedOrgan!], selectedHospitalId!);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request submitted successfully.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit request.')),
          );
        }
      } catch (e) {
        print("Error submitting request: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an organ and a hospital.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select an Organ to Request:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: organs.map((String organ) {
                  return RadioListTile<String>(
                    title: Text(organ),
                    value: organ,
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
            SizedBox(height: 10),
            Text(
              'Select Hospital:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
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
                  child: Text(hospital),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
