import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_gemini/src/init.dart';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'package:flutter_gemini/src/models/gemini_response/gemini_response.dart';
import 'package:flutter_gemini/src/utils/candidate_extension.dart';

class GeminiResponseParser {
  static const _splitter = LineSplitter();

  static Candidates? parseGenerateResponse(Map<String, dynamic> responseData) =>
      GeminiResponse.fromJson(responseData).candidates?.lastOrNull;

  static List<List<num>?>? parseBatchEmbeddingResponse(
      Map<String, dynamic> responseData) {
    return (responseData['embeddings'] as List)
        .map((e) => (e['values'] as List).cast<num>())
        .toList();
  }

  static Stream<Candidates> processStreamResponse(
      ResponseBody responseBody) async* {
    int index = 0;
    String modelStr = '';
    List<int> cacheUnits = [];

    await for (final itemList in responseBody.stream) {
      final list = cacheUnits + itemList;
      cacheUnits.clear();

      String res;
      try {
        res = utf8.decode(list);
      } catch (e) {
        log('Error in parsing chunk', error: e, name: 'Gemini_Exception');
        cacheUnits = list;
        continue;
      }

      res = _cleanStreamResponse(res, index == 0);
      yield* _parseStreamLines(
          res, modelStr, (newModelStr) => modelStr = newModelStr);
      index++;
    }
  }

  static Stream<Candidates> _parseStreamLines(String response,
      String currentModelStr, void Function(String) updateModelStr) async* {
    String modelStr = currentModelStr;
    for (final line in _splitter.convert(response)) {
      if (modelStr.isEmpty && line == ',') continue;
      modelStr += line;

      final candidate = _tryParseCandidate(modelStr);
      if (candidate != null) {
        yield candidate;
        Gemini.instance.typeProvider?.add(candidate.output);
        modelStr = '';
      }
    }
    updateModelStr(modelStr);
  }

  static Candidates? _tryParseCandidate(String jsonStr) {
    try {
      final candidateData =
          (jsonDecode(jsonStr)['candidates'] as List?)?.firstOrNull;
      return candidateData != null ? Candidates.fromJson(candidateData) : null;
    } catch (e) {
      return null;
    }
  }

  static String _cleanStreamResponse(String response, bool isFirst) {
    String cleaned = response.trim();
    if (isFirst && cleaned.startsWith('[')) cleaned = cleaned.substring(1);
    if (cleaned.startsWith(',')) cleaned = cleaned.substring(1);
    if (cleaned.endsWith(']')) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }
    return cleaned.trim();
  }
}
