import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class RegisterHospital extends StatefulWidget {
  @override
  _RegisterHospitalState createState() => _RegisterHospitalState();
}

class _RegisterHospitalState extends State<RegisterHospital> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  final String _role = 'Hospital';
  final String _status = 'pending';
  final UserServices userservice = UserServices();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      var hospitalData = jsonEncode({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'usertype': _role,
        'password': _passwordController.text,
        'location': _locationController.text.trim(),
        'otherphno': _contactController.text.trim(),
        'status': _status,
      });

      try {
        final response = await userservice.registerUser(hospitalData);
        _showSuccessDialog();
      } on DioException catch (e) {
        print(e.response);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Registration Successful'),
          content: Text('Hospital registration completed successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Navigate back to the previous screen
              },
              child: Text('OK', style: TextStyle(color: const Color.fromARGB(255, 111, 7, 0))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Registration', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 81, 0, 0),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 244, 248), const Color.fromARGB(251, 255, 228, 228)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Hospital Registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
                      ),
                      SizedBox(height: 20),

                      _buildTextField(_nameController, 'Hospital Name', validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your hospital name';
                        }
                        return null;
                      }),
                      SizedBox(height: 15),

                      _buildTextField(_emailController, 'Email', validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }),
                      SizedBox(height: 15),

                      _buildTextField(_phoneController, 'Phone Number', validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      }),
                      SizedBox(height: 15),

                      _buildTextField(_passwordController, 'Create Password', obscureText: true, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        /*if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }*/
                        return null;
                      }),
                      SizedBox(height: 15),

                      _buildTextField(_locationController, 'Location', validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      }),
                      SizedBox(height: 15),

                      _buildTextField(_contactController, 'Alternate Contact Number', validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact details';
                        }
                        return null;
                      }),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 81, 0, 0),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Register', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable function to create text fields
  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator,
    );
  }
}