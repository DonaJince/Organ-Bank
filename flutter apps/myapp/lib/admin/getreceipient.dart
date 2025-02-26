import 'package:flutter/material.dart';
import 'package:myapp/services/adminservices.dart';

class GetReceipientDetails extends StatefulWidget {
  const GetReceipientDetails({super.key, required this.id});
  final String id;

  @override
  State<GetReceipientDetails> createState() => _GetReceipientDetailsState();
}

class _GetReceipientDetailsState extends State<GetReceipientDetails> {
  AdminServices adminServices = AdminServices();
  Map<String, dynamic>? receipientDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReceipientDetails();
  }

  /// Fetch Recipient Details API Call
  Future<void> _fetchReceipientDetails() async {
    try {
      print("Fetching details for recipient ID: ${widget.id}");
      final response = await adminServices.getReceipientDetailsById(widget.id);
      setState(() {
        isLoading = false;
        receipientDetails = response.data;
      });
    } catch (e) {
      print("Error fetching recipient details: $e");
      setState(() {
        isLoading = false;
        receipientDetails = null;
      });
    }
  }

  /// Approve Recipient API Call
  Future<void> _approveReceipient() async {
    try {
      final response = await adminServices.approveReceipient(widget.id);
      if (response.statusCode == 200) {
        setState(() {
          receipientDetails?['status'] = "Approved";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Recipient Approved Successfully")));
        await _sendRegistrationApprovalEmail(receipientDetails?['email']);
      }
    } catch (e) {
      print("Error approving recipient: $e");
    }
  }

  /// Reject Recipient API Call
  Future<void> _rejectReceipient() async {
    try {
      final response = await adminServices.rejectReceipient(widget.id);
      if (response.statusCode == 200) {
        setState(() {
          receipientDetails?['status'] = "Rejected";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Recipient Rejected Successfully")));
        await _sendRegistrationRejectionEmail(receipientDetails?['email']);
      }
    } catch (e) {
      print("Error rejecting recipient: $e");
    }
  }

  /// Send Approval Email
  Future<void> _sendRegistrationApprovalEmail(String? email) async {
    try {
      final response = await adminServices.sendRegistrationApprovalEmail(email);
      if (response.statusCode == 200) {
        print("Approval email sent successfully");
      } else {
        print("Failed to send approval email");
      }
    } catch (e) {
      print("Error sending approval email: $e");
    }
  }

  /// Send Rejection Email
  Future<void> _sendRegistrationRejectionEmail(String? email) async {
    try {
      final response = await adminServices.sendRegistrationRejectionEmail(email);
      if (response.statusCode == 200) {
        print("Rejection email sent successfully");
      } else {
        print("Failed to send rejection email");
      }
    } catch (e) {
      print("Error sending rejection email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipient Details'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : receipientDetails == null
              ? Center(child: Text('Failed to load recipient details'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${receipientDetails?['name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Email: ${receipientDetails?['email'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Phone: ${receipientDetails?['phone'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Created At: ${receipientDetails?['createdAt'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Status: ${receipientDetails?['status'] ?? 'Pending'}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _approveReceipient,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: Text('Approve',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: _rejectReceipient,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: Text('Reject',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
