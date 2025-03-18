import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';

class ViewRequestStatusPage extends StatefulWidget {
  final String receiverId;

  const ViewRequestStatusPage({super.key, required this.receiverId});

  @override
  _ViewRequestStatusPageState createState() => _ViewRequestStatusPageState();
}

class _ViewRequestStatusPageState extends State<ViewRequestStatusPage> {
  final UserServices userServices = UserServices();
  late Future<List<Map<String, dynamic>>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _fetchRequests();
  }

  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    try {
      final response = await userServices.getRequests(widget.receiverId);
      print("API Response: $response");
      return response != null ? List<Map<String, dynamic>>.from(response) : [];
    } catch (e) {
      print("Error fetching requests: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch requests. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );

      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 99, 0, 7), // Pinkish-Red Header
        elevation: 0,
      ),
      body: Container(
        color: Colors.pink.shade50, // Light Pink Background
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.pink));
            } else if (snapshot.hasError) {
              return _buildErrorUI();
            }

            final requests = snapshot.data ?? [];

            if (requests.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildRequestCard(request);
              },
            );
          },
        ),
      ),
    );
  }

  /// 📌 UI for Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 50, color: const Color.fromARGB(255, 105, 0, 17)),
          SizedBox(height: 10),
          Text(
            'No requests found.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 115, 0, 38)),
          ),
        ],
      ),
    );
  }

  /// 📌 UI for Error State
  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
          SizedBox(height: 10),
          Text(
            'Error loading requests.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  /// 📌 Card UI for Requests
  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 5,
      shadowColor: Colors.pink.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white, // White background for contrast
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          'Organ: ${request['organ']}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: const Color.fromARGB(255, 137, 0, 0)),
        ),
        subtitle: Text(
          'Status: ${request['requested_status']}',
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.favorite, color: const Color.fromARGB(255, 81, 0, 0)),
      ),
    );
  }
}
