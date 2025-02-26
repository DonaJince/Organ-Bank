import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedbackForm(email: 'example@example.com'), // Provide the email parameter
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final String email;

  FeedbackForm({required this.email});
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _controller = TextEditingController();
  UserServices userServices = UserServices();

  Future<void> _submitFeedback() async {
  final String feedback = _controller.text;
  if (feedback.isNotEmpty) {
    try {
      final response = await userServices.submitFeedback(widget.email, feedback);
      
      // ✅ Check for "status": "success"
      if (response['status'] == 'success') { 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully.')),
        );
        _controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to submit feedback.')),
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
      SnackBar(content: Text('Please enter your feedback.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your feedback',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}