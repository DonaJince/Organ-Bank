import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ViewRequestStatusPage extends StatefulWidget {
  final String receiverId;

  const ViewRequestStatusPage({super.key, required this.receiverId});

  @override
  _ViewRequestStatusPageState createState() => _ViewRequestStatusPageState();
}

class _ViewRequestStatusPageState extends State<ViewRequestStatusPage> {
  UserServices userServices = UserServices();
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final response = await userServices.getRequests(widget.receiverId);
      print("API Response: $response");

      setState(() {
        requests =
            response != null ? List<Map<String, dynamic>>.from(response) : [];
      });
    } catch (e) {
      print("Error fetching requests: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Status'),
      ),
      body: requests.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Organ: ${request['organ']}'),
                    subtitle: Text('Status: ${request['requested_status']}'),
                  ),
                );
              },
            ),
    );
  }
}
