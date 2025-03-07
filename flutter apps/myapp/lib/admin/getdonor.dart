import 'package:flutter/material.dart';
import 'package:myapp/services/adminservices.dart';

class GetDonorDetails extends StatefulWidget {
  const GetDonorDetails({super.key, required this.id});
  final String id;

  @override
  State<GetDonorDetails> createState() => _GetDonorDetailsState();
}

class _GetDonorDetailsState extends State<GetDonorDetails> {
  AdminServices adminServices = AdminServices();
  Map<String, dynamic>? donorDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonorDetails();
  }

  Future<void> _fetchDonorDetails() async {
    try {
      print("Fetching details for donor ID: ${widget.id}");
      final response = await adminServices.getDonorDetailsById(widget.id);
      setState(() {
        isLoading = false;
        donorDetails = response.data;
      });
    } catch (e) {
      print("Error fetching donor details: $e");
      setState(() {
        isLoading = false;
        donorDetails = null;
      });
    }
  }

  Future<void> _approveDonor() async {
    try {
      final response = await adminServices.approveDonor(widget.id);
      if (response.statusCode == 200) {
        setState(() {
          donorDetails?['status'] = "Approved";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Donor Approved Successfully")));
        await _sendRegistrationApprovalEmail(donorDetails?['email']);
      }
    } catch (e) {
      print("Error approving donor: $e");
    }
  }

  Future<void> _rejectDonor() async {
    try {
      final response = await adminServices.rejectDonor(widget.id);
      if (response.statusCode == 200) {
        setState(() {
          donorDetails?['status'] = "Rejected";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Donor Rejected Successfully")));
        await _sendRegistrationRejectionEmail(donorDetails?['email']);
      }
    } catch (e) {
      print("Error rejecting donor: $e");
    }
  }

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
        title: Text('Donor Details'),
        backgroundColor: Colors.red[200],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.red[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : donorDetails == null
                ? Center(
                    child: Text(
                      'Failed to load donor details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
                : Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${donorDetails?['name'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Email: ${donorDetails?['email'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Phone: ${donorDetails?['phone'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height:10),
                          Text('Created At: ${donorDetails?['createdAt'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Status: ${donorDetails?['status'] ?? 'Pending'}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[400])),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: donorDetails?['status'] == 'Approved' ? null : _approveDonor,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                child: Text('Approve',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                              ElevatedButton(
                                onPressed: donorDetails?['status'] == 'Rejected' ? null : _rejectDonor,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                child: Text('Reject',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
