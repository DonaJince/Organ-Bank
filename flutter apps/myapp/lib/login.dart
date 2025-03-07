import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/choose_role.dart';
import 'package:myapp/services/userservices.dart'; // Import the choose_role page

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserServices userservice = UserServices();

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification Pending'),
          content: Text(
              'Your account is pending verification. Please contact the admin.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loginUser(BuildContext context) async {
    var userData = jsonEncode({
      'email': _usernameController.text,
      'password': _passwordController.text,
    });
    try {
      final response = await userservice.loginUser(userData);
      print(response.data);
      if (response.data['user']['status'] == "pending") {
        _showSuccessDialog(context);
      } else if (response.data['user']['status'] == "approved" &&
          response.data['user']['usertype'] == "Donor") {
        Navigator.pushNamed(
          context,
          '/donorDashboard',
          arguments: response.data['user']['_id'], // Pass the user ID
        );
      } else if (response.data['user']['status'] == "approved" &&
          response.data['user']['usertype'] == "Receipient") {
        Navigator.pushNamed(
          context,
          '/receiverDashboard',
          arguments: response.data['user']['_id'], // Pass the user ID
        );
      } else if (response.data['user']['status'] == "approved" &&
          response.data['user']['usertype'] == "Hospital") {
        Navigator.pushNamed(
          context,
          '/hospitalDashboard',
          arguments: response.data['user']['_id'], // Pass the user ID
        );
      } else {
        print('Invalid user');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.red[200],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[100]!, Colors.red[200]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2.0, 2.0),
                        ),
                      ]),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_usernameController.text == 'admin' &&
                        _passwordController.text == '123') {
                      Navigator.pushNamed(context, '/adminDashboard');
                    } else {
                      loginUser(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to choose_role page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseRole()),
                    );
                  },
                  child: Text(
                    'New User? Sign Up',
                    style: TextStyle(color: Colors.red[900], fontSize: 16),
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

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
    );
  }
}