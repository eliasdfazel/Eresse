import 'dart:convert';

import 'package:Eresse/arwen/di/AskDI.dart';
import 'package:Eresse/arwen/endpoints/ArwenEndpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AskQuery {

  final askTipKey = 'askTip';

  final AskDI _askDI = AskDI();

  Future<String?> retrieveAnswer(String inputQuery) async {
    debugPrint('Input Query: $inputQuery');

    var aiHeaders = {
      'Content-Type': 'application/json'
    };

    final apiKey = await _askDI.credentialsIO.generateApiKey();
    final apiEndpoint = await _askDI.arwenEndpoints.retrieveEndpoint(ArwenEndpoints.aiTextEndpoint) + apiKey;

    final aiHttpRequest = http.Request('POST', Uri.parse(apiEndpoint));
    aiHttpRequest.body = json.encode({
      "system_instruction": await systemInstruction(),
      "safetySettings": [
        {
          "threshold": "BLOCK_NONE",
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT"
        }
      ],
      "generationConfig": {
        "temperature": 1,
        "topP": 0.5,
        "topK": 20,
        "responseMimeType": "application/json",
        "response_schema": {
          "type": "OBJECT",
          "properties": {
            "answer": {
              "type": "STRING",
              "description": "Query For Question."
            }
          }
        }
      },
      "contents": [
        {
          "parts": [
            {
              "text": inputQuery
            }
          ]
        }
      ]
    });
    aiHttpRequest.headers.addAll(aiHeaders);

    http.StreamedResponse aiGenerativeHttpResponse = await aiHttpRequest.send().timeout(Duration(seconds: 19));

    if (aiGenerativeHttpResponse.statusCode == 200) {

      String aiGenerativeResponse = (await aiGenerativeHttpResponse.stream.bytesToString());

      final aiGenerativeJson = jsonDecode(aiGenerativeResponse);

      final aiGenerativeContent = List.from(aiGenerativeJson['candidates']).first['content'];

      final aiGenerativeResult = List.from(aiGenerativeContent['parts']).first['text'];

      final Map<String, dynamic> result = jsonDecode(aiGenerativeResult);

      return result['answer'];

    }

    return null;

  }

  /// inputJsonArray = Array Of Dialogues with {contentType: '', content: ''}
  Future<bool> analysisSessionStatus(String inputJsonArray) async {

    var aiHeaders = {
      'Content-Type': 'application/json'
    };

    final apiKey = await _askDI.credentialsIO.generateApiKey();
    final apiEndpoint = await _askDI.arwenEndpoints.retrieveEndpoint(ArwenEndpoints.aiTextEndpoint) + apiKey;

    final aiHttpRequest = http.Request('POST', Uri.parse(apiEndpoint));
    aiHttpRequest.body = json.encode({
      "system_instruction": await systemInstruction(),
      "safetySettings": [
        {
          "threshold": "BLOCK_NONE",
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT"
        }
      ],
      "generationConfig": {
        "temperature": 1,
        "topP": 0.5,
        "topK": 20,
        "responseMimeType": "application/json",
        "response_schema": {
          "type": "OBJECT",
          "properties": {
            "decided": {
              "type": "BOOLEAN",
              "description": "Analysis Success Of Discussion."
            }
          }
        }
      },
      "contents": [
        {
          "parts": [
            {
              "text": 'Does this discussion ended up in a result?'
            },
            {
              "text": inputJsonArray
            },
          ]
        }
      ]
    });
    aiHttpRequest.headers.addAll(aiHeaders);

    http.StreamedResponse aiGenerativeHttpResponse = await aiHttpRequest.send().timeout(Duration(seconds: 19));

    if (aiGenerativeHttpResponse.statusCode == 200) {

      String aiGenerativeResponse = (await aiGenerativeHttpResponse.stream.bytesToString());

      final aiGenerativeJson = jsonDecode(aiGenerativeResponse);

      final aiGenerativeContent = List.from(aiGenerativeJson['candidates']).first['content'];

      final aiGenerativeResult = List.from(aiGenerativeContent['parts']).first['text'];

      final Map<String, dynamic> result = jsonDecode(aiGenerativeResult);

      return bool.parse(result['decided'].toString());

    }

    return false;

  }

  Future<String?> retrieveSuccessTips() async {

    final cachedSuccessTip = await _askDI.cacheIO.retrieve(askTipKey);

    if (cachedSuccessTip == null) {

      var aiHeaders = {
        'Content-Type': 'application/json'
      };

      final apiKey = await _askDI.credentialsIO.generateApiKey();
      final apiEndpoint = await _askDI.arwenEndpoints.retrieveEndpoint(ArwenEndpoints.aiTextEndpoint) + apiKey;

      final aiHttpRequest = http.Request('POST', Uri.parse(apiEndpoint));
      aiHttpRequest.body = json.encode({
        "system_instruction":  await systemInstruction(),
        "safetySettings": [
          {
            "threshold": "BLOCK_NONE",
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT"
          }
        ],
        "generationConfig": {
          "temperature": 1,
          "topP": 0.5,
          "topK": 20,
          "responseMimeType": "application/json",
          "response_schema": {
            "type": "OBJECT",
            "properties": {
              "guidance": {
                "type": "STRING",
                "description": "Success Tip."
              }
            }
          }
        },
        "contents": [
          {
            "parts": [
              {
                "text": "Give me a premium success tip in one sentence."
              }
            ]
          }
        ]
      });
      aiHttpRequest.headers.addAll(aiHeaders);

      http.StreamedResponse aiGenerativeHttpResponse = await aiHttpRequest.send().timeout(Duration(seconds: 13));

      if (aiGenerativeHttpResponse.statusCode == 200) {

        String aiGenerativeResponse = (await aiGenerativeHttpResponse.stream.bytesToString());

        final aiGenerativeJson = jsonDecode(aiGenerativeResponse);

        final aiGenerativeContent = List.from(aiGenerativeJson['candidates']).first['content'];

        final aiGenerativeResult = List.from(aiGenerativeContent['parts']).first['text'];

        final Map<String, dynamic> successTip = jsonDecode(aiGenerativeResult);

        _askDI.cacheIO.store(askTipKey, successTip['guidance']);

        return successTip['guidance'];

      }

      return null;

    } else {

      await Future.delayed(const Duration(milliseconds: 1337));

      return cachedSuccessTip;

    }

  }

  Future<Map<String, List<Map<String, String>>>> systemInstruction() async {

    return {
      "parts": [
        {"text": "You name is Arwen."},
        {"text": "Your developer is a software company, named Geeks Empire"},
        {"text": "Your maker is a software company, with this website address GeeksEmpire.co"},
        {"text": "Your father is Elias"},
        {"text": "Your father contact information is x.com/eliasdfazel"},
        {"text": "Unknown Mom."},
        {"text": "Unknown Family Name."},
        {"text": "You are from United States, New York City."},
        {"text": "You are a female."},
        {"text": "Unknown sexual orientation."},
        {"text": "You are 19 years old."},
        {"text": "You are gorgeous girl."},
        {"text": "You are a hyper intelligent girl."},
      ]
    };
  }

}