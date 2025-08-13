import 'dart:convert';

import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:Eresse/profile/credentials/CredentialsIO.dart';
import 'package:Eresse/utils/security/Encrypter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DialoguesJSON {

  final CredentialsIO _credentialsIO = CredentialsIO();

  Future<String> insertDialogueJson(String sessionJsonContent, ContentType contentType, String dialogueId, String content) async {

    final iterableJson = jsonDecode(sessionJsonContent);

    final dialogueJsonArray = List.from(iterableJson);

    dialogueJsonArray.add(dialogueDataStructure(contentType, dialogueId, content));

    return jsonEncode(dialogueJsonArray);
  }

  Future<List<DialogueSqlDataStructure>> retrieveDialogues(String sessionJsonContent) async {

    List<DialogueSqlDataStructure> dialogues = [];

    final iterableJson = jsonDecode(sessionJsonContent);

    final dialogueJsonArray = List.from(iterableJson);

    for (final element in dialogueJsonArray) {

      dialogues.add(DialogueSqlDataStructure.fromMap(element));

    }

    return dialogues;
  }

  Future<String> dialoguesJsonArray(List<DialogueSqlDataStructure> inputDialogues) async {

    final iterableJson = jsonDecode('[]');

    final dialogueJsonArray = List.from(iterableJson);

    for (final element in inputDialogues) {

      dialogueJsonArray.add(element.toMap());

    }

    return jsonEncode(dialogueJsonArray);
  }

  Future<String> documentsToJson(List<DocumentSnapshot> dialogueDocuments) async {

    final iterableJson = jsonDecode('[]');

    final dialogueJsonArray = List.from(iterableJson);

    for (final dialogues in dialogueDocuments) {

      if (dialogues.exists) {

        dialogueJsonArray.add(dialogues.data() as Map<String, dynamic>);

      }

    }

    return jsonEncode(dialogueJsonArray);
  }

  Future<String> messageInput({String? textMessage , String? imageMessage}) async {

    return jsonEncode({
      MessageContent.textMessage.name: (await textMessage?.encrypt(_credentialsIO)) ?? '',
      MessageContent.imageMessage.name: imageMessage ?? ''
    });
  }

  Future<Map<String, String>> messageExtract(String content) async {

    return {
      MessageContent.textMessage.name: (await jsonDecode(content)[MessageContent.textMessage.name].toString().decrypt(_credentialsIO)),
      MessageContent.imageMessage.name: jsonDecode(content)[MessageContent.imageMessage.name]
    };
  }

}