import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ComplaintForm(userId: 'example@example.com'), // Provide the email parameter
    );
  }
}

class ComplaintForm extends StatefulWidget {
  final String userId;

  ComplaintForm({required this.userId});
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final TextEditingController _controller = TextEditingController();
  UserServices userServices = UserServices();

  Future<void> _submitComplaint() async {
  final String complaint = _controller.text;
  if (complaint.isNotEmpty) {
    try {
      final response = await userServices.submitComplaint(widget.userId, complaint);
      
      // ✅ Check for "status": "success"
      if (response['status'] == 'success') { 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted successfully.')),
        );
        _controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to submit complaint.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter your complaint.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your complaint',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitComplaint,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}