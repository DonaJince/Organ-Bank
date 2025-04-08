import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeedbackForm(userId: 'example@example.com'),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final String userId;

  FeedbackForm({required this.userId});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserServices userServices = UserServices();

  Future<void> _submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String feedback = _controller.text.trim();
      try {
        final response = await userServices.submitFeedback(widget.userId, feedback);
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Feedback submitted successfully.'), backgroundColor: Colors.green),
          );
          _controller.clear();
          Navigator.pop(context); // Close the feedback form after submission
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to submit feedback.'), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 105, 180),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: const Color.fromARGB(255, 255, 255, 255), // Light background for a soft look
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'We value your feedback!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 109, 159)),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter your feedback',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your feedback';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 15, 117, 177),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}