import 'package:Eresse/preferences/io/PrefencesIO.dart';
import 'package:Eresse/utils/time/TimesIO.dart';

class CacheIO {

  final PreferencesIO _preferencesIO = PreferencesIO();

  final TimesIO _timesIO = TimesIO();

  Future store(String inputKey, String inputData, {int cacheTime = 7}) async {

    await _preferencesIO.store(inputKey, inputData);

  }

  Future<String?> retrieve(String inputKey, {int cacheTime = 7}) async {

    if (await _timesIO.daysPassed(inputKey, cacheTime)) {

      return null;

    } else {

      return await _preferencesIO.read(inputKey);

    }
  }

}