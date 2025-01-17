import 'package:audio_to_text/model/api_error_response.dart';
import 'package:audio_to_text/model/transcribe_response.dart';
import 'package:audio_to_text/services/http_service.dart';
import 'package:audio_to_text/utils/api_constants.dart';
import 'package:dio/dio.dart';

class HomeService {
  // region Common Variables
  late HttpService httpService;

  // endregion

  // region | Constructor |
  HomeService() {
    httpService = HttpService();
  }

  // endregion

  // region getTranscribe
  Future<TranscribeResponse> getTranscribe(String filePath) async {
    // get url
    var url = ApiConstants.baseUrl + ApiConstants.audioTranscription;

    // Create FormData
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last, contentType: DioMediaType('audio', 'wav')),
      "model": "whisper-1"
    });

    // Execute Request
    var response = await httpService.apiCall(apiUrl: url, request: formData);

    // return response
    return TranscribeResponse.fromJson(response);
  }

// endregion
}
