import 'dart:convert';

import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DialoguesJSON {

  Future<String> insertDialogueJson(String sessionJsonContent, ContentType contentType, String dialogueId, String content) async {

    final iterableJson = jsonDecode(sessionJsonContent);

    final dialogueJsonArray = List.from(iterableJson);

    dialogueJsonArray.add("$dialogueId: ${dialogueDataStructure(contentType, dialogueId, content)}");

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

}