import 'package:flutter/material.dart';
import 'package:myapp/services/adminservices.dart';
import 'package:myapp/admin/gethospital.dart';

class VerifyHospitalPage extends StatefulWidget {
  const VerifyHospitalPage({super.key});

  @override
  State<VerifyHospitalPage> createState() => _VerifyHospitalPageState();
}

class _VerifyHospitalPageState extends State<VerifyHospitalPage> {
  AdminServices adminServices = AdminServices();
  List<dynamic> hospitalDetails = [];

  Future<void> getHospitalDetails() async {
    try {
      var response = await adminServices.getHospitalDetails();
      setState(() {
        hospitalDetails = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    super.initState();
    getHospitalDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Hospitals'),
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
        child: hospitalDetails.isEmpty
            ? Center(
                child: Text(
                  'No pending hospitals.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: hospitalDetails.length,
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
                        hospitalDetails[index]['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        hospitalDetails[index]['email'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => GetHospitalDetails(
                                      id: hospitalDetails[index]["_id"],
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
