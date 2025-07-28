import 'dart:convert';

import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';

class DialoguesJSON {

  Future<String> insertDialogueJson(String sessionJsonContent, ContentType contentType, String content) async {

    final iterableJson = jsonDecode(sessionJsonContent);

    final dialogueJsonArray = List.from(iterableJson);

    dialogueJsonArray.add(dialogueDataStructure(contentType, content));

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

}