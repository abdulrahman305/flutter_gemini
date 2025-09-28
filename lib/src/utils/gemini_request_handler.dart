import 'package:dio/dio.dart';
import 'package:flutter_gemini/src/utils/gemini_response_parser.dart';
import 'package:flutter_gemini/src/implement/gemini_service.dart';
import 'package:flutter_gemini/src/init.dart';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';

class GeminiRequestHandler {
  final GeminiService _api;

  GeminiRequestHandler(this._api);

  /// Executes a standard API request.
  Future<T> executeRequest<T>({
    required String endpoint,
    Map<String, Object>? data,
    required T Function(Map<String, dynamic>) responseParser,
    bool isGetRequest = false,
  }) async {
    _clearTypeProvider();
    try {
      final Response response = isGetRequest
          ? await _api.get(endpoint)
          : await _api.post(endpoint, data: data);
      return responseParser(response.data);
    } finally {
      _setTypeProviderLoading(false);
    }
  }

  /// Executes a streaming API request.
  Stream<Candidates> executeStreamRequest({
    required String endpoint,
    required Map<String, Object> data,
  }) async* {
    _clearTypeProvider();
    try {
      final response = await _api.post(
        endpoint,
        data: data,
        isStreamResponse: true,
      );

      if (response.statusCode == 200) {
        yield* GeminiResponseParser.processStreamResponse(response.data);
      }
    } finally {
      _setTypeProviderLoading(false);
    }
  }

  void _clearTypeProvider() => Gemini.instance.typeProvider?.clear();
  void _setTypeProviderLoading(bool loading) =>
      Gemini.instance.typeProvider?.loading = loading;
}
