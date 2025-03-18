import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class UpdateUserProfilePage extends StatefulWidget {
  final String id;
  const UpdateUserProfilePage({super.key, required this.id});

  @override
  State<UpdateUserProfilePage> createState() => _UpdateUserProfilePageState();
}

class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  UserServices userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await userServices.getUserDetailsById(widget.id);

      print("Response Data: ${response.data}"); // Debugging

      userDetails = response.data;

      print("Name Type: ${userDetails?["name"].runtimeType}");
      print("Email Type: ${userDetails?["email"].runtimeType}");
      print("Phone Type: ${userDetails?["phone"].runtimeType}");

      _nameController.text = userDetails?["name"]?.toString() ?? "";
      _emailController.text = userDetails?["email"]?.toString() ?? "";
      _phoneController.text = userDetails?["phone"]?.toString() ?? "";  // Convert phone to String

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
        final response = await userServices.updateUserProfile(
          widget.id,
          _nameController.text,
          _phoneController.text,
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
        title: Text('Update Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 94, 0, 0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 192, 192)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
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
                                return 'Please enter your name';
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
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 98, 0, 0),
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