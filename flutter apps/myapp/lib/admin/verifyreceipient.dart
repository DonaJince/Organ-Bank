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

  Future<void> getReceipientDetails() async {
    try {
      var response = await adminServices.getReceipientDetails();
      print(response);
      setState(() {
        receipientDetails = response.data;
      });
    } catch (e) {
      print(e);
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
        title: Text('Verify Recipients'),
      ),
      body: receipientDetails.isEmpty
          ? Center(child: Text('No pending recipients.'))
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: receipientDetails.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(receipientDetails[index]['name']),
                        subtitle: Text(receipientDetails[index]['email']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => GetReceipientDetails(
                                        id: receipientDetails[index]["_id"],
                                      )),
                            );
                          },
                          child: Text('Verify'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}