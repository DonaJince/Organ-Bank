import 'package:flutter/material.dart';
import 'package:myapp/admin/gethospital.dart';
import 'package:myapp/services/adminservices.dart';

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
      print(response);
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
      ),
      body: hospitalDetails.isEmpty
          ? Center(child: Text('No pending hospitals.'))
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: hospitalDetails.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(hospitalDetails[index]['name']),
                        subtitle: Text(hospitalDetails[index]['email']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => GetHospitalDetails(
                                        id: hospitalDetails[index]["_id"],
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