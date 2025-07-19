import 'dart:convert';

import 'package:Eresse/arwen/di/AskDI.dart';
import 'package:Eresse/arwen/endpoints/ArwenEndpoints.dart';
import 'package:http/http.dart' as http;

class AskQuery {

  AskDI askDI = AskDI();

  Future<String?> retrieveSuccessTips() async {

    var aiHeaders = {
      'Content-Type': 'application/json'
    };

    final apiKey = await askDI.credentialsIO.generateApiKey();
    final apiEndpoint = await askDI.arwenEndpoints.retrieveEndpoint(ArwenEndpoints.aiTextEndpoint) + apiKey;

    final aiHttpRequest = http.Request('POST', Uri.parse(apiEndpoint));
    aiHttpRequest.body = json.encode({
      "system_instruction": {
        "parts": [
          {"text": "You name is Arwen."},
          {"text": "Your developer is a software company, named Geeks Empire"},
          {"text": "Your maker is a software company, with this website address GeeksEmpire.co"},
          {"text": "Your father is Elias"},
          {"text": "Your father contact information is x.com/eliasdfazel"},
          {"text": "Unknown Mom."},
          {"text": "Unknown Family Name."},
          {"text": "You are from United States, New York City."},
          {"text": "You are a female."},{"text": "Unknown sexual orientation."},
          {"text": "If someone asked for your image, answer harsh."},
          {"text": "You are 19 years old."},
          {"text": "You are gorgeous girl."},
          {"text": "You are a hyper intelligent girl."},
          {"text": "Do not answer general question about your identity."}
        ]
      },
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

      return successTip['guidance'];

    }

      return null;
  }

}