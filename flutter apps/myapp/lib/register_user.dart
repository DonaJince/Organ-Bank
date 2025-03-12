import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String _role = 'Donor';
  String _bloodType = 'A+';
  String _status = 'pending';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserServices userservice = UserServices();

  Future<void> _submitForm() async {
    var userdata = jsonEncode({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'bloodtype': _bloodType,
      'usertype': _role,
      'password': _passwordController.text,
      'status': _status
    });

    try {
      final response = await userservice.registerUser(userdata);
      _showSuccessDialog();
    } on DioException catch (e) {
      print(e.response);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Registration Successful'),
          content: Text('You have successfully registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.red)),
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
        title: Text('Register as Donor/Receiver', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 99, 0, 0),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 233, 193), const Color.fromARGB(255, 255, 250, 250)],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Register as Donor/Receiver',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 93, 0, 0)),
                    ),
                    SizedBox(height: 20),

                    _buildTextField(_nameController, 'Name'),
                    SizedBox(height: 15),

                    _buildTextField(_emailController, 'Email'),
                    SizedBox(height: 15),

                    _buildTextField(_phoneController, 'Phone Number'),
                    SizedBox(height: 15),

                    _buildDropdown(
                      value: _bloodType,
                      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      label: 'Blood Type',
                      onChanged: (String? newValue) {
                        setState(() {
                          _bloodType = newValue ?? _bloodType;
                        });
                      },
                    ),
                    SizedBox(height: 15),

                    _buildDropdown(
                      value: _role,
                      items: ['Donor', 'Receipient'],
                      label: 'Role',
                      onChanged: (String? newValue) {
                        setState(() {
                          _role = newValue ?? _role;
                        });
                      },
                    ),
                    SizedBox(height: 15),

                    _buildTextField(_passwordController, 'Create Password', obscureText: true),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 0, 0),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Register', style: TextStyle(color:const Color.fromARGB(255, 255, 255, 255),)),
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

  /// Reusable function to create text fields
  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Reusable function to create dropdown fields
  Widget _buildDropdown({required String value, required List<String> items, required String label, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(value: val, child: Text(val));
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
