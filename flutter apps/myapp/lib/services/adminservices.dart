import 'package:dio/dio.dart';

class AdminServices {
  final dio = Dio();
  final String baseUrl = 'http://10.0.2.2:3000/api/';

  getDonorDetails() async {
    final response = await dio.get(
      "${baseUrl}pendingDonor",
    );
    return response;
  }

  getReceipientDetails() async {
    final response = await dio.get(
      "${baseUrl}pendingReceipient",
    );
    return response;
  }

  getHospitalDetails() async {
    final response = await dio.get(
      "${baseUrl}pendingHospital",
    );
    return response;
  }
  getDonorDetailsById(String id) async {
    final response =
        await dio.post("${baseUrl}getDonorDetailsById", data: {"_id": id});
    return response;
  }

  getReceipientDetailsById(String id) async {
    final response =
        await dio.post("${baseUrl}getReceipientDetailsById", data: {"_id": id});
    return response;
  }

  getHospitalDetailsById(String id) async {
    try {
      final response = await dio.post(
        "${baseUrl}getHospitalDetailsById",
        data: {"_id": id},
      );
      return response;
    } catch (e) {
      throw Exception("Failed to fetch hospital details: $e");
    }
  }

  approveDonor(String id) async {
    final response =
        await dio.post("${baseUrl}approveDonor", data: {"_id": id});
    return response;
  }

  rejectDonor(String id) async {
    final response = await dio.post("${baseUrl}rejectDonor", data: {"_id": id});
    return response;
  }

  approveReceipient(String id) async {
    final response =
        await dio.post("${baseUrl}approveReceipient", data: {"_id": id});
    return response;
  }

  rejectReceipient(String id) async {
    final response =
        await dio.post("${baseUrl}rejectReceipient", data: {"_id": id});
    return response;
  }

  approveHospital(String id) async {
    final response =
        await dio.post("${baseUrl}approveHospital", data: {"_id": id});
    return response;
  }

  rejectHospital(String id) async {
    final response = await dio.post("${baseUrl}rejectHospital", data: {"_id": id});
    return response;
  }

sendRegistrationApprovalEmail(String? email) async {
    return await dio
        .post("${baseUrl}sendRegistrationApprovalEmail", data: {"email": email});
  }

sendRegistrationRejectionEmail(String? email) async {
    return await dio
        .post("${baseUrl}sendRegistrationRejectionEmail", data: {"email": email});
  }
}
