import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/utils/time/TimesIO.dart';

Future<bool> databaseContextThreshold(int contentLength, TimesIO timesIO) async {

  return (contentLength % SessionDataStructure.contextThreshold == 0
      || (contentLength - 1) % SessionDataStructure.contextThreshold == 0
      || (contentLength + 1) % SessionDataStructure.contextThreshold == 0)
      && (await timesIO.daysPassed('DatabaseContextThreshold', 7));
}