import 'package:flutter/material.dart';
import 'package:myapp/admin/getdonor.dart';
import 'package:myapp/services/adminservices.dart';

class VerifyDonorPage extends StatefulWidget {
  const VerifyDonorPage({super.key});

  @override
  State<VerifyDonorPage> createState() => _VerifyDonorPageState();
}

class _VerifyDonorPageState extends State<VerifyDonorPage> {
  AdminServices adminServices = AdminServices();
  List<dynamic> donorDetails = [];

  Future<void> getDonorDetails() async {
    try {
      var response = await adminServices.getDonorDetails();
      print(response);
      setState(() {
        donorDetails = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    super.initState();
    getDonorDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Donors'),
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
        child: donorDetails.isEmpty
            ? Center(
                child: Text(
                  'No pending donors.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: donorDetails.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    color: Colors.white.withOpacity(0.9),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(
                        donorDetails[index]['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        donorDetails[index]['email'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => GetDonorDetails(
                                      id: donorDetails[index]["_id"],
                                    )),
                          );
                        },
                        icon: Icon(Icons.verified, color: Colors.white),
                        label: Text('Verify', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
