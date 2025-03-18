import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class UpdateHospitalProfilePage extends StatefulWidget {
  final String id;
  const UpdateHospitalProfilePage({super.key, required this.id});

  @override
  State<UpdateHospitalProfilePage> createState() => _UpdateHospitalProfilePageState();
}

class _UpdateHospitalProfilePageState extends State<UpdateHospitalProfilePage> {
  UserServices userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? hospitalDetails;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _otherPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchHospitalDetails();
  }

  Future<void> fetchHospitalDetails() async {
    try {
      final response = await userServices.getHospitalDetailsByid(widget.id);

      print("Response Data: ${response.data}"); // Debugging

      hospitalDetails = response.data;

      _nameController.text = hospitalDetails?["name"]?.toString() ?? "";
      _emailController.text = hospitalDetails?["email"]?.toString() ?? "";
      _phoneController.text = hospitalDetails?["phone"]?.toString() ?? "";
      _locationController.text = hospitalDetails?["location"]?.toString() ?? "";
      _otherPhoneController.text = hospitalDetails?["otherphno"]?.toString() ?? "";

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching hospital details: $e");
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
          var errorMessage = jsonDecode(response.data)["message"] ?? "Update failed";
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
        title: Text('Update Hospital Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 94, 0, 0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 190, 190)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hospitalDetails == null
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
                            decoration: InputDecoration(
                              labelText: 'Name',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the hospital name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'Location',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the location';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _otherPhoneController,
                            decoration: InputDecoration(
                              labelText: 'Other Phone',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the other phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 86, 0, 0),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                textStyle: TextStyle(fontSize: 18, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Update Profile', style: TextStyle(color: Colors.white)),
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
