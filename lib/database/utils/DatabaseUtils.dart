import 'package:Eresse/database/structures/SessionDataStructure.dart';

bool databaseContextThreshold(int contentLength) {

  return (contentLength % SessionDataStructure.contextThreshold == 0
      || (contentLength - 1) % SessionDataStructure.contextThreshold == 0
      || (contentLength + 1) % SessionDataStructure.contextThreshold == 0);
}