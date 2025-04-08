import 'package:flutter/material.dart';
import 'package:myapp/admin/getreceipient.dart';
import 'package:myapp/services/adminservices.dart';

class VerifyReceipientPage extends StatefulWidget {
  const VerifyReceipientPage({super.key});

  @override
  State<VerifyReceipientPage> createState() => _VerifyReceipientPageState();
}

class _VerifyReceipientPageState extends State<VerifyReceipientPage> {
  AdminServices adminServices = AdminServices();
  List<dynamic> receipientDetails = [];
  bool isLoading = true;

  Future<void> getReceipientDetails() async {
    try {
      var response = await adminServices.getReceipientDetails();
      setState(() {
        isLoading = false;
        receipientDetails = response.data;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
    getReceipientDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Recipients',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red[200],
        centerTitle: true,
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
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : receipientDetails.isEmpty
                ? Center(
                    child: Text(
                      'No pending recipients.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: receipientDetails.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        color: Colors.white.withOpacity(0.9),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          title: Text(
                            receipientDetails[index]['name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            receipientDetails[index]['email'],
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          trailing: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GetReceipientDetails(
                                    id: receipientDetails[index]["_id"],
                                  ),
                                ),
                              );

                              if (result == true) {
                                getReceipientDetails(); // Refresh the list
                              }
                            },
                            icon: Icon(Icons.verified, color: Colors.white),
                            label: Text('Verify',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
