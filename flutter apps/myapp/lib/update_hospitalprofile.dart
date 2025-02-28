import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class UpdateHospitalProfilePage extends StatefulWidget {
  final String id;
  const UpdateHospitalProfilePage({super.key, required this.id});

  @override
  State<UpdateHospitalProfilePage> createState() =>
      _UpdateHospitalProfilePageState();
}

class _UpdateHospitalProfilePageState extends State<UpdateHospitalProfilePage> {
  UserServices userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _otherPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await userServices.getHospitalDetailsByid(widget.id);

      print("Response Data: ${response.data}"); // Debugging

      userDetails = response.data;

      print("Name Type: ${userDetails?["name"].runtimeType}");
      print("Email Type: ${userDetails?["email"].runtimeType}");
      print("Phone Type: ${userDetails?["phone"].runtimeType}");

      _nameController.text = userDetails?["name"]?.toString() ?? "";
      _emailController.text = userDetails?["email"]?.toString() ?? "";
      _phoneController.text =
          userDetails?["phone"]?.toString() ?? ""; // Convert phone to String
      _locationController.text = userDetails?["location"]?.toString() ?? "";
      _otherPhoneController.text = userDetails?["otherphno"]?.toString() ?? "";

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await userServices.updateHospitalProfile(
          widget.id,
          _nameController.text,
          _phoneController.text,
          _locationController.text,
          _otherPhoneController.text,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile Updated Successfully")),
          );
        } else {
          var errorMessage =
              jsonDecode(response.data)["message"] ?? "Update failed";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $errorMessage")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
              ? Center(child: Text('Failed to load details'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          readOnly: true,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(labelText: 'Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(labelText: 'Location'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your location';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _otherPhoneController,
                          decoration: InputDecoration(labelText: 'Other Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your other phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle:
                                TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          child: Text('Update Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
