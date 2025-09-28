import '../models/gemini_model/gemini_model.dart';

class Constants {
  Constants._();

  static const String defaultModel = 'models/gemini-2.5-flash';
  static const String defaultVersion = 'v1';
  static const String defaultGenerateType = 'generateContent';
  static const String baseUrl = 'https://generativelanguage.googleapis.com/';

  static List<GeminiModel> get geminiDefaultModels => [
        {
          "name": "models/gemini-2.5-pro",
          "version": "001",
          "displayName": "Gemini 2.5 Pro",
          "description":
              "Our most powerful thinking model with maximum response accuracy and state-of-the-art performance. Best for complex coding, reasoning, and multimodal understanding.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 65536,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.9,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-2.5-flash",
          "version": "001",
          "displayName": "Gemini 2.5 Flash",
          "description":
              "Our best model in terms of price-performance, offering well-rounded capabilities. Best for low latency, high volume tasks that require thinking.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 65536,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-2.5-flash-lite",
          "version": "001",
          "displayName": "Gemini 2.5 Flash-Lite",
          "description":
              "A Gemini 2.5 Flash model optimized for cost-efficiency and high throughput.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 65536,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-2.0-flash-001",
          "version": "001",
          "displayName": "Gemini 2.0 Flash",
          "description":
              "Second generation model with next-gen features including superior speed, native tool use, and 1M token context window.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-2.0-flash-lite-001",
          "version": "001",
          "displayName": "Gemini 2.0 Flash-Lite",
          "description":
              "A Gemini 2.0 Flash model optimized for cost efficiency and low latency.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-1.5-flash",
          "version": "002",
          "displayName": "Gemini 1.5 Flash",
          "description":
              "Fast and versatile multimodal model for scaling across diverse tasks. (Previous generation)",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-1.5-pro",
          "version": "002",
          "displayName": "Gemini 1.5 Pro",
          "description":
              "Mid-size multimodal model optimized for wide-range reasoning tasks. Can process large amounts of data. (Previous generation)",
          "inputTokenLimit": 2097152,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "countTokens"],
          "temperature": 0.9,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-embedding-001",
          "version": "001",
          "displayName": "Gemini Embedding",
          "description":
              "Obtain a distributed representation of a text with latest embedding capabilities.",
          "inputTokenLimit": 2048,
          "outputTokenLimit": 1,
          "supportedGenerationMethods": ["embedContent", "countTokens"]
        },
        {
          "name": "models/text-embedding-005",
          "version": "005",
          "displayName": "Text Embedding 005",
          "description":
              "Latest text embedding model with improved performance.",
          "inputTokenLimit": 2048,
          "outputTokenLimit": 1,
          "supportedGenerationMethods": ["embedContent", "countTokens"]
        },
        {
          "name": "models/text-embedding-004",
          "version": "004",
          "displayName": "Text Embedding 004",
          "description": "Text embedding model with robust performance.",
          "inputTokenLimit": 2048,
          "outputTokenLimit": 1,
          "supportedGenerationMethods": ["embedContent", "countTokens"]
        },
        {
          "name": "models/text-multilingual-embedding-002",
          "version": "002",
          "displayName": "Multilingual Text Embedding",
          "description":
              "Multilingual text embedding model supporting various languages.",
          "inputTokenLimit": 2048,
          "outputTokenLimit": 1,
          "supportedGenerationMethods": ["embedContent", "countTokens"]
        }
      ].map((e) => GeminiModel.fromJson(e)).toList();

  static List<GeminiModel> get geminiLiveModels => [
        {
          "name": "models/gemini-live-2.5-flash-preview",
          "version": "preview",
          "displayName": "Gemini 2.5 Flash Live",
          "description":
              "Low-latency bidirectional voice and video interactions with Gemini 2.5 Flash.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "liveApi"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        },
        {
          "name": "models/gemini-2.0-flash-live-001",
          "version": "001",
          "displayName": "Gemini 2.0 Flash Live",
          "description":
              "Low-latency bidirectional voice and video interactions with Gemini 2.0 Flash.",
          "inputTokenLimit": 1048576,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "liveApi"],
          "temperature": 0.4,
          "topP": 1,
          "topK": 32
        }
      ].map((e) => GeminiModel.fromJson(e)).toList();

  static List<GeminiModel> get geminiSpecializedModels => [
        {
          "name": "models/gemini-2.5-flash-image-preview",
          "version": "preview",
          "displayName": "Gemini 2.5 Flash Image",
          "description":
              "Generate and edit images conversationally with Gemini 2.5 Flash.",
          "inputTokenLimit": 32768,
          "outputTokenLimit": 32768,
          "supportedGenerationMethods": ["generateContent", "imageGeneration"]
        },
        {
          "name": "models/gemini-2.0-flash-preview-image-generation",
          "version": "preview",
          "displayName": "Gemini 2.0 Flash Image Generation",
          "description":
              "Generate and edit images conversationally with Gemini 2.0 Flash.",
          "inputTokenLimit": 32000,
          "outputTokenLimit": 8192,
          "supportedGenerationMethods": ["generateContent", "imageGeneration"]
        },
        {
          "name": "models/gemini-2.5-flash-preview-tts",
          "version": "preview",
          "displayName": "Gemini 2.5 Flash TTS",
          "description":
              "Price-performant text-to-speech model with high control and transparency.",
          "inputTokenLimit": 8000,
          "outputTokenLimit": 16000,
          "supportedGenerationMethods": ["textToSpeech"]
        },
        {
          "name": "models/gemini-2.5-pro-preview-tts",
          "version": "preview",
          "displayName": "Gemini 2.5 Pro TTS",
          "description":
              "Most powerful text-to-speech model with high control and transparency.",
          "inputTokenLimit": 8000,
          "outputTokenLimit": 16000,
          "supportedGenerationMethods": ["textToSpeech"]
        }
      ].map((e) => GeminiModel.fromJson(e)).toList();

  static List<GeminiModel> get allGeminiModels => [
        ...geminiDefaultModels,
        ...geminiLiveModels,
        ...geminiSpecializedModels,
      ];
}
