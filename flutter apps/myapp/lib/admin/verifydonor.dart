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
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: donorDetails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(donorDetails[index]['name']),
                  subtitle: Text(donorDetails[index]['email']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => GetDonorDetails(
                                  id: donorDetails[index]["_id"],
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
