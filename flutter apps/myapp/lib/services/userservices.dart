import 'package:dio/dio.dart';

class UserServices {
  final dio = Dio();
  final String baseUrl = 'http://10.0.2.2:3000/api/';

  final options = Options(headers: {
    "Content-Type": "application/json",
  });

  registerUser(String userdata) async {
    final response = await dio.post("${baseUrl}register", data: userdata);
    return response;
  }

  loginUser(String userdata) async {
    final response = await dio.post("${baseUrl}login", data: userdata);
    return response;
  }

  getUserDetailsById(String id) async {
    return await dio.get("${baseUrl}getUserDetailsById/$id", options: options);
  }

  updateUserProfile(String id, String name, String phone) async {
    return await dio.put("${baseUrl}updateUserProfile/$id",
        data: {
          "name": name,
          "phone": phone,
        },
        options: options);
  }

  submitFeedback(String email, String feedback) async {
    final url = '$baseUrl/submitFeedback'; // Ensure correct API endpoint
    try {
      final response = await dio.post(
        url,
        data: {'email': email, 'feedback': feedback},
        options: Options(headers: {
          "Content-Type": "application/json"
        }), // Ensure correct headers
      );

      print("Response: ${response.data}"); // Debugging
      return response.data;
    } catch (e) {
      print("Error submitting feedback: $e"); // Debugging
      return {'status': 'error', 'message': 'Failed to submit feedback'};
    }
  }

  submitComplaint(String email, String complaint) async {
    final url = '$baseUrl/submitComplaint'; // Ensure correct API endpoint
    try {
      final response = await dio.post(
        url,
        data: {'email': email, 'complaint': complaint},
        options: Options(headers: {
          "Content-Type": "application/json"
        }), // Ensure correct headers
      );

      print("Response: ${response.data}"); // Debugging
      return response.data;
    } catch (e) {
      print("Error submitting complaint: $e"); // Debugging
      return {'status': 'error', 'message': 'Failed to submit complaint'};
    }
  }

  submitDonation(String donorId, List<String> organs) async {
    return await dio.post("${baseUrl}submitDonation", data: {
      "donorid": donorId, // Use "donorid" instead of "donorId"
      "organs": organs,
    });
  }

  submitRequest(
      String receipientId, List<String> organs, String hospitalId) async {
    return await dio.post("${baseUrl}submitRequest", data: {
      "receipientid": receipientId,
      "organs": organs,
      "hospitalid": hospitalId, // ✅ Send hospital ID instead of name
    });
  }

  getApprovedHospitals() async {
    final response =
        await dio.get("${baseUrl}getApprovedHospitals", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }

  getApprovedDonor() async {
    final response =
        await dio.get("${baseUrl}getApprovedDonor", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }

  getApprovedReceipient() async {
    final response =
        await dio.get("${baseUrl}getApprovedReceipient", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }

  getFeedback() async {
    final response = await dio.get("${baseUrl}getFeedback", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }

  getComplaints() async {
    final response =
        await dio.get("${baseUrl}getComplaint", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }
  
}
