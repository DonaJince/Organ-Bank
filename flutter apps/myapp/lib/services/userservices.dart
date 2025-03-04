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

  getHospitalDetailsByid(String id) async {
    return await dio.get("${baseUrl}getHospitalDetailsById/$id",
        options: options);
  }

  updateUserProfile(String id, String name, String phone) async {
    return await dio.put("${baseUrl}updateUserProfile/$id",
        data: {
          "name": name,
          "phone": phone,
        },
        options: options);
  }

  updateHospitalProfile(String id, String name, String phone, String location,
      String otherphno) async {
    return await dio.put("${baseUrl}updateHospitalProfile/$id",
        data: {
          "name": name,
          "phone": phone,
          "location": location,
          "otherphno": otherphno,
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


  getFeedback() async {
    final response = await dio.get("${baseUrl}getFeedback", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }

  getComplaints() async {
    final response = await dio.get("${baseUrl}getComplaint", options: options);
    return response.data; // Ensure it returns the JSON data correctly
  }

  getBloodType(String userId) async {
    try {
      final response =
          await dio.get("${baseUrl}getBloodType/$userId", options: options);
      print("Blood type response: ${response.data}"); // Debugging
      return response.data; // Ensure it returns the JSON data correctly
    } catch (e) {
      print("Error fetching blood type: $e");
      return {'success': false, 'message': 'Failed to fetch blood type'};
    }
  }

  fetchMatchedDonor(String receipientId, String hospitalId, String bloodType,
      String organ) async {
    try {
      final response = await dio.post("${baseUrl}fetchMatchedDonor",
          data: {
            "receipientid": receipientId,
            "hospitalid": hospitalId,
            "bloodtype": bloodType,
            "organ": organ,
          },
          options: options);
      print("Matched donor response: ${response.data}"); // Debugging
      return response.data; // Ensure it returns the JSON data correctly
    } catch (e) {
      print("Error fetching matched donor: $e");
      return {'success': false, 'message': 'Failed to fetch matched donor'};
    }
  }

  fetchMatchedReceipient(String donorId, String bloodType, String organ) async {
    try {
      final response = await dio.post("${baseUrl}fetchMatchedReceipient",
          data: {
            "donorid": donorId,
            "bloodtype": bloodType,
            "organ": organ,
          },
          options: options);
      print("Matched receipient response: ${response.data}"); // Debugging
      return response.data; // Ensure it returns the JSON data correctly
    } catch (e) {
      print("Error fetching matched receipient: $e");
      return {
        'success': false,
        'message': 'Failed to fetch matched receipient'
      };
    }
  }

  Future<List<String>> getDonatedOrgans(String donorId) async {
    try {
      final response = await dio.get("${baseUrl}getDonatedOrgans/$donorId", options: options);
      print("Donated organs response: ${response.data}"); // Debugging

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('organs')) {
          return List<String>.from(response.data['organs']);
        } else {
          return []; // Return an empty list if the response format is unexpected
        }
      } else {
        return []; // Return an empty list if the status code is not 200
      }
    } catch (e) {
      print("Error fetching donated organs: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<String>> getRequestedOrgans(String receipientId) async {
    try {
      final response = await dio.get("${baseUrl}getRequestedOrgans/$receipientId", options: options);
      print("Requested organs response: ${response.data}"); // Debugging

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic> && response.data.containsKey('organs')) {
          return List<String>.from(response.data['organs']);
        } else {
          return []; // Return an empty list if the response format is unexpected
        }
      } else {
        return []; // Return an empty list if the status code is not 200
      }
    } catch (e) {
      print("Error fetching requested organs: $e");
      return []; // Return an empty list in case of an error
    }
  }

Future<List<Map<String, dynamic>>> getDonations(String donorId) async {
  try {
    final response = await dio.get("${baseUrl}/getDonations/$donorId", options: options);
    print("Donations response: ${response.data}"); // Debugging

    if (response.statusCode == 200 && response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      return []; // Return an empty list instead of null
    }
  } catch (e) {
    print("Error fetching donations: $e");
    return []; // Return empty list on error
  }
}


    Future<Response> updateDonationStatus(String donationId, String newStatus) async {
    try {
      final response = await dio.put(
        "${baseUrl}updateDonationStatus/$donationId",
        data: {"status": newStatus},
        options: options,
      );
      return response;
    } catch (e) {
      print("Error updating donation status: $e");
      throw Exception('Failed to update donation status');
    }
  }


  Future<List<Map<String, dynamic>>> getRequests(String receipientId) async {
    try {
      final response = await dio.get("${baseUrl}getRequests/$receipientId", options: options);
      print("Requests response: ${response.data}");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      print("Error fetching requests: $e");
      throw Exception('Failed to fetch requests');
    }
  }

Future<List<Map<String, dynamic>>> getApprovedMatches(String hospitalId) async {
  try {
    final response = await dio.get("${baseUrl}approvedMatches/$hospitalId");
    print("Approved matches response: ${response.data}");

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((match) => Map<String, dynamic>.from(match as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load approved matches');
    }
  } catch (e) {
    print("Error fetching approved matches: $e");
    throw Exception('Failed to fetch approved matches');
  }
}



  Future<Response> sendTestScheduleEmail(String matchId, String emailBody) async {
    try {
      final response = await dio.post(
        "${baseUrl}sendTestScheduleEmail",
        data: {"matchId": matchId, "emailBody": emailBody},
      );
      return response;
    } catch (e) {
      print("Error sending test schedule email: $e");
      throw Exception('Failed to send test schedule email');
    }
  }

  
  Future<List<Map<String, dynamic>>> getTestScheduledMatches(String hospitalId) async {
    try {
      final response = await dio.get("${baseUrl}testScheduledMatches/$hospitalId");
      print("Test scheduled matches response: ${response.data}");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load test scheduled matches');
      }
    } catch (e) {
      print("Error fetching test scheduled matches: $e");
      throw Exception('Failed to fetch test scheduled matches');
    }
  }

  Future<Response> updateTestResult(String matchId, String testResult) async {
    try {
      final response = await dio.put(
        "${baseUrl}updateTestResult/$matchId",
        data: {"status": testResult},
      );
      return response;
    } catch (e) {
      print("Error updating test result: $e");
      throw Exception('Failed to update test result');
    }
  }

  Future<List<Map<String, dynamic>>> getSuccessMatches(String hospitalId) async {
    try {
      final response = await dio.get("${baseUrl}successMatches/$hospitalId");
      print("Success matches response: ${response.data}");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load success matches');
      }
    } catch (e) {
      print("Error fetching success matches: $e");
      throw Exception('Failed to fetch success matches');
    }
  }

  Future<Response> scheduleTransplantation(String matchId, String emailBody) async {
    try {
      final response = await dio.post(
        "${baseUrl}sendTransplantationScheduleEmail",
        data: {"matchId": matchId, "emailBody": emailBody},
      );
      return response;
    } catch (e) {
      print("Error sending transplantation schedule email: $e");
      throw Exception('Failed to send transplantation schedule email');
    }
  }

Future<List<Map<String, dynamic>>> getTransplantationScheduledMatches(String hospitalId) async {
    try {
      final response = await dio.get("${baseUrl}transplantationScheduledMatches/$hospitalId");
      print("Transplantation scheduled matches response: ${response.data}");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load transplantation scheduled matches');
      }
    } catch (e) {
      print("Error fetching transplantation scheduled matches: $e");
      throw Exception('Failed to fetch transplantation scheduled matches');
    }
  }

  Future<Response> updateTransplantationResult(String matchId, String transplantationResult) async {
    try {
      final response = await dio.put(
        "${baseUrl}updateTransplantationResult/$matchId",
        data: {"status": transplantationResult},
      );
      return response;
    } catch (e) {
      print("Error updating transplantation result: $e");
      throw Exception('Failed to update transplantation result');
    }
  }
  
}