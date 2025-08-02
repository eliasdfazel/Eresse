import 'package:Eresse/preferences/io/PrefencesIO.dart';

class TimesIO {

  final oneDayMillisecond = (60000 * 60 * 24);

  final PreferencesIO _preferencesIO = PreferencesIO();

  Future storeTime(String typeTimePassed, int currentTime, int inputDay) async {
    
    await _preferencesIO.storeInt(typeTimePassed, currentTime + (oneDayMillisecond * inputDay));

  }

  Future<int> _retrieveTime(String typeTimePassed) async {

    return await _preferencesIO.readInt(typeTimePassed) ?? 0;
  }

  Future<bool> daysPassed(String typeTimePassed, int inputPassedDays) async {

    final currentTime = now();

    if (currentTime > await _retrieveTime('${typeTimePassed}_TIME')) {

      // Future Time; currentTime + (oneDayMillisecond * inputPassedDays)
      await storeTime('${typeTimePassed}_TIME', currentTime, inputPassedDays);

      return true;

    } else {

      return false;

    }
  }

}

int now() {

  return DateTime.now().toUtc().millisecondsSinceEpoch;
}