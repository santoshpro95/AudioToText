import 'dart:async';
import 'dart:convert';
import 'package:audio_to_text/model/api_error_response.dart';
import 'package:audio_to_text/utils/api_constants.dart';
import 'package:audio_to_text/utils/app_constants.dart';
import 'package:audio_to_text/utils/app_strings.dart';
import 'package:dio/dio.dart' as dioPackage;

class HttpService {
  // region Common Variables
  var dio = dioPackage.Dio();

  // endregion

  // region Post Api Call
  Future<Map<String, dynamic>> apiCall({var request, required String apiUrl}) async {
    dioPackage.Response apiResponse;

    try {
      // http header
      var header = {"Content-Type": "multipart/form-data", "Authorization": "Bearer ${AppConstants.apiKey}"};

      //  Execute Api Call
      if (request == null) {
        apiResponse = await dio.get(apiUrl, options: dioPackage.Options(headers: header));
      } else {
        apiResponse = await dio.post(apiUrl, data: request, options: dioPackage.Options(headers: header));
      }

      // Log the api request and response
      print("Method: URL: $apiUrl\nBody : $request\nHeader : $header\nResponse : ${json.encode(apiResponse.data)}");

      // region check if response is null
      if (apiResponse.data.isEmpty) {
        throw Exception("$apiUrl returned empty response.");
      }
      // endregion

      // Region - Handle None Http 200
      if (apiResponse.statusCode != 200 && apiResponse.statusCode != 201) {
        throw ApiErrorResponse.fromJson(apiResponse.data);
      }
      // endregion

      // handle socket exception
    } on dioPackage.DioException catch (error) {
      if (error.response == null) {
        if (error.type.index == ApiConstants.noInternet) {
          throw ApiErrorResponse(error: Error(message: AppStrings.noInternet));
        } else {
          throw ApiErrorResponse(error: Error(message: error.message));
        }
      } else {
        throw ApiErrorResponse.fromJson(error.response!.data);
      }
    } on TimeoutException catch (exception) {
      throw ApiErrorResponse(error: Error(message: AppStrings.timeOut));
    }

    return apiResponse.data;
  }

// endregion
}
