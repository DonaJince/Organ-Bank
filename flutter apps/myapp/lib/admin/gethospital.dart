import 'package:flutter/material.dart';
import 'package:myapp/services/adminservices.dart';

class GetHospitalDetails extends StatefulWidget {
  const GetHospitalDetails({super.key, required this.id});
  final String id;

  @override
  State<GetHospitalDetails> createState() => _GetHospitalDetailsState();
}

class _GetHospitalDetailsState extends State<GetHospitalDetails> {
  AdminServices adminServices = AdminServices();
  Map<String, dynamic>? hospitalDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHospitalDetails();
  }

  Future<void> _fetchHospitalDetails() async {
    try {
      print("Fetching details for hospital ID: ${widget.id}");
      final response = await adminServices.getHospitalDetailsById(widget.id);
      setState(() {
        isLoading = false;
        hospitalDetails = response.data;
      });
    } catch (e) {
      print("Error fetching hospital details: $e");
      setState(() {
        isLoading = false;
        hospitalDetails = null;
      });
    }
  }

  Future<void> _approveHospital() async {
    try {
      final response = await adminServices.approveHospital(widget.id);
      if (response.statusCode == 200) {
        setState(() {
          hospitalDetails?['userid']['status'] = "Approved";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hospital Approved Successfully")));
        await _sendRegistrationApprovalEmail(hospitalDetails?['userid']['email']);
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error approving hospital: $e");
    }
  }

  Future<void> _rejectHospital() async {
    try {
      final response = await adminServices.rejectHospital(widget.id);
      if (response.statusCode == 200) {
        setState(() {
          hospitalDetails?['userid']['status'] = "Rejected";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hospital Rejected Successfully")));
        await _sendRegistrationRejectionEmail(hospitalDetails?['userid']['email']);
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error rejecting hospital: $e");
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
        title: Text('Hospital Details'),
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
            : hospitalDetails == null
                ? Center(
                    child: Text(
                      'Failed to load hospital details',
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
                          Text('Name: ${hospitalDetails?['userid']['name'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Email: ${hospitalDetails?['userid']['email'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Phone: ${hospitalDetails?['userid']['phone'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Alternate Phone: ${hospitalDetails?['otherphno'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Location: ${hospitalDetails?['location'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Created At: ${hospitalDetails?['userid']['createdAt'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text('Status: ${hospitalDetails?['userid']['status'] ?? 'Pending'}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[400])),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: hospitalDetails?['userid']['status'] == 'Approved' ? null : _approveHospital,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                child: Text('Approve',
                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                              ElevatedButton(
                                onPressed: hospitalDetails?['userid']['status'] == 'Rejected' ? null : _rejectHospital,
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
