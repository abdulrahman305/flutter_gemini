import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gemini/src/config/constants.dart';
import 'package:flutter_gemini/src/utils/gemini_data_builder.dart';
import 'package:flutter_gemini/src/utils/gemini_model_manager.dart';
import 'package:flutter_gemini/src/utils/gemini_request_handler.dart';
import 'package:flutter_gemini/src/utils/gemini_response_parser.dart';
import 'package:flutter_gemini/src/repository/gemini_interface.dart';
import 'gemini_service.dart';

/// [GeminiImpl]
/// In this class we declare and implement all the functions body
class GeminiImpl implements GeminiInterface {
  final GeminiService _api;
  final GeminiRequestHandler _requestHandler;
  final GeminiModelManager _modelManager;

  GeminiImpl({
    required GeminiService api,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  })  : _api = api,
        _requestHandler = GeminiRequestHandler(api),
        _modelManager = GeminiModelManager(api) {
    _api
      ..safetySettings = safetySettings
      ..generationConfig = generationConfig;
  }

  @override
  Future<List<List<num>?>?> batchEmbedContents(
    List<String> texts, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: 'embedding-001');
    return _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:batchEmbedContents',
      data: GeminiDataBuilder.buildBatchEmbedData(texts),
      responseParser: GeminiResponseParser.parseBatchEmbeddingResponse,
    );
  }

  @override
  Future<Candidates?> chat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
    String? systemPrompt,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: Constants.defaultModel);
    return _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:${Constants.defaultGenerateType}',
      data: GeminiDataBuilder.buildChatData(chats, systemPrompt),
      responseParser: GeminiResponseParser.parseGenerateResponse,
    );
  }

  @override
  Future<int?> countTokens(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: Constants.defaultModel);
    return _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:countTokens',
      data: GeminiDataBuilder.buildTextData(text),
      responseParser: (data) => data['totalTokens'],
    );
  }

  @override
  Future<List<num>?> embedContent(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: 'embedding-001');
    return _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:embedContent',
      data: GeminiDataBuilder.buildEmbedData(text),
      responseParser: (data) =>
          (data['embedding']['values'] as List).cast<num>(),
    );
  }

  @override
  Future<GeminiModel> info({required String model}) async {
    return _requestHandler.executeRequest(
      endpoint: '${Constants.baseUrl}${Constants.defaultVersion}/$model',
      isGetRequest: true,
      responseParser: (data) => GeminiModel.fromJson(data),
    );
  }

  @override
  Future<List<GeminiModel>> listModels() async {
    return _requestHandler.executeRequest(
      endpoint: '${Constants.baseUrl}${Constants.defaultVersion}/models',
      isGetRequest: true,
      responseParser: (data) => GeminiModel.jsonToList(data['models']),
    );
  }

  @override
  Future<Candidates?> text(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: Constants.defaultModel);
    final candidate = await _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:${Constants.defaultGenerateType}',
      data: GeminiDataBuilder.buildTextData(text),
      responseParser: GeminiResponseParser.parseGenerateResponse,
    );
    Gemini.instance.typeProvider?.add(candidate?.output);
    return candidate;
  }

  @override
  Future<Candidates?> textAndImage({
    required String text,
    required List<Uint8List> images,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: 'gemini-1.5-flash');
    return _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:${Constants.defaultGenerateType}',
      data: GeminiDataBuilder.buildTextAndImageData(text, images),
      responseParser: GeminiResponseParser.parseGenerateResponse,
    );
  }

  @override
  Future<Candidates?> prompt({
    required List<Part> parts,
    String? model,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: model, expectedModel: Constants.defaultModel);
    return _requestHandler.executeRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:${Constants.defaultGenerateType}',
      data: GeminiDataBuilder.buildPromptData(parts),
      responseParser: GeminiResponseParser.parseGenerateResponse,
    );
  }

  @override
  Stream<Candidates> streamChat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async* {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: Constants.defaultModel);
    yield* _requestHandler.executeStreamRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:streamGenerateContent',
      data: GeminiDataBuilder.buildChatData(chats, null),
    );
  }

  @override
  Stream<Candidates> streamGenerateContent(
    String text, {
    List<Uint8List>? images,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async* {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: modelName, expectedModel: Constants.defaultModel);
    yield* _requestHandler.executeStreamRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:streamGenerateContent',
      data: GeminiDataBuilder.buildTextAndImageData(text, images),
    );
  }

  @override
  Stream<Candidates?> promptStream({
    required List<Part> parts,
    String? model,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  }) async* {
    final resolvedModel = await _modelManager.resolveModelName(
        userModel: model, expectedModel: Constants.defaultModel);
    yield* _requestHandler.executeStreamRequest(
      endpoint:
          '${Constants.baseUrl}${Constants.defaultVersion}/$resolvedModel:streamGenerateContent',
      data: GeminiDataBuilder.buildPromptData(parts),
    );
  }

  @override
  Future<void> cancelRequest() => _api.cancelRequest();
}
