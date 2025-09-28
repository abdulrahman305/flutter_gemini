import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_gemini/src/models/content/content.dart';
import 'package:flutter_gemini/src/models/part/part.dart';
import 'package:mime/mime.dart';

class GeminiDataBuilder {
  static Map<String, Object> buildTextData(String text) => {
        'contents': [
          {
            'parts': [
              {'text': text}
            ]
          }
        ]
      };

  static Map<String, Object> buildTextAndImageData(
      String text, List<Uint8List>? images) {
    final parts = <Map<String, Object>>[
      {'text': text},
      if (images != null)
        ...images.map((image) => {
              'inline_data': {
                'mime_type':
                    lookupMimeType('', headerBytes: image) ?? 'image/jpeg',
                'data': base64Encode(image),
              }
            })
    ];
    return {
      'contents': [
        {'parts': parts}
      ]
    };
  }

  static Map<String, Object> buildChatData(
      List<Content> chats, String? systemPrompt) {
    final data = <String, Object>{
      'contents': chats.map((e) => e.toJson()).toList(),
    };
    if (systemPrompt != null) {
      data['system_instruction'] = {
        'parts': [
          {'text': systemPrompt}
        ]
      };
    }
    return data;
  }

  static Map<String, Object> buildPromptData(List<Part> parts) => {
        'contents': [
          {'parts': parts.map((e) => Part.toJson(e)).toList()}
        ]
      };

  static Map<String, Object> buildEmbedData(String text) => {
        'model': 'embedding-001',
        'content': {
          'parts': [
            {'text': text}
          ]
        }
      };

  static Map<String, Object> buildBatchEmbedData(List<String> texts) => {
        'requests': texts
            .map((text) => {
                  'model': 'models/embedding-001',
                  'content': {
                    'parts': [
                      {'text': text}
                    ]
                  }
                })
            .toList()
      };
}
