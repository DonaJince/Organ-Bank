import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:myapp/services/adminservices.dart';

class GenerateReportsPage extends StatefulWidget {
  @override
  _GenerateReportsPageState createState() => _GenerateReportsPageState();
}

class _GenerateReportsPageState extends State<GenerateReportsPage> {
  AdminServices adminServices = AdminServices();
  List<Map<String, dynamic>> transplantationData = [];

  @override
  void initState() {
    super.initState();
    _fetchTransplantationData();
  }

  Future<void> _fetchTransplantationData() async {
    try {
      final response = await adminServices.getTodayTransplantationData();
      setState(() {
        transplantationData = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching transplantation data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Transplantation Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
              pw.SizedBox(height: 20),
              ...transplantationData.asMap().entries.map<pw.Widget>((entry) {
                int index = entry.key + 1;
                Map<String, dynamic> data = entry.value;
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Transplantation #$index', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                    pw.SizedBox(height: 10),
                    pw.Text('ID: ${data["_id"]}', style: pw.TextStyle(fontSize: 16, color: PdfColors.blue)),
                    pw.Text('Donor Name: ${data["donorName"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Donor Email: ${data["donorEmail"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Recipient Name: ${data["receipientName"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Recipient Email: ${data["receipientEmail"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Hospital Name: ${data["hospitalName"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Hospital Email: ${data["hospitalEmail"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Organ: ${data["organ"]}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('Status: ${data["status"] == "transplantationsuccess" ? "Success" : "Failure"}', style: pw.TextStyle(fontSize: 16, color: data["status"] == "transplantationsuccess" ? PdfColors.green : PdfColors.red)),
                    pw.SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Reports'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _generatePdf,
          child: Text('Download Report as PDF'),
        ),
      ),
    );
  }
}